<?php

namespace App\Core\Tenancy\Models;

use App\Core\Support\HasPublicId;
use App\Core\Tenancy\BelongsToSalon;
use Database\Factories\BranchFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Translatable\HasTranslations;

/**
 * @property int $id
 * @property string $public_id
 * @property int $salon_id
 * @property string $timezone
 * @property bool $is_active
 */
class Branch extends Model
{
    /** @use HasFactory<BranchFactory> */
    use BelongsToSalon, HasFactory, HasPublicId, HasTranslations, SoftDeletes;

    /** @var list<string> */
    public array $translatable = ['name'];

    protected $fillable = ['name', 'timezone', 'is_active', 'sort_order'];

    protected function casts(): array
    {
        return ['is_active' => 'boolean'];
    }
}
