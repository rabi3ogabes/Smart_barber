<?php

namespace App\Core\Settings;

use Illuminate\Database\Eloquent\Model;

final class Settings
{
    public static function get(Model $settable, string $key, mixed $default = null): mixed
    {
        $setting = Setting::query()
            ->where('settable_type', $settable->getMorphClass())
            ->where('settable_id', $settable->getKey())
            ->where('key', $key)
            ->first();

        return $setting === null ? $default : $setting->value;
    }

    public static function set(Model $settable, string $key, mixed $value): void
    {
        Setting::query()->updateOrCreate(
            ['settable_type' => $settable->getMorphClass(), 'settable_id' => $settable->getKey(), 'key' => $key],
            ['value' => $value],
        );
    }
}
