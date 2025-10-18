#!/bin/bash
set -e


/wait-for-it.sh postgres:5432 -t 60

superset db upgrade

superset fab create-admin \
    --username ${SUPERSET_USERNAME:-admin} \
    --firstname ${SUPERSET_FIRSTNAME:-Admin} \
    --lastname ${SUPERSET_LASTNAME:-User} \
    --email ${SUPERSET_EMAIL:-admin@example.com} \
    --password ${SUPERSET_PASSWORD:-admin} || true


superset init

exec superset run -h 0.0.0.0 -p 8088
