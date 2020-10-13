echo "RESETTING DB"
cd clone-db/ && ./clone-locally.sh epubtest --defaults
wait
# cd ../datascrub && ./run.sh epubtest localhost 03
# wait
cd ../migrations
./run.sh epubtest localhost 07
wait
echo "DONE"