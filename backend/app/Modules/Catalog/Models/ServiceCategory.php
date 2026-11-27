<?php

namespace App\Modules\Catalog\Models;

use App\Core\Audit\Auditable;
use App\Core\Support\HasPublicId;
use App\Core\Tenancy\BelongsToSalon;
use Database\Factories\ServiceCategoryFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Spatie\Translatable\HasTranslations;

/**
 * @property int $id
 * @property string $public_id
 * @property int $salon_id
 * @property string|null $icon
 * @property int $sort_order
 * @property bool $is_active
 */
class ServiceCategory extends Model
{
    use Auditable, BelongsToSalon, HasPublicId, HasTranslations, SoftDeletes;

    /** @use HasFactory<ServiceCategoryFactory> */
    use HasFactory;

    public const ICONS = ['scissors', 'sparkles', 'droplet', 'spray-can', 'baby', 'crown', 'brush', 'smile', 'flame', 'star'];

    /** @var list<string> */
    public array $translatable = ['name'];

    /** Mirrors the column defaults so new models are complete before a refresh. */
    protected $attributes = ['sort_order' => 0, 'is_active' => true];

    protected $fillable = ['name', 'icon', 'sort_order', 'is_active'];

    protected function casts(): array
    {
        return ['is_active' => 'boolean', 'sort_order' => 'integer'];
    }

    /**
     * @return HasMany<Service, $this>
     */
    public function services(): HasMany
    {
        return $this->hasMany(Service::class, 'category_id');
    }
}
