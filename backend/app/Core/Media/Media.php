<?php

namespace App\Core\Media;

use App\Core\Tenancy\BelongsToSalon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\MorphTo;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * Every stored file. Tables reference media by id, never by raw path.
 *
 * @property int $id
 * @property int $salon_id
 * @property string $collection
 * @property string $disk
 * @property string $path
 * @property string $mime
 * @property int $size_bytes
 * @property string $visibility
 * @property bool $contains_pii
 */
class Media extends Model
{
    use BelongsToSalon, SoftDeletes;

    protected $table = 'media';

    protected $fillable = ['collection', 'disk', 'path', 'mime', 'size_bytes', 'width', 'height', 'variants', 'visibility', 'contains_pii', 'delete_after'];

    protected function casts(): array
    {
        return ['variants' => 'array', 'contains_pii' => 'boolean', 'delete_after' => 'datetime'];
    }

    /**
     * @return MorphTo<Model, $this>
     */
    public function owner(): MorphTo
    {
        return $this->morphTo();
    }
}
