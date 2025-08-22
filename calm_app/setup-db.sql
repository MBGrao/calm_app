-- MeditAi Database Setup
CREATE DATABASE meditai_db;
CREATE USER meditai_user WITH PASSWORD 'meditai_prod_password_2024';
GRANT ALL PRIVILEGES ON DATABASE meditai_db TO meditai_user;
\c meditai_db
GRANT ALL ON SCHEMA public TO meditai_user;
\q

