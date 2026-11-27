<?php

namespace App\Modules\Catalog\Actions;

use App\Modules\Catalog\Models\BarberService;
use App\Modules\Catalog\Models\Service;
use App\Modules\Catalog\Support\PriceAudit;
use App\Modules\Staff\Models\Barber;
use Illuminate\Support\Facades\DB;

/**
 * Sets which barbers perform a service, with optional own price and duration. Existing price
 * overrides are kept when $canChangePrice is false (roles without salon-wide price rights).
 */
final class AssignBarberServices
{
    /**
     * @param  list<array{barber: string, price_override: int|null, duration_override: int|null}>  $rows
     */
    public function __invoke(Service $service, array $rows, bool $canChangePrice): void
    {
        DB::transaction(function () use ($service, $rows, $canChangePrice): void {
            $before = $this->prices($service);
            $barbers = Barber::query()->whereIn('public_id', array_column($rows, 'barber'))->get()->keyBy('public_id');
            $existing = BarberService::query()->where('service_id', $service->id)->get()->keyBy('barber_id');

            $keep = [];
            foreach ($rows as $r) {
                $barber = $barbers->get($r['barber']) ?? abort(404);
                $keep[] = $barber->id;
                $row = $existing->get($barber->id) ?? new BarberService(['barber_id' => $barber->id, 'service_id' => $service->id]);
                $row->duration_override = $r['duration_override'];
                if ($canChangePrice) {
                    $row->price_override = $r['price_override'];
                }
                $row->save();
            }
            $existing->reject(fn (BarberService $row) => in_array($row->barber_id, $keep, true))->each->delete();

            PriceAudit::record($service, 'barber', ['barber_prices' => $before], ['barber_prices' => $this->prices($service)]);
        });
    }

    /**
     * @return array<string, int|null> barber public id → price override (null = branch/base price)
     */
    private function prices(Service $service): array
    {
        $rows = BarberService::query()->where('service_id', $service->id)->get();
        $ids = Barber::withTrashed()->whereIn('id', $rows->pluck('barber_id'))->pluck('public_id', 'id');
        $out = [];
        foreach ($rows as $row) {
            $out[(string) $ids[$row->barber_id]] = $row->price_override;
        }
        ksort($out);

        return $out;
    }
}
