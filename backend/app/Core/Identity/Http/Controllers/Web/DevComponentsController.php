<?php

namespace App\Core\Identity\Http\Controllers\Web;

use Inertia\Inertia;
use Inertia\Response;

final class DevComponentsController
{
    public function __invoke(): Response
    {
        abort_unless(app()->environment(['local', 'staging', 'testing']), 404);

        return Inertia::render('Dev/Components');
    }
}
