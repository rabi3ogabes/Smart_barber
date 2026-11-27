<?php

namespace App\Modules\Salon\Support;

use App\Core\Exceptions\AppException;
use App\Core\Exceptions\ErrorCode;

/**
 * Validation and normalisation of weekly time ranges: weekday (0 = Sunday … 6 = Saturday)
 * → list of {start, end} in "HH:MM", same day, end after start, no overlaps.
 * Used for branch opening hours, barber working hours and breaks.
 */
final class WeekRanges
{
    public const MAX_RANGES_PER_DAY = 4;

    /**
     * Laravel validation rules for a week field named $field.
     *
     * @return array<string, mixed>
     */
    public static function rules(string $field): array
    {
        return [
            $field => ['present', 'array:0,1,2,3,4,5,6'],
            "{$field}.*" => ['array', 'max:'.self::MAX_RANGES_PER_DAY],
            "{$field}.*.*.start" => ['required', 'date_format:H:i'],
            "{$field}.*.*.end" => ['required', 'date_format:H:i'],
        ];
    }

    /**
     * Keep weekdays 0–6, sort ranges, reject end <= start and overlaps.
     *
     * @param  array<int|string, list<array{start: string, end: string}>>  $week
     * @return array<int, list<array{start: string, end: string}>>
     */
    public static function normalize(array $week): array
    {
        $out = [];
        foreach ($week as $weekday => $ranges) {
            $day = (int) $weekday;
            if ($day < 0 || $day > 6) {
                continue;
            }
            usort($ranges, fn (array $a, array $b) => strcmp($a['start'], $b['start']));
            $previousEnd = null;
            foreach ($ranges as $range) {
                if ($range['end'] <= $range['start'] || ($previousEnd !== null && $range['start'] < $previousEnd)) {
                    throw new AppException(ErrorCode::ScheduleRangesOverlap, errors: ["day_{$day}" => [ErrorCode::ScheduleRangesOverlap->message()]]);
                }
                $previousEnd = $range['end'];
            }
            $out[$day] = array_map(fn (array $r) => ['start' => $r['start'], 'end' => $r['end']], $ranges);
        }
        ksort($out);

        return $out;
    }

    /**
     * Group rows (weekday + two time columns) into the week shape, times as "HH:MM".
     *
     * @param  iterable<object>  $rows
     * @return array<int, list<array{start: string, end: string}>>
     */
    public static function fromRows(iterable $rows, string $startColumn, string $endColumn): array
    {
        $week = array_fill(0, 7, []);
        foreach ($rows as $row) {
            $week[(int) $row->weekday][] = ['start' => substr((string) $row->{$startColumn}, 0, 5), 'end' => substr((string) $row->{$endColumn}, 0, 5)];
        }

        return $week;
    }
}
