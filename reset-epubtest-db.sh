echo "RESETTING DB"
cd clone-db/ && ./clone-locally.sh epubtest --defaults
wait
cd ../datascrub && ./run.sh epubtest localhost 03
wait
cd ../migrations
./run.sh epubtest localhost 05
wait
./run.sh epubtest localhost 06
wait
echo "DONE"