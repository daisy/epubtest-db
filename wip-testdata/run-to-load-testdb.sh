echo "Loading .env"
source .env

echo "Clearing database and setting up schema"

psql --set=dbname="$DBNAME" < run-to-load-testdb.pgsql