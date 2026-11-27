<?php

namespace App\Core\Identity\Http\Controllers\Web;

use Inertia\Inertia;
use Inertia\Response;

final class DashboardController
{
    public function __invoke(): Response
    {
        // KPI tiles are placeholders until Phase 12 aggregates exist — no fake numbers (rule 10).
        return Inertia::render('Dashboard');
    }
}
