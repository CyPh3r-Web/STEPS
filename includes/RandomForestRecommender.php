<?php
/**
 * Random Forest–style strand/course recommender (ensemble of decision trees + majority vote).
 * Each tree uses a random subset of features and jittered strand/course affinity weights.
 */

class RandomForestRecommender
{
    public const N_TREES = 37;

    public const FEATURE_KEYS = [
        'academic_competency',
        'work_immersion',
        'skills_assessment',
        'student_interest',
        'technical_skill_level',
        'entrance_exam',
        'career_preference',
    ];

    /** Strand “profiles”: relative importance of each feature for that strand (sums ~1). */
    private static function strandFeatureProfile(string $strandCode): array
    {
        $p = [
            'STEM'     => [0.28, 0.05, 0.14, 0.08, 0.24, 0.11, 0.10],
            'ABM'      => [0.22, 0.06, 0.12, 0.10, 0.14, 0.16, 0.20],
            'HUMSS'    => [0.20, 0.04, 0.14, 0.22, 0.10, 0.16, 0.14],
            'GAS'      => [0.22, 0.04, 0.12, 0.18, 0.14, 0.16, 0.14],
            'TVL-ICT'  => [0.18, 0.10, 0.16, 0.10, 0.28, 0.10, 0.08],
            'TVL-HE'   => [0.18, 0.12, 0.16, 0.14, 0.20, 0.10, 0.10],
            'TVL-IA'   => [0.18, 0.14, 0.14, 0.10, 0.26, 0.10, 0.08],
            'SPORTS'   => [0.20, 0.08, 0.12, 0.18, 0.22, 0.12, 0.08],
            'ARTS'     => [0.18, 0.04, 0.14, 0.22, 0.18, 0.14, 0.10],
        ];

        return $p[$strandCode] ?? [0.20, 0.08, 0.14, 0.14, 0.16, 0.14, 0.14];
    }

    /**
     * @param array<string,float|int> $features Values 0–100 for each FEATURE_KEYS
     * @param array<int,array> $strands rows from strands table
     * @return array{ranked: array, votes: array<string,int>, trees: int}
     */
    public static function recommendStrands(array $features, array $strands, int $seed = 0): array
    {
        $vec = self::normalizeVector($features);
        $votes = [];
        $n = count($strands);
        if ($n === 0) {
            return ['ranked' => [], 'votes' => [], 'trees' => 0];
        }

        for ($t = 0; $t < self::N_TREES; $t++) {
            mt_srand($seed + $t * 10007);
            $k = min(7, 4 + mt_rand(0, 3));
            $indices = self::randomSubsetIndices(7, $k, $t + $seed);
            $jitter = [];
            for ($i = 0; $i < 7; $i++) {
                $jitter[$i] = 0.88 + (mt_rand() / mt_getrandmax()) * 0.24;
            }

            $best = null;
            $bestScore = -1e12;
            foreach ($strands as $st) {
                $code = $st['strand_code'];
                $prof = self::strandFeatureProfile($code);
                $s = 0.0;
                foreach ($indices as $fi) {
                    $key = self::FEATURE_KEYS[$fi];
                    $fv = ($vec[$key] ?? 0) / 100.0;
                    $s += $prof[$fi] * $fv * ($jitter[$fi] ?? 1);
                }
                if ($s > $bestScore) {
                    $bestScore = $s;
                    $best = $st;
                }
            }
            if ($best) {
                $code = $best['strand_code'];
                $votes[$code] = ($votes[$code] ?? 0) + 1;
            }
        }

        arsort($votes);
        $ranked = [];
        foreach ($votes as $code => $cnt) {
            foreach ($strands as $st) {
                if ($st['strand_code'] === $code) {
                    $ranked[] = [
                        'strand_id'   => $st['id'],
                        'strand_code' => $st['strand_code'],
                        'strand_name' => $st['strand_name'],
                        'votes'       => $cnt,
                        'score'       => round($cnt / self::N_TREES * 100, 2),
                    ];
                    break;
                }
            }
        }

        return ['ranked' => $ranked, 'votes' => $votes, 'trees' => self::N_TREES];
    }

