<?php

namespace App\Modules\Staff\Enums;

enum TimeOffType: string
{
    case Annual = 'annual';
    case Sick = 'sick';
    case Personal = 'personal';
    case Other = 'other';
}
