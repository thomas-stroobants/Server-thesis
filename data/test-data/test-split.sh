#!/usr/bin/bash

total_lines=$(cat $HOME/data/de-lijn-gtfs/stop_times.csv | wc -l)
num_lines=$((total_lines/10))
split -l $num_lines $HOME/data/de-lijn-gtfs/stop_times.csv $HOME/data/de-lijn-gtfs/stop_times_s

# cat header.csv output2.csv > $HOME/data/de-lijn-gtfs/stop_times_2.csv
