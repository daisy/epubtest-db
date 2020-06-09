#!/bin/bash
# apply a migration to the database
# run-migration.sh [dbname] [dbhost] [migration-folder]

if [ -z "$1" ];
then
    read -p "Enter the db name: " DBNAME;
else
    DBNAME=$1;
fi

if [ -z "$2" ];
then
    read -p "Enter db host: " DBHOST;
else
    DBHOST=$2;
fi

if [ -z "$3" ];
then
    read -p "Migration to apply: " MIGRATION;
else
    MIGRATION=$3;
fi



cd $MIGRATION;
echo $MIGRATION;
psql -U postgres -h $DBHOST -p 5432 --set dbname="$DBNAME" < run.pgsql
wait

