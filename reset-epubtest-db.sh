echo "RESETTING DB"
cd clone-db/ && ./clone-locally.sh epubtest --defaults
wait
cd ../migrations
./run.sh epubtest localhost 08
wait
cd ../migrations
./run.sh epubtest localhost 09
wait
echo "DONE"