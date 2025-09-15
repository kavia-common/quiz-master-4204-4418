# quiz-master-4204-4418

Database setup (MySQL)

- The MySQL service is managed by quiz_database/startup.sh and runs on the configured port (default 5000 in this workspace).
- Connection helper is generated in quiz_database/db_connection.txt after running startup.sh.

How to create schema and seed data

1) Start MySQL (if not already running)
   bash quiz_database/startup.sh

2) Load schema
   # Uses the connection string saved by startup.sh
   $(cat quiz_database/db_connection.txt) < quiz_database/schema.sql

3) Seed sample quiz data
   $(cat quiz_database/db_connection.txt) < quiz_database/seed.sql

Notes
- Do NOT rename or add .sql to startup.sh; keep it as a shell script.
- The schema creates the following tables:
  quizzes, questions, choices, attempts, attempt_answers with foreign keys, indexes, and ON DELETE CASCADE as appropriate.
- The seed inserts 1 quiz with 5 questions and 4 choices per question (one correct).
- Environment variables for a simple DB viewer are saved under quiz_database/db_visualizer/mysql.env after startup.