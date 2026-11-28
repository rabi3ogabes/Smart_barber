<?php

namespace App\Core\Identity\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * A file owned by a global customer account (its avatar), not by a salon (ADR-009). Private disk,
 * served through temporary signed URLs like tenant media.
 *
 * @property int $id
 * @property int $customer_account_id
 * @property string $collection
 * @property string $disk
 * @property string $path
 * @property string $mime
 * @property int $size_bytes
 * @property int|null $width
 * @property int|null $height
 */
class AccountMedia extends Model
{
    protected $table = 'account_media';

    protected $fillable = ['collection', 'disk', 'path', 'mime', 'size_bytes', 'width', 'height', 'variants'];

    protected function casts(): array
    {
        return ['variants' => 'array'];
    }

    /** @return BelongsTo<CustomerAccount, $this> */
    public function account(): BelongsTo
    {
        return $this->belongsTo(CustomerAccount::class, 'customer_account_id');
    }
}
