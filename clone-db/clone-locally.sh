#!/bin/bash

# ./clone-locally.sh epubtest --defaults

# download a dump of the database from the server (connection details in .env)
# ingest it into a new database
# optionally drop the local database first


source .env;

if [ -z "$1" ];
then
    read -p "Enter the local name for the new cloned db: " DBNAME;
else
    DBNAME=$1;
fi

echo "$2";

if [ "$2" == "--defaults" ];
then
    echo "Dropping $DBNAME";
    ./drop-db.sh $DBNAME;
else 
    read -p "Drop db if exists? (Y/n): " DROP;
    if [ "$DROP" != "n" ];
    then
        echo "Dropping $DBNAME";
        ./drop-db.sh $DBNAME;
    fi
fi

createdb -U postgres -h localhost -p 5432 -e $DBNAME;
wait
if [ "$2" == "--defaults" ];
then
    echo "Skipping download of export";
else 
    read -p "Download copy of export from server? (y/N): " DL;
    if [ "$2" != "--defaults" ] && [ "$DL" == "y" ];
    then
        mkdir tmp;
        echo "Downloading copy of export";
        scp -i $SCP_KEY $SERVER_ADDRESS:$DB_DUMP_PATH tmp/$DBNAME.pgsql
        wait
        
        echo "Adding \\c $DBNAME to file";
        echo -e "\\\c $DBNAME;\n$(cat tmp/$DBNAME.pgsql)" > tmp/$DBNAME.pgsql
        wait
    fi
fi

#skip setting global roles as we know they're already setup on this local postgresql instance

echo "Ingesting exported data";
psql -U postgres -h localhost -p 5432 < tmp/$DBNAME.pgsql
wait

echo "Repairing function(s)";
psql -U postgres -h localhost -p 5432 --set dbname="$DBNAME" < functions-fix.pgsql
wait

echo "Cleaning up";

echo "Done cloning database locally";
