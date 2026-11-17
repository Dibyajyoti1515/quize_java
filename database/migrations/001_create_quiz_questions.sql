-- Migration 001: Create quiz_questions join table for many-to-many quiz question reuse (B2)

CREATE TABLE IF NOT EXISTS quiz_questions (
    quiz_id INT NOT NULL REFERENCES quizzes(quiz_id) ON DELETE CASCADE,
    question_id INT NOT NULL REFERENCES questions(question_id) ON DELETE CASCADE,
    sort_order INT DEFAULT 1,
    points_override DECIMAL(5, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (quiz_id, question_id)
);

CREATE INDEX IF NOT EXISTS idx_quiz_questions_quiz ON quiz_questions(quiz_id);
CREATE INDEX IF NOT EXISTS idx_quiz_questions_question ON quiz_questions(question_id);

-- Backfill existing relationships from questions.quiz_id
INSERT INTO quiz_questions (quiz_id, question_id, sort_order, points_override)
SELECT quiz_id, question_id, 1, points
FROM questions
WHERE quiz_id IS NOT NULL
ON CONFLICT (quiz_id, question_id) DO NOTHING;
