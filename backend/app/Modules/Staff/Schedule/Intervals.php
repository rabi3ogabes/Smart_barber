<?php

namespace App\Modules\Staff\Schedule;

/**
 * Pure set operations on lists of intervals. Results are sorted and merged.
 */
final class Intervals
{
    /**
     * Sort and merge touching or overlapping intervals.
     *
     * @param  list<Interval>  $intervals
     * @return list<Interval>
     */
    public static function normalize(array $intervals): array
    {
        usort($intervals, fn (Interval $a, Interval $b) => $a->start <=> $b->start);
        $out = [];
        foreach ($intervals as $i) {
            $last = end($out);
            if ($last !== false && $i->start->lessThanOrEqualTo($last->end)) {
                $out[count($out) - 1] = new Interval($last->start, $i->end->max($last->end));
            } else {
                $out[] = $i;
            }
        }

        return $out;
    }

    /**
     * @param  list<Interval>  $a
     * @param  list<Interval>  $b
     * @return list<Interval>
     */
    public static function intersect(array $a, array $b): array
    {
        $out = [];
        foreach (self::normalize($a) as $x) {
            foreach (self::normalize($b) as $y) {
                $start = $x->start->max($y->start);
                $end = $x->end->min($y->end);
                if ($end->greaterThan($start)) {
                    $out[] = new Interval($start, $end);
                }
            }
        }

        return self::normalize($out);
    }

    /**
     * Remove every part of $a covered by $b.
     *
     * @param  list<Interval>  $a
     * @param  list<Interval>  $b
     * @return list<Interval>
     */
    public static function subtract(array $a, array $b): array
    {
        $result = self::normalize($a);
        foreach (self::normalize($b) as $cut) {
            $next = [];
            foreach ($result as $piece) {
                if (! $piece->overlaps($cut)) {
                    $next[] = $piece;

                    continue;
                }
                if ($piece->start->lessThan($cut->start)) {
                    $next[] = new Interval($piece->start, $cut->start);
                }
                if ($cut->end->lessThan($piece->end)) {
                    $next[] = new Interval($cut->end, $piece->end);
                }
            }
            $result = $next;
        }

        return self::normalize($result);
    }

    /**
     * @param  list<Interval>  $intervals
     */
    public static function totalMinutes(array $intervals): int
    {
        return array_sum(array_map(fn (Interval $i) => $i->minutes(), $intervals));
    }
}
