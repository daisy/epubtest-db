# first make sure that there's a dump on the server
# connect to the dev server and run ./dumbdb.sh PROD (or DEV, depending)

echo "RESETTING DB"
cd clone-db/ && ./clone-locally.sh epubtest --defaults
wait
cd ../migrations
./run.sh epubtest localhost 12
wait
echo "DONE"