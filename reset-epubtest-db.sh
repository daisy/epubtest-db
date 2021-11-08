# first make sure that there's a dbdump on the server
# to create this dbdump, connect to the dev server and run ./dumpdb.sh PROD (or DEV, depending)

echo "RESETTING DB"
cd clone-db/ && ./clone-locally.sh epubtest #--defaults
wait
cd ../migrations
./run.sh epubtest localhost 13
wait
echo "DONE"
