#! /usr/bin/bash


log_monitor="$HOME/benchmark/log/test-dl-morph.log"

# Define the name of the Python script to be monitored
script_dl_1="$HOME/graphs-bench/config/config-dl-1.ini"
script_dl_2="$HOME/graphs-bench/config/config-dl_2.ini"
script_dl_3="$HOME/graphs-bench/config/config-dl-3.ini"
script_dl_4="$HOME/graphs-bench/config/config-dl-4.ini"
script_dl_5="$HOME/graphs-bench/config/config-dl-5.ini"
script_dl_6="$HOME/graphs-bench/config/config-dl-6.ini"
script_dl_7="$HOME/graphs-bench/config/config-dl-7.ini"
script_dl_8="$HOME/graphs-bench/config/config-dl-8.ini"

script_dl2_1="$HOME/graphs-bench/config/config-dl2-1.ini"
script_dl2_2="$HOME/graphs-bench/config/config-dl2-2.ini"
script_dl2_3="$HOME/graphs-bench/config/config-dl2-3.ini"
script_dl2_4="$HOME/graphs-bench/config/config-dl2-4.ini"
script_dl2_5="$HOME/graphs-bench/config/config-dl2-5.ini"
script_dl2_6="$HOME/graphs-bench/config/config-dl2-6.ini"
script_dl2_7="$HOME/graphs-bench/config/config-dl2-7.ini"
script_dl2_8="$HOME/graphs-bench/config/config-dl2-8.ini"

# Define the name of the CSV file to store the data
csv_dl_1="$HOME/benchmark/bench-morph-dl/bench-morph-dl-1.csv"
csv_dl_2="$HOME/benchmark/bench-morph-dl/bench-morph-dl-2.csv"
csv_dl_3="$HOME/benchmark/bench-morph-dl/bench-morph-dl-3.csv"
csv_dl_4="$HOME/benchmark/bench-morph-dl/bench-morph-dl-4.csv"
csv_dl_5="$HOME/benchmark/bench-morph-dl/bench-morph-dl-5.csv"
csv_dl_6="$HOME/benchmark/bench-morph-dl/bench-morph-dl-6.csv"
csv_dl_7="$HOME/benchmark/bench-morph-dl/bench-morph-dl-7.csv"
csv_dl_8="$HOME/benchmark/bench-morph-dl/bench-morph-dl-8.csv"

csv_dl2_1="$HOME/benchmark/bench-morph-dl/bench-morph-dl2-1.csv"
csv_dl2_2="$HOME/benchmark/bench-morph-dl/bench-morph-dl2-2.csv"
csv_dl2_3="$HOME/benchmark/bench-morph-dl/bench-morph-dl2-3.csv"
csv_dl2_4="$HOME/benchmark/bench-morph-dl/bench-morph-dl2-4.csv"
csv_dl2_5="$HOME/benchmark/bench-morph-dl/bench-morph-dl2-5.csv"
csv_dl2_6="$HOME/benchmark/bench-morph-dl/bench-morph-dl2-6.csv"
csv_dl2_7="$HOME/benchmark/bench-morph-dl/bench-morph-dl2-7.csv"
csv_dl2_8="$HOME/benchmark/bench-morph-dl/bench-morph-dl2-8.csv"

monitor_morph_kgc() {
    ini_file=$1
    csv_file=$2

    # Write headers to the CSV file
    echo "PID;Time;CPU %;Memory %;Memory Bytes;Wchan;State" > $csv_file

    python3 -m morph_kgc $ini_file &
    pid_morph=$!
    echo $pid_morph >> $log_monitor
    # start_time=$(date +%s%N | cut -b1-13)
    start_time=$(($(date +%s%N) / 1000000))
    # Loop to run the script and monitor performance every second
    while ps -p $pid_morph > /dev/null; do
        # Get the current time stamp
        timestamp=$(($(date +%s%N) / 1000000))
        
        runtime=$(($timestamp - $start_time))
        # ps_output=$(ps aux | grep $virtuoso_pid | grep -v grep | grep -v sudo)
        ps_output=$(top -b -n 1 -H -o -PID | grep $pid_morph)

        while read -r line; do
            pid=$(echo "$line" | awk '{print $1}')
            cpu_usage=$(echo "$line" | awk '{print $5}' )
            memory_usage=$(echo "$line" | awk '{print $6}' )
            memory_bytes=$(echo "$line" | awk '{print $3}' )
            wchan=$(echo "$line" | awk '{print $10}' )
            state=$(echo "$line" | awk '{print $4}' )
            echo "$pid;$runtime;$cpu_usage;$memory_usage;$memory_bytes;$wchan;$state" >> $csv_file ;
        done <<< "$ps_output"
        # Sleep for 0.1 seconds     --> no sleep needed, process takes around 300 milliseconds to complete
        # sleep 0.1
    done
    totaltime=$(((($(date +%s%N) / 1000000) - $start_time)))
    echo "Total runtime of $ini_file is $totaltime milliseconds" >> $log_monitor
}

# monitor_morph_kgc $script_dl_1 $csv_dl_1
# monitor_morph_kgc $script_dl2_1 $csv_dl2_1
# monitor_morph_kgc $script_dl_2 $csv_dl_2
# monitor_morph_kgc $script_dl2_2 $csv_dl2_2
# monitor_morph_kgc $script_dl_3 $csv_dl_3
# monitor_morph_kgc $script_dl2_3 $csv_dl2_3
# monitor_morph_kgc $script_dl_4 $csv_dl_4
monitor_morph_kgc $script_dl2_4 $csv_dl2_4
# monitor_morph_kgc $script_dl_5 $csv_dl_5
monitor_morph_kgc $script_dl2_5 $csv_dl2_5
# monitor_morph_kgc $script_dl_6 $csv_dl_6
monitor_morph_kgc $script_dl2_6 $csv_dl2_6
# monitor_morph_kgc $script_dl_7 $csv_dl_7
monitor_morph_kgc $script_dl2_7 $csv_dl2_7
# monitor_morph_kgc $script_dl_8 $csv_dl_8
monitor_morph_kgc $script_dl2_8 $csv_dl2_8