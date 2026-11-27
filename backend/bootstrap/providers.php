<?php

use App\Core\CoreServiceProvider;
use App\Modules\Salon\SalonServiceProvider;
use App\Modules\Staff\StaffServiceProvider;
use App\Providers\AppServiceProvider;
use App\Providers\HorizonServiceProvider;

return [
    AppServiceProvider::class,
    CoreServiceProvider::class,
    SalonServiceProvider::class,
    StaffServiceProvider::class,
    HorizonServiceProvider::class,
];
