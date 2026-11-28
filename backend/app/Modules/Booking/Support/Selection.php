<?php

namespace App\Modules\Booking\Support;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Models\ServiceAddon;
use App\Modules\Catalog\Models\ServiceBundle;

/**
 * What the customer wants done: services, add-ons and bundles, resolved from public ids in the
 * current salon (anything unknown is a 404, so another salon's ids never resolve).
 */
final readonly class Selection
{
    /**
     * @param  list<Service>  $services
     * @param  list<ServiceAddon>  $addons
     * @param  list<ServiceBundle>  $bundles
     */
    public function __construct(public array $services, public array $addons = [], public array $bundles = []) {}

    /**
     * @param  list<string>  $services
     * @param  list<string>  $addons
     * @param  list<string>  $bundles
     */
    public static function fromPublicIds(array $services, array $addons = [], array $bundles = []): self
    {
        $selection = new self(
            self::ordered(Service::query()->whereIn('public_id', $services)->get()->keyBy('public_id')->all(), $services),
            self::ordered(ServiceAddon::query()->whereIn('public_id', $addons)->get()->keyBy('public_id')->all(), $addons),
            self::ordered(ServiceBundle::query()->with('services')->whereIn('public_id', $bundles)->get()->keyBy('public_id')->all(), $bundles),
        );
        if ($selection->services === [] && $selection->bundles === []) {
            throw new AppException(ErrorCode::CatalogSelectionInvalid, errors: ['services' => [ErrorCode::CatalogSelectionInvalid->message()]]);
        }

        return $selection;
    }

    /**
     * Models in the order the ids were given; any unknown id (or another salon's) is a 404.
     *
     * @template T of \Illuminate\Database\Eloquent\Model
     *
     * @param  array<string, T>  $found
     * @param  list<string>  $ids
     * @return list<T>
     */
    private static function ordered(array $found, array $ids): array
    {
        $ids = array_values(array_unique($ids));
        if (count($found) !== count($ids)) {
            throw new AppException(ErrorCode::NotFound);
        }

        return array_map(fn (string $id) => $found[$id] ?? throw new AppException(ErrorCode::NotFound), $ids);
    }

    /**
     * Every service performed, including the services inside bundles.
     *
     * @return list<int>
     */
    public function allServiceIds(): array
    {
        $ids = array_map(fn (Service $s) => $s->id, $this->services);
        foreach ($this->bundles as $bundle) {
            foreach ($bundle->services as $s) {
                $ids[] = $s->id;
            }
        }

        return array_values(array_unique($ids));
    }

    /**
     * @return array{services: list<int>, addons: list<int>, bundles: list<int>}
     */
    public function ids(): array
    {
        return [
            'services' => array_map(fn ($m) => $m->id, $this->services),
            'addons' => array_map(fn ($m) => $m->id, $this->addons),
            'bundles' => array_map(fn ($m) => $m->id, $this->bundles),
        ];
    }
}
