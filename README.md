# quiz-master-4204-4418

## Database setup (MySQL)

- The MySQL service is managed by `quiz_database/startup.sh` and runs on the configured port (default 5000 in this workspace).
- A connection helper is generated at `quiz_database/db_connection.txt` after running `startup.sh`.

For full database initialization instructions (running schema.sql and seed.sql), see:
- quiz_database/README.md

## How to create schema and seed data (quick reference)

1) Start MySQL (if not already running)
   bash quiz_database/startup.sh

2) Load schema (tables, FKs, indexes)
   $(cat quiz_database/db_connection.txt) < quiz_database/schema.sql

3) Seed sample quiz data
   $(cat quiz_database/db_connection.txt) < quiz_database/seed.sql

Alternatively, you can use your own MySQL instance and run:
   mysql -u <USER> -p -h <HOST> -P <PORT> myapp < quiz_database/schema.sql
   mysql -u <USER> -p -h <HOST> -P <PORT> myapp < quiz_database/seed.sql

## How other containers connect

- Backend (FastAPI) must provide the following environment variables:
  - MYSQL_HOST=localhost
  - MYSQL_PORT=5000
  - MYSQL_DB=myapp
  - MYSQL_USER=appuser
  - MYSQL_PASSWORD=dbuser123

  These align with the defaults created by `startup.sh`. Adjust only if you change the database configuration.

- Frontend (React) talks to the backend via HTTP and does not connect directly to MySQL.

## End-to-end local run (summary)

1) Start database:
   bash quiz_database/startup.sh
   $(cat quiz_database/db_connection.txt) < quiz_database/schema.sql
   $(cat quiz_database/db_connection.txt) < quiz_database/seed.sql

2) Start backend (in quiz-master-4204-4420/quiz_backend):
   - Copy .env.example to .env and ensure it matches the DB settings above.
   - Install deps: pip install -r requirements.txt
   - Run: uvicorn src.api.main:app --host 0.0.0.0 --port 8000 --reload

3) Start frontend (in quiz-master-4204-4419/quiz_frontend):
   - Copy .env.example to .env and set REACT_APP_API_BASE_URL=http://localhost:8000
   - npm install
   - npm start

## Notes

- Do NOT rename or add .sql to `startup.sh`; keep it as a shell script.
- The schema creates the following tables:
  `quizzes`, `questions`, `choices`, `attempts`, `attempt_answers` with foreign keys, indexes, and ON DELETE CASCADE as appropriate.
- The seed inserts 1 quiz with 5 questions and 4 choices per question (one correct).
- Environment variables for a simple DB viewer are saved under `quiz_database/db_visualizer/mysql.env` after startup.