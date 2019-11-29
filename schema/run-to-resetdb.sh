echo "Loading .env"
source .env

echo "Clearing database and setting up schema"
psql --set=appRolePassword="$APP_ROLE_PASSWORD" < run-to-resetdb.pgsql