    /**
     * @param array<int,array{course_name:string,strand_id:int,strand_code:string,strand_name?:string,career_pathway?:string}> $courses
     */
    public static function recommendCourses(array $features, array $courses, int $seed = 0): array
    {
        $vec = self::normalizeVector($features);
        if (empty($courses)) {
            return ['ranked' => [], 'votes' => [], 'trees' => 0];
        }

        $votes = [];
        for ($t = 0; $t < self::N_TREES; $t++) {
            mt_srand($seed + $t * 13001 + 17);
            $k = min(7, 4 + mt_rand(0, 3));
            $indices = self::randomSubsetIndices(7, $k, $t * 3 + $seed);
            $jitter = [];
            for ($i = 0; $i < 7; $i++) {
                $jitter[$i] = 0.88 + (mt_rand() / mt_getrandmax()) * 0.24;
            }

            $best = null;
            $bestScore = -1e12;
            foreach ($courses as $c) {
                $code = $c['strand_code'];
                $prof = self::strandFeatureProfile($code);
                $s = 0.0;
                foreach ($indices as $fi) {
                    $key = self::FEATURE_KEYS[$fi];
                    $fv = ($vec[$key] ?? 0) / 100.0;
                    $s += $prof[$fi] * $fv * ($jitter[$fi] ?? 1);
                }
                $s += 0.02 * (mt_rand() / mt_getrandmax());
                if ($s > $bestScore) {
                    $bestScore = $s;
                    $best = $c;
                }
            }
            if ($best) {
                $name = $best['course_name'];
                $votes[$name] = ($votes[$name] ?? 0) + 1;
            }
        }

        arsort($votes);
        $ranked = [];
        foreach ($votes as $name => $cnt) {
            foreach ($courses as $c) {
                if ($c['course_name'] === $name) {
                    $ranked[] = array_merge($c, [
                        'votes' => $cnt,
                        'score' => round($cnt / self::N_TREES * 100, 2),
                    ]);
                    break;
                }
            }
        }

        return ['ranked' => $ranked, 'votes' => $votes, 'trees' => self::N_TREES];
    }

    private static function normalizeVector(array $features): array
    {
        $out = [];
        foreach (self::FEATURE_KEYS as $k) {
            $v = (float) ($features[$k] ?? 0);
            $out[$k] = max(0, min(100, $v));
        }
        return $out;
    }

    /** @return int[] */
    private static function randomSubsetIndices(int $total, int $k, int $salt): array
    {
        $k = max(1, min($total, $k));
        $idx = range(0, $total - 1);
        mt_srand($salt + 42);
        for ($i = $total - 1; $i > 0; $i--) {
            $j = (int) (mt_rand(0, $i));
            [$idx[$i], $idx[$j]] = [$idx[$j], $idx[$i]];
        }
        return array_slice($idx, 0, $k);
    }

    /** Keyword overlap score for a strand (0–100). */
    public static function keywordScoreForStrand(string $text, string $strandCode): int
    {
        $text = strtolower($text);
        $keywordMap = self::keywordMap();
        $keywords = $keywordMap[$strandCode] ?? [];
        if (empty($keywords)) {
            return 55;
        }
        $hits = 0;
        foreach ($keywords as $kw) {
            if ($kw !== '' && str_contains($text, $kw)) {
                $hits++;
            }
        }
        return (int) min(100, 52 + $hits * 6);
    }

