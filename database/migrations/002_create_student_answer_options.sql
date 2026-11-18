-- Migration 002: Create student_answer_options join table for multi-answer support (B6)
CREATE TABLE IF NOT EXISTS student_answer_options (
    answer_id INT NOT NULL REFERENCES student_answers(answer_id) ON DELETE CASCADE,
    option_id INT NOT NULL REFERENCES question_options(option_id) ON DELETE CASCADE,
    PRIMARY KEY (answer_id, option_id)
);

CREATE INDEX IF NOT EXISTS idx_student_answer_options_ans ON student_answer_options(answer_id);
CREATE INDEX IF NOT EXISTS idx_student_answer_options_opt ON student_answer_options(option_id);

-- Backfill existing single-choice answers into student_answer_options
INSERT INTO student_answer_options (answer_id, option_id)
SELECT answer_id, selected_option_id
FROM student_answers
WHERE selected_option_id IS NOT NULL
ON CONFLICT DO NOTHING;
