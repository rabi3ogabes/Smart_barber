<?php

namespace App\Modules\Staff\Actions;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;
use App\Core\Tenancy\Models\SalonMembership;
use Illuminate\Support\Facades\DB;

final class EnsureOwnerRemains
{
    /**
     * Throws when $leaving is the salon's last active owner.
     */
    public static function check(SalonMembership $leaving): void
    {
        $others = DB::table('model_has_roles')
            ->join('roles', 'roles.id', '=', 'model_has_roles.role_id')
            ->join('salon_user', fn ($j) => $j->on('salon_user.user_id', '=', 'model_has_roles.model_id')->on('salon_user.salon_id', '=', 'model_has_roles.salon_id'))
            ->where('model_has_roles.salon_id', $leaving->salon_id)
            ->where('model_has_roles.model_type', 'user')
            ->where('roles.name', 'owner')
            ->where('salon_user.status', SalonMembership::STATUS_ACTIVE)
            ->where('salon_user.id', '!=', $leaving->id)
            ->exists();

        if (! $others) {
            throw new AppException(ErrorCode::LastActiveOwner);
        }
    }
}
