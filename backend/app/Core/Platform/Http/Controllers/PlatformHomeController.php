<?php

namespace App\Core\Platform\Http\Controllers;

use Inertia\Inertia;
use Inertia\Response;

/**
 * Empty Super Admin home; the console arrives in Phase 14.
 */
final class PlatformHomeController
{
    public function __invoke(): Response
    {
        return Inertia::render('Platform/Home');
    }
}
