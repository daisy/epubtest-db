#!/bin/bash
# create a new database from a backup file
# usage run.sh backup-file.sql

source .env

# optionally drop the db
read -p "Drop db if exists? (Y/n): " DROP;
if [ "$DROP" != "n" ];
then
    psql --set=dbname="$DB_NAME" "host=$DB_HOST port=5432 user=postgres" < dropdb.pgsql
    wait
fi

# create the roles
psql --set=dbname="$DB_NAME" --set=appRolePassword="$DB_PASSWORD" "host=$DB_HOST port=5432 user=postgres" < init-roles.pgsql
wait

# create the roles
psql --set=dbname="$DB_NAME" --set=appRolePassword="$DB_PASSWORD" "host=$DB_HOST port=5432 user=postgres" < createdb.pgsql
wait

if [ -z "$1" ];
then
    echo "Cannot import data, no file specified"
else
    # import the data
    psql --set=dbname="$DB_NAME" "host=$DB_HOST port=5432 user=postgres" < $1
    wait
fi

echo "Completed"
