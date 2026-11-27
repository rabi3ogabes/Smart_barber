<?php

namespace App\Core\Settings;

use App\Core\Tenancy\BelongsToSalon;
use Illuminate\Database\Eloquent\Model;

/**
 * Salon- or branch-level key/value setting.
 *
 * @property string $key
 * @property mixed $value
 */
class Setting extends Model
{
    use BelongsToSalon;

    protected $fillable = ['settable_type', 'settable_id', 'key', 'value'];

    protected function casts(): array
    {
        return ['value' => 'json'];
    }
}
