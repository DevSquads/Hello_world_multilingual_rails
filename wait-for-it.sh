#!/bin/sh
# wait-for-postgres.sh

rm -rf ./tmp

set -e

host="$1"
pport="$2"
shift
cmd="$@"

until PGPASSWORD=$POSTGRES_PASSWORD psql -h "$host" -p "$pport" -U "postgres" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"

>&2 echo "Running migration"
rake db:migrate
# exec $cmd