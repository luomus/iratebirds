#!/bin/sh
docker exec iratebirds_postgres_1 sh -c 'pg_dump -U user | gzip > /var/lib/postgresql/data/backups/backup.sql.gz'
aws s3 sync postgres/backups s3://iratebirds-postgres-backups/data