<?php

namespace App\Core\Tenancy;

use App\Core\Tenancy\Models\Salon;
use App\Core\Tenancy\Models\SalonMembership;

/**
 * Static entry point to the current tenant.
 */
final class Tenancy
{
    public static function holder(): CurrentSalon
    {
        return app(CurrentSalon::class);
    }

    public static function current(): ?Salon
    {
        return self::holder()->salon();
    }

    public static function id(): ?int
    {
        $id = self::holder()->salon()?->getKey();

        return $id === null ? null : (int) $id;
    }

    public static function membership(): ?SalonMembership
    {
        return self::holder()->membership();
    }

    public static function set(Salon $salon, ?SalonMembership $membership = null): void
    {
        self::holder()->set($salon, $membership);
    }

    public static function clear(): void
    {
        self::holder()->clear();
    }

    /**
     * Run a callback as the given salon, restoring the previous tenant afterwards.
     *
     * @template T
     *
     * @param  callable(): T  $callback
     * @return T
     */
    public static function runAs(Salon $salon, callable $callback): mixed
    {
        $holder = self::holder();
        $previous = $holder->salon();
        $previousMembership = $holder->membership();
        $holder->set($salon);

        try {
            return $callback();
        } finally {
            $previous ? $holder->set($previous, $previousMembership) : $holder->clear();
        }
    }

    /**
     * Run a callback with the tenant scope disabled. Allowed only for login flows,
     * platform admin, aggregation jobs and migrations (ADR-001).
     *
     * @template T
     *
     * @param  callable(): T  $callback
     * @return T
     */
    public static function bypass(callable $callback): mixed
    {
        $holder = self::holder();
        $holder->enterBypass();

        try {
            return $callback();
        } finally {
            $holder->leaveBypass();
        }
    }

    public static function isBypassed(): bool
    {
        return self::holder()->isBypassed();
    }
}
