<?php

namespace App\Modules\Staff\Enums;

enum TimeOffStatus: string
{
    case Pending = 'pending';
    case Approved = 'approved';
    case Rejected = 'rejected';
    case Cancelled = 'cancelled';
}
