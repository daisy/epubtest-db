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

# create the db
psql --set=dbname="$DB_NAME" --set=appRolePassword="$DB_PASSWORD" "host=$DB_HOST port=5432 user=postgres" < createdb.pgsql
wait


if [ -z "$1" ];
then
    echo "Cannot import data, no file specified"
else
        mkdir tmp;
        echo "Adding \\c $DB_NAME to file";
        echo -e "\\\c $DB_NAME;\n$(cat $1)" > tmp/in.pgsql
        wait
    # import the data
    psql --set=dbname="$DB_NAME" "host=$DB_HOST port=5432 user=postgres" < tmp/in.pgsql
    wait
fi

# setup the roles (depends on a schema; created in the previous step)
psql --set=dbname="$DB_NAME" --set=appRolePassword="$DB_PASSWORD" "host=$DB_HOST port=5432 user=postgres" < setup-roles.pgsql
wait

echo "Completed"
