#! /usr/bin/bash

log_monitor="$HOME/benchmark/log/test-morph-full.log"

# Define the name of the Python script to be monitored
script_irail="$HOME/graphs-bench/config/config-irail.ini"
script_nmbs="$HOME/graphs-bench/config/config-nmbs.ini"
script_dl1="$HOME/graphs-bench/config/config-dl.ini"
script_dl2="$HOME/graphs-bench/config/config-dl-2.ini"

# Define the name of the CSV file to store the data
csv_irail="$HOME/benchmark/bench-morph-irail.csv"
csv_nmbs="$HOME/benchmark/bench-morph-nmbs.csv"
csv_dl1="$HOME/benchmark/bench-morph-dl1.csv"
csv_dl2="$HOME/benchmark/bench-morph-dl2.csv"

check_bytes() {
    value=$1
    unit=${value:(-1)}
    if [ "$unit" == "g" ]; then
        # num=$( echo ${value%$unit} | tr , . )
        num=$(echo ${value%$unit})
        value=$(echo "$num * 1024 * 1024 " | bc)        
    fi
    echo $value
}

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

monitor_morph_kgc $script_irail $csv_irail
monitor_morph_kgc $script_nmbs $csv_nmbs
monitor_morph_kgc $script_dl1 $csv_dl1
monitor_morph_kgc $script_dl2 $csv_dl2