# this initializes a test database 
# then you should run epubtest-site/test/add-data.js to populate it
# and test queries

echo "Loading .env"
source .env

echo "Clearing database and setting up schema"

cd ../initial-schema
psql --set=appRolePassword="$APP_ROLE_PASSWORD" --set=dbname="$DBNAME" < run-to-resetdb.pgsql
wait

cd ../migrations
./run.sh "$DBNAME" "$DBHOST" 01
wait
./run.sh "$DBNAME" "$DBHOST" 02
wait
./run.sh "$DBNAME" "$DBHOST" 03
wait
./run.sh "$DBNAME" "$DBHOST" 04
wait
./run.sh "$DBNAME" "$DBHOST" 05
wait
./run.sh "$DBNAME" "$DBHOST" 06
wait
./run.sh "$DBNAME" "$DBHOST" 07
wait
./run.sh "$DBNAME" "$DBHOST" 08
wait
./run.sh "$DBNAME" "$DBHOST" 09
wait
./run.sh "$DBNAME" "$DBHOST" 10
wait
./run.sh "$DBNAME" "$DBHOST" 11
wait
./run.sh "$DBNAME" "$DBHOST" 12
wait
cd ../setup-testdb
psql --set=dbname="$DBNAME" < add-admin.pgsql
