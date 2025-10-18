-- scripts/postgres/init.sql

-- Criar usuários com suas senhas (valores vêm do .env)
CREATE USER airflow_user WITH PASSWORD 'airflow_pass';
CREATE USER superset_user WITH PASSWORD 'superset_pass';
CREATE USER analytics_user WITH PASSWORD 'analytics_pass';

-- Criar os bancos de dados
CREATE DATABASE airflow_meta;
CREATE DATABASE superset_meta;
CREATE DATABASE analytics;

-- Conceder permissões aos usuários nos seus respectivos bancos
GRANT ALL PRIVILEGES ON DATABASE airflow_meta TO airflow_user;
GRANT ALL PRIVILEGES ON DATABASE superset_meta TO superset_user;
GRANT ALL PRIVILEGES ON DATABASE analytics TO analytics_user;

-- O Superset precisa desta extensão no seu metastore
\c superset_meta;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";