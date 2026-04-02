<?php

class RecommendationHelpers
{
    /** Whether the student's 1st choice text matches any of the top 3 names (fuzzy). */
    public static function firstChoiceMatchesTop(string $firstChoice, array $topThreeNames): bool
    {
        $f = self::norm($firstChoice);
        if ($f === '') {
            return true;
        }
        foreach ($topThreeNames as $name) {
            $n = self::norm((string) $name);
            if ($n === '') {
                continue;
            }
            if ($f === $n) {
                return true;
            }
            if (strpos($n, $f) !== false || strpos($f, $n) !== false) {
                return true;
            }
            if (strlen($f) >= 4 && strlen($n) >= 4) {
                $pct = 0;
                similar_text($f, $n, $pct);
                if ($pct >= 88.0) {
                    return true;
                }
            }
        }
        return false;
    }

    public static function norm(string $s): string
    {
        $s = preg_replace('/[\x{200B}-\x{200D}\x{FEFF}]/u', '', $s);
        $s = mb_strtolower(trim($s));
        $s = preg_replace('/\s+/', ' ', $s);
        return $s;
    }

    /**
     * Labels to compare against 1st choice for JHS Top-3 strands (code + full name).
     *
     * @param array<int,array{strand_name?:string,strand_code?:string}> $top3
     * @return list<string>
     */
    public static function strandTop3Labels(array $top3): array
    {
        $labels = [];
        foreach ($top3 as $row) {
            if (!empty($row['strand_code'])) {
                $labels[] = (string) $row['strand_code'];
            }
            if (!empty($row['strand_name'])) {
                $labels[] = (string) $row['strand_name'];
            }
        }
        return $labels;
    }

    /**
     * Labels for SHS: course title plus strand/pathway so e.g. "STEM" matches STEM-mapped programs.
     *
     * @param array<int,array{course_name?:string,strand_code?:string,strand_name?:string,career_pathway?:string}> $top3
     * @return list<string>
     */
    public static function courseTop3Labels(array $top3): array
    {
        $labels = [];
        foreach ($top3 as $row) {
            foreach (['strand_code', 'strand_name', 'course_name', 'career_pathway'] as $k) {
                if (!empty($row[$k])) {
                    $labels[] = (string) $row[$k];
                }
            }
        }
        return $labels;
    }

    /**
     * Plain-language explanation for guidance (why Top 3).
     *
     * @param array<string,mixed> $featureVector
     * @param array<string,int> $votesByStrandCode
     * @param array<int,array<string,mixed>> $top3
     */
    public static function explainStrandRecommendation(array $featureVector, array $votesByStrandCode, array $top3, int $nTrees): string
    {
        $lines = [];
        $lines[] = 'The Random Forest combines the learner profile with Q4 academic performance. Each of ' . $nTrees . ' trees casts one vote; vote totals rank strands.';
        if (!empty($top3[0])) {
            $lines[] = 'Rank 1 (' . ($top3[0]['strand_name'] ?? '') . ') received the most tree votes'
                . (isset($top3[0]['votes']) ? ' (' . (int) $top3[0]['votes'] . ' votes)' : '')
                . ', meaning the weighted mix of academic competency, skills, interests, technical level, entrance exam, and career preference most closely matches that strand.';
        }
        $lines[] = 'Stronger Q4 averages and closer alignment between career preference text and strand keywords increase votes toward academic tracks (e.g. STEM, HUMSS); technical interests and skills boost TVL strands.';
        return implode(' ', $lines);
    }

    /**
     * @param array<int,array<string,mixed>> $top3Courses
     */
    public static function explainCourseRecommendation(array $featureVector, array $votesByCourseName, array $top3Courses, int $nTrees): string
    {
        $lines = [];
        $lines[] = 'Course recommendations use the same feature set, with SHS Q4 performance and work immersion grades weighted heavily in the strand profiles that underpin each college program. The model runs ' . $nTrees . ' trees for majority vote.';
        if (!empty($top3Courses[0])) {
            $lines[] = 'The top course (' . ($top3Courses[0]['course_name'] ?? '') . ') emerged from the highest number of tree votes among all mapped programs.'
                . (isset($top3Courses[0]['votes']) ? ' (' . (int) $top3Courses[0]['votes'] . ' votes).' : '');
        }
        $lines[] = 'Employability readiness for SHS (shown only to guidance) uses the Work Immersion subject grade on a 0–100 scale as the readiness indicator for workplace performance.';
        return implode(' ', $lines);
    }
}
