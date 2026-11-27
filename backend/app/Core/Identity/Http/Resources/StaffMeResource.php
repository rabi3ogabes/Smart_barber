<?php

namespace App\Core\Identity\Http\Resources;

use App\Core\Authorization\Access;
use App\Core\Features\Feature;
use App\Core\Identity\Models\User;
use App\Core\Tenancy\Tenancy;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * The signed-in staff member inside the token's salon.
 *
 * @mixin User
 */
final class StaffMeResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $salon = Tenancy::current();

        return [
            'user' => [
                'id' => $this->public_id,
                'name' => $this->name,
                'email' => $this->email,
                'phone' => $this->phone,
                'locale' => $this->locale,
                'two_factor_enabled' => $this->hasTwoFactorEnabled(),
            ],
            'salon' => $salon === null ? null : [
                'id' => $salon->public_id,
                'slug' => $salon->slug,
                'name' => $salon->getTranslations('name'),
                'currency' => $salon->currency,
                'timezone' => $salon->timezone,
            ],
            'roles' => Access::roles($this->resource),
            'permissions' => Access::permissions($this->resource),
            'branches' => Access::visibleBranches($this->resource)->map(fn ($b) => [
                'id' => $b->public_id,
                'name' => $b->getTranslations('name'),
            ])->values(),
            'features' => $salon === null ? [] : Feature::enabledFor($salon),
        ];
    }
}
