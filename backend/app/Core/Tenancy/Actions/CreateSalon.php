<?php

namespace App\Core\Tenancy\Actions;

use App\Core\Audit\AuditLogger;
use App\Core\Authorization\PermissionCatalog;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Models\Branch;
use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Tenancy;
use Illuminate\Support\Facades\DB;
use InvalidArgumentException;

/**
 * Creates a salon with its first branch and makes $owner its Owner.
 * Used by seeding now and by Billing onboarding later (modules.md).
 */
final class CreateSalon
{
    public function __construct(private readonly AddMember $addMember) {}

    /**
     * @param  array{ar: string, en: string}  $name
     * @param  array{ar: string, en: string}|null  $branchName
     */
    public function __invoke(array $name, string $slug, User $owner, ?array $branchName = null, string $currency = 'QAR', string $timezone = 'Asia/Qatar'): Salon
    {
        $slug = strtolower($slug);
        if (in_array($slug, Salon::RESERVED_SLUGS, true) || ! preg_match('/^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$/', $slug)) {
            throw new InvalidArgumentException("Invalid salon slug [{$slug}].");
        }

        return DB::transaction(function () use ($name, $slug, $owner, $branchName, $currency, $timezone): Salon {
            $salon = Salon::query()->create([
                'name' => $name,
                'slug' => $slug,
                'currency' => $currency,
                'timezone' => $timezone,
                'default_locale' => 'ar',
                'status' => Salon::STATUS_ACTIVE,
            ]);

            Tenancy::runAs($salon, function () use ($salon, $owner, $branchName, $name, $timezone): void {
                $branch = Branch::query()->create([
                    'name' => $branchName ?? $name,
                    'timezone' => $timezone,
                    'is_active' => true,
                ]);

                ($this->addMember)($salon, $owner, [PermissionCatalog::OWNER], [$branch]);
                AuditLogger::record('salon.created', $salon, new: ['slug' => $salon->slug], salonId: (int) $salon->getKey());
            });

            return $salon;
        });
    }
}
