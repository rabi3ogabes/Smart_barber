<?php

namespace App\Core\Tenancy;

use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Models\SalonMembership;

/**
 * Request-scoped holder of the active tenant (ADR-001).
 * Set only by middleware, queue hooks or explicit Tenancy::runAs() calls.
 */
final class CurrentSalon
{
    private ?Salon $salon = null;

    private ?SalonMembership $membership = null;

    private int $bypassDepth = 0;

    public function set(Salon $salon, ?SalonMembership $membership = null): void
    {
        $this->salon = $salon;
        $this->membership = $membership;
        setPermissionsTeamId($salon->getKey());
    }

    public function clear(): void
    {
        $this->salon = null;
        $this->membership = null;
        setPermissionsTeamId(null);
    }

    public function salon(): ?Salon
    {
        return $this->salon;
    }

    public function membership(): ?SalonMembership
    {
        return $this->membership;
    }

    public function enterBypass(): void
    {
        $this->bypassDepth++;
    }

    public function leaveBypass(): void
    {
        $this->bypassDepth = max(0, $this->bypassDepth - 1);
    }

    public function isBypassed(): bool
    {
        return $this->bypassDepth > 0;
    }
}
