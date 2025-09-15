-- Quiz Application Database Schema (MySQL)
-- Database: myapp
-- This script creates tables with relationships and indexes.
-- Safe to run multiple times due to IF NOT EXISTS and idempotent constructs.

-- Ensure the target database exists (optional safeguard)
CREATE DATABASE IF NOT EXISTS `myapp` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `myapp`;

-- Table: quizzes
CREATE TABLE IF NOT EXISTS `quizzes` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_quizzes_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: questions (belongs to quizzes)
CREATE TABLE IF NOT EXISTS `questions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `quiz_id` INT UNSIGNED NOT NULL,
  `question_text` TEXT NOT NULL,
  `question_order` INT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_questions_quiz_id` (`quiz_id`),
  KEY `idx_questions_order` (`quiz_id`, `question_order`),
  CONSTRAINT `fk_questions_quiz`
    FOREIGN KEY (`quiz_id`) REFERENCES `quizzes`(`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: choices (belongs to questions)
CREATE TABLE IF NOT EXISTS `choices` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `question_id` INT UNSIGNED NOT NULL,
  `choice_text` TEXT NOT NULL,
  `is_correct` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_choices_question_id` (`question_id`),
  KEY `idx_choices_is_correct` (`question_id`, `is_correct`),
  CONSTRAINT `fk_choices_question`
    FOREIGN KEY (`question_id`) REFERENCES `questions`(`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: attempts (one per user attempt at a quiz)
-- For simplicity we store a display name for the user who attempted.
CREATE TABLE IF NOT EXISTS `attempts` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `quiz_id` INT UNSIGNED NOT NULL,
  `user_name` VARCHAR(100) NOT NULL,
  `score` INT NOT NULL DEFAULT 0,
  `total_questions` INT NOT NULL DEFAULT 0,
  `started_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_attempts_quiz_id` (`quiz_id`),
  KEY `idx_attempts_score` (`quiz_id`, `score`),
  KEY `idx_attempts_completed_at` (`completed_at`),
  CONSTRAINT `fk_attempts_quiz`
    FOREIGN KEY (`quiz_id`) REFERENCES `quizzes`(`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: attempt_answers (answers given during an attempt)
CREATE TABLE IF NOT EXISTS `attempt_answers` (
  `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `attempt_id` BIGINT UNSIGNED NOT NULL,
  `question_id` INT UNSIGNED NOT NULL,
  `selected_choice_id` INT UNSIGNED NULL,
  `is_correct` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_attempt_question` (`attempt_id`, `question_id`),
  KEY `idx_attempt_answers_attempt_id` (`attempt_id`),
  KEY `idx_attempt_answers_question_id` (`question_id`),
  KEY `idx_attempt_answers_choice_id` (`selected_choice_id`),
  CONSTRAINT `fk_attempt_answers_attempt`
    FOREIGN KEY (`attempt_id`) REFERENCES `attempts`(`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_attempt_answers_question`
    FOREIGN KEY (`question_id`) REFERENCES `questions`(`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_attempt_answers_choice`
    FOREIGN KEY (`selected_choice_id`) REFERENCES `choices`(`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