    /** @return array<string, string[]> */
    public static function keywordMap(): array
    {
        return [
            'STEM'     => ['science', 'math', 'technology', 'engineering', 'computer', 'coding', 'programming', 'research', 'biology', 'physics', 'chemistry', 'robot', 'gadget'],
            'ABM'      => ['business', 'accounting', 'finance', 'economics', 'marketing', 'management', 'entrepreneur', 'trade', 'commerce', 'sales'],
            'HUMSS'    => ['writing', 'literature', 'social', 'politics', 'history', 'arts', 'communication', 'journalism', 'philosophy', 'language', 'culture'],
            'GAS'      => ['general', 'undecided', 'multiple', 'flexible', 'broad'],
            'TVL-ICT'  => ['computer', 'coding', 'web', 'internet', 'tech', 'software', 'hardware', 'network', 'digital'],
            'TVL-HE'   => ['cooking', 'baking', 'food', 'hospitality', 'housekeeping', 'hotel', 'restaurant', 'sewing', 'home'],
            'TVL-IA'   => ['welding', 'electrical', 'carpentry', 'automotive', 'mechanical', 'construction', 'building', 'industrial'],
            'SPORTS'   => ['sports', 'athlete', 'basketball', 'volleyball', 'football', 'swimming', 'running', 'fitness', 'gym'],
            'ARTS'     => ['art', 'drawing', 'painting', 'design', 'music', 'theater', 'photography', 'animation', 'media', 'creative'],
        ];
    }

    public static function technicalLevelScore(?string $level): float
    {
        $level = strtolower(trim((string) $level));
        if ($level === 'beginner') {
            return 45;
        }
        if ($level === 'developing') {
            return 62;
        }
        if ($level === 'proficient') {
            return 82;
        }
        if ($level === 'advanced') {
            return 95;
        }
        return 60;
    }

    /** Aggregate career preference vs best strand keyword match (0–100). */
    public static function careerPreferenceFeature(string $careerPref): float
    {
        $careerPref = strtolower(trim($careerPref));
        if ($careerPref === '') {
            return 50;
        }
        $best = 0;
        foreach (array_keys(self::keywordMap()) as $code) {
            $best = max($best, self::keywordScoreForStrand($careerPref, $code));
        }
        return (float) $best;
    }

    /**
     * Build 0–100 feature vector for RF from grades + NAI.
     *
     * @param array<string,mixed> $nai
     * @return array<string,float|int>
     */
    public static function buildFeatureVector(
        int $studentId,
        array $nai,
        int $gradeLevel,
        float $q4AvgJhs,
        float $q4ShsAvg,
        float $wiGrade
    ): array {
        $academic = $gradeLevel <= 10 ? $q4AvgJhs : $q4ShsAvg;
        $wi = $gradeLevel >= 11 ? $wiGrade : 0.0;

        $skillsText = trim((string) ($nai['skills'] ?? ''));
        $interestText = trim((string) ($nai['hobbies'] ?? ''));
        $careerPref = trim((string) ($nai['career_preference'] ?? ''));

        $skillsScore = self::blendedTextScore($skillsText);
        $interestScore = self::blendedTextScore($interestText);
        if ($interestText !== '') {
            $interestScore = max($interestScore, (int) (self::keywordScoreForStrand($interestText, 'GAS') * 0.9));
        }

        $tech = self::technicalLevelScore($nai['technical_skill_level'] ?? 'developing');
        $exam = (float) ($nai['entrance_exam_score'] ?? 0);
        $exam = max(0, min(100, $exam));
        $careerF = self::careerPreferenceFeature($careerPref);

        return [
            'academic_competency'   => max(0, min(100, $academic)),
            'work_immersion'        => max(0, min(100, $wi)),
            'skills_assessment'     => $skillsScore,
            'student_interest'      => $interestScore,
            'technical_skill_level' => $tech,
            'entrance_exam'         => $exam,
            'career_preference'     => $careerF,
        ];
    }

    private static function blendedTextScore(string $text): int
    {
        if ($text === '') {
            return 48;
        }
        $max = 0;
        foreach (array_keys(self::keywordMap()) as $code) {
            $max = max($max, self::keywordScoreForStrand($text, $code));
        }
        return $max;
    }
}
