from airflow import DAG
from airflow.providers.postgres.operators.postgres import PostgresOperator
from datetime import datetime

# DAG simples para testar conexão Airflow -> Postgres
with DAG(
    dag_id="test_postgres_conn",
    start_date=datetime(2025, 10, 17),
    schedule_interval=None, 
    catchup=False,
    tags=["smoke_test"]
) as dag:

    test_query = PostgresOperator(
        task_id="execute_simple_query",
        postgres_conn_id="postgres_analytics",  
        sql="SELECT 1;"
    )
