<?php

namespace App\Modules\Staff\Schedule;

use Carbon\CarbonImmutable;
use InvalidArgumentException;

/**
 * Half-open time range [start, end) in UTC.
 */
final readonly class Interval
{
    public function __construct(public CarbonImmutable $start, public CarbonImmutable $end)
    {
        if (! $end->greaterThan($start)) {
            throw new InvalidArgumentException('Interval end must be after start.');
        }
    }

    /**
     * Build from a branch-local date and wall-clock times ("09:00" or "09:00:00").
     */
    public static function local(string $date, string $from, string $to, string $timezone): self
    {
        return new self(
            CarbonImmutable::parse("{$date} {$from}", $timezone)->utc(),
            CarbonImmutable::parse("{$date} {$to}", $timezone)->utc(),
        );
    }

    public function minutes(): int
    {
        return (int) $this->start->diffInMinutes($this->end);
    }

    public function overlaps(self $other): bool
    {
        return $this->start->lessThan($other->end) && $other->start->lessThan($this->end);
    }

    /**
     * @return array{start: string, end: string}
     */
    public function toArray(): array
    {
        return ['start' => $this->start->toIso8601ZuluString(), 'end' => $this->end->toIso8601ZuluString()];
    }
}
