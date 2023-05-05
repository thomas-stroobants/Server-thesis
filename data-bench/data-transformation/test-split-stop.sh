#!/usr/bin/bash

stop_file=$HOME/data-bench/de-lijn-gtfs/stop_times.csv
HEADER=$(head -n 1 $stop_file)

tail -n +2 $stop_file > tmp_stop

split --number=l/2 --numeric-suffixes=1 tmp_stop $HOME/data-bench/de-lijn-gtfs/stop_times_ --additional-suffix=.csv --verbose
for file in $HOME/data-bench/de-lijn-gtfs/stop_times_*
do
    echo "change file $file"
    sed -i "1i$HEADER" $file
done
rm tmp_stop
