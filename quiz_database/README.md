# Quiz Database (MySQL)

This directory contains the MySQL schema and seed data for the Quiz application. Use these instructions to initialize or re-initialize the database for first use.

## Prerequisites

- MySQL 8.x available on your system (mysqld, mysql, mysqladmin).
- Bash shell.
- The helper script `startup.sh` is provided to start a local MySQL instance (on port 5000 by default) and create the required database and user.

Defaults created by `startup.sh`:
- DB name: myapp
- App user: appuser
- App password: dbuser123
- Host: localhost
- Port: 5000

A connection helper command will be written to quiz_database/db_connection.txt after startup.

## Option A: Use provided startup.sh (recommended)

1) Start MySQL
   bash quiz_database/startup.sh

   This will:
   - Initialize and start MySQL (if not already running)
   - Create database myapp
   - Create user appuser with password dbuser123
   - Write a connection helper to quiz_database/db_connection.txt
   - Write db viewer env vars to quiz_database/db_visualizer/mysql.env

2) Load schema (tables, foreign keys, indexes)
   $(cat quiz_database/db_connection.txt) < quiz_database/schema.sql

3) Seed sample quiz data
   $(cat quiz_database/db_connection.txt) < quiz_database/seed.sql

After these steps, your database is ready with a sample quiz.

## Option B: Use mysql CLI directly (if you run your own MySQL)

If you have a MySQL server running already and prefer to use it, run:

- Ensure the database exists and set active:
  mysql -u <USER> -p -h <HOST> -P <PORT> -e "CREATE DATABASE IF NOT EXISTS myapp;"

- Load schema:
  mysql -u <USER> -p -h <HOST> -P <PORT> myapp < quiz_database/schema.sql

- Seed data:
  mysql -u <USER> -p -h <HOST> -P <PORT> myapp < quiz_database/seed.sql

Replace <USER>, <HOST>, and <PORT> with your values. If you use the same defaults as startup.sh:
  mysql -u appuser -pdbuser123 -h localhost -P 5000 myapp < quiz_database/schema.sql
  mysql -u appuser -pdbuser123 -h localhost -P 5000 myapp < quiz_database/seed.sql

Note: schema.sql contains CREATE DATABASE IF NOT EXISTS and USE myapp; so it is safe to run even if you selected the database on the CLI.

## Verifying the setup

- List tables:
  $(cat quiz_database/db_connection.txt) -e "SHOW TABLES;"

  You should see: quizzes, questions, choices, attempts, attempt_answers

- Check sample data counts:
  $(cat quiz_database/db_connection.txt) -e "SELECT (SELECT COUNT(*) FROM quizzes) AS quizzes,(SELECT COUNT(*) FROM questions) AS questions,(SELECT COUNT(*) FROM choices) AS choices;"

Expected counts after seed:
- quizzes: 1
- questions: 5
- choices: 20

## Troubleshooting

- MySQL already running on your system:
  If you have an existing MySQL on a different port or with different auth, either:
  - Stop it before running startup.sh, or
  - Use Option B with your own connection details.

- Authentication errors:
  Ensure you are using the correct user/password/port. Defaults from startup.sh:
  - user: appuser
  - password: dbuser123
  - host: localhost
  - port: 5000

- Re-seeding data:
  The seed.sql script clears sample data in a safe order before inserting sample content. You can re-run it at any time:
  $(cat quiz_database/db_connection.txt) < quiz_database/seed.sql

## Utilities

- Backup current database (auto-detects database type; tailored for MySQL defaults here):
  bash quiz_database/backup_db.sh

- Restore from backup (auto-detects backup file type):
  bash quiz_database/restore_db.sh

## How other containers connect

Backend (FastAPI) environment variables:
- MYSQL_HOST=localhost
- MYSQL_PORT=5000
- MYSQL_DB=myapp
- MYSQL_USER=appuser
- MYSQL_PASSWORD=dbuser123

Frontend (React) talks to the backend HTTP API and does not connect directly to MySQL.
