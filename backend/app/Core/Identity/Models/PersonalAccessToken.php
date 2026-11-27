<?php

namespace App\Core\Identity\Models;

use Laravel\Sanctum\PersonalAccessToken as SanctumToken;

/**
 * Sanctum access token with the salon it is bound to (staff) and its refresh family.
 *
 * @property int|null $salon_id
 * @property string|null $refresh_family
 */
class PersonalAccessToken extends SanctumToken
{
    protected $fillable = ['name', 'token', 'abilities', 'expires_at', 'salon_id', 'refresh_family'];
}
