-- Seed data for Quiz Application (MySQL)
-- Inserts one quiz, 5 questions, and 4 choices per question.

USE `myapp`;

-- Clean existing sample data (optional, safe when starting fresh)
-- Order matters due to FKs
DELETE FROM `attempt_answers`;
DELETE FROM `attempts`;
DELETE FROM `choices`;
DELETE FROM `questions`;
DELETE FROM `quizzes`;

-- Insert a sample quiz
INSERT INTO `quizzes` (`title`, `description`)
VALUES ('General Knowledge Basics', 'A short 5-question quiz covering general knowledge topics.');

-- Capture quiz id
SET @quiz_id := LAST_INSERT_ID();

-- Q1
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_order`)
VALUES (@quiz_id, 'What is the capital city of France?', 1);
SET @q1 := LAST_INSERT_ID();

INSERT INTO `choices` (`question_id`, `choice_text`, `is_correct`) VALUES
(@q1, 'Berlin', 0),
(@q1, 'Madrid', 0),
(@q1, 'Paris', 1),
(@q1, 'Rome', 0);

-- Q2
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_order`)
VALUES (@quiz_id, 'Which planet is known as the Red Planet?', 2);
SET @q2 := LAST_INSERT_ID();

INSERT INTO `choices` (`question_id`, `choice_text`, `is_correct`) VALUES
(@q2, 'Venus', 0),
(@q2, 'Mars', 1),
(@q2, 'Jupiter', 0),
(@q2, 'Mercury', 0);

-- Q3
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_order`)
VALUES (@quiz_id, 'What is the largest ocean on Earth?', 3);
SET @q3 := LAST_INSERT_ID();

INSERT INTO `choices` (`question_id`, `choice_text`, `is_correct`) VALUES
(@q3, 'Atlantic Ocean', 0),
(@q3, 'Indian Ocean', 0),
(@q3, 'Arctic Ocean', 0),
(@q3, 'Pacific Ocean', 1);

-- Q4
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_order`)
VALUES (@quiz_id, 'Who wrote the play "Romeo and Juliet"?', 4);
SET @q4 := LAST_INSERT_ID();

INSERT INTO `choices` (`question_id`, `choice_text`, `is_correct`) VALUES
(@q4, 'Charles Dickens', 0),
(@q4, 'William Shakespeare', 1),
(@q4, 'Mark Twain', 0),
(@q4, 'Jane Austen', 0);

-- Q5
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_order`)
VALUES (@quiz_id, 'What is the chemical symbol for water?', 5);
SET @q5 := LAST_INSERT_ID();

INSERT INTO `choices` (`question_id`, `choice_text`, `is_correct`) VALUES
(@q5, 'O2', 0),
(@q5, 'H2', 0),
(@q5, 'CO2', 0),
(@q5, 'H2O', 1);

-- Optional: verify counts (for manual inspection)
-- SELECT (SELECT COUNT(*) FROM quizzes) AS quizzes,
--        (SELECT COUNT(*) FROM questions) AS questions,
--        (SELECT COUNT(*) FROM choices) AS choices;
