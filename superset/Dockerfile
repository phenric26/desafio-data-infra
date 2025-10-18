FROM apache/superset:latest


USER root

RUN /app/.venv/bin/python -m ensurepip
RUN /app/.venv/bin/python -m pip install --upgrade pip

RUN /app/.venv/bin/python -m pip install psycopg2-binary --no-cache-dir

COPY wait-for-it.sh /wait-for-it.sh
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /wait-for-it.sh /entrypoint.sh

USER superset