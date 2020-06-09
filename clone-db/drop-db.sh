#!/bin/bash

if [ -z "$1" ];
then
    read -p "Enter the local name for the db to drop: " DBNAME;
else
    DBNAME=$1;
fi

psql --set=dbname="$DBNAME" < dropdb.pgsql
