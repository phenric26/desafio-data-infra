# Desafio Técnico - Ambiente de Engenharia de Dados

## 1. Objetivo

Este repositório contém a configuração de um ambiente de desenvolvimento local para engenharia de dados, utilizando Docker Compose. O objetivo é orquestrar os serviços Airflow, Superset e Postgres, garantindo a interoperabilidade entre eles.

## 2. Arquitetura 

```
+----------------+        +----------------------+
|    Airflow     |------->|                      |
| (Orquestrador) |        |       Postgres       |
+----------------+        | (Metastores + DW)    |
                          |                      |
+----------------+------->|                      |
|    Superset    |        +----------------------+
| (Visualização) |
+----------------+
```
- **Postgres**: Atende a três bancos de dados: `airflow_meta` (metadados do Airflow), `superset_meta` (metadados do Superset) e `analytics` (Data Warehouse).
- **Airflow**: Usa o Postgres como metastore e se conecta ao DW `analytics` para orquestrar tarefas.
- **Superset**: Usa o Postgres como metastore e se conecta ao DW `analytics` para visualização de dados.

## 3. Pré-requisitos

- Docker
- Docker Compose

## 4. Estrutura de Pastas do Projeto

```bash
desafio-data-infra/
├── dags/                      
│   └── test_postgres_conn.py  # DAG de teste de conexão Airflow -> Postgres
├── superset/                  
│   ├── Dockerfile             # Dockerfile do Superset
│   └── superset_config.py     # Configurações customizadas (opcional)
├── scripts/                   
│   └── postgres/
│       └── init.sql           # Script de criação de bancos e usuários
├── .env                       # Variáveis de ambiente para Docker Compose
├── .env.example               # Exemplo de arquivo .env
├── docker-compose.yml         # Orquestração dos serviços Docker
└── README.md                  # Documentação do projeto

 ```


## 5. Como Executar

1.  **Clone o repositório:**
    ```bash
    git clone git@github.com:phenric26/desafio-data-infra.git
    cd desafio-data-infra
    ```
2.  **Configure o ambiente:**
    Copie o arquivo de exemplo `.env.example` para um novo arquivo chamado `.env`.
    ```bash
    cp .env.example .env
    ```
    *Importante*: ajuste a variável `AIRFLOW_UID` no arquivo `.env` com o resultado do comando `id -u` no seu terminal para evitar problemas de permissão de arquivos.

3.  **Suba os contêineres:**
    Execute o Docker Compose. 
    ```bash
    docker-compose up -d --build
    ```

## 6. Como Validar

Após os serviços subirem, acesse as interfaces e realize as seguintes verificações:

- **Airflow UI**: [http://localhost:8080](http://localhost:8080) (login: `admin`, senha: `admin`)
- **Superset UI**: [http://localhost:8088](http://localhost:8088) (login: `admin`, senha: `admin`)

#### Validação 1: Conexão Airflow -> Postgres (DW)

1.  Na UI do Airflow, vá em **Admin -> Connections**.
2.  Crie uma nova conexão com os seguintes dados:
    - **Connection Id**: `postgres_analytics_dw`
    - **Connection Type**: `Postgres`
    - **Host**: `postgres` (o nome do serviço no docker-compose)
    - **Schema**: `analytics`
    - **Login**: `admin`
    - **Password**: `admin`
    - **Port**: `5432`
3.  Clique no botão **Test**. Você deverá ver a mensagem "Connection successfully tested".


#### Validação 2: Conexão Superset → Postgres (DW)

No Superset, a validação da conexão deve garantir que a ferramenta consegue **consultar e manipular dados** no banco `analytics`:

1. Na interface do Superset, vá em **+ → Data → Connect Database**.  
2. Selecione **PostgreSQL**.  
3. Preencha os campos de conexão:

   - **Host:** `postgres` (nome do serviço no Docker)  
   - **Port:** `5432`  
   - **Database name:** `analytics`  
   - **Username:** `admin`  
   - **Password:** `admin`  
   - **Display Name:** `PostgreSQL` (ou qualquer nome de sua escolha)  
  
4. Clique em **Connect**. Você deverá ver uma **mensagem de sucesso** indicando que a conexão foi validada.  

**Teste prático usando SQL Lab:**

1. Vá em **SQL Lab**.  
2. Selecione o banco `PostgreSQL`(Display Name).  
3. Execute uma query simples para validação:

```sql
SELECT 1;
