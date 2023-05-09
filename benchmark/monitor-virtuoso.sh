#! /usr/bin/bash

# Define the name of the Python script to be monitored
isql_clear_bulk="$HOME/data-bench/query/clear-bulk-load-list.sql"
isql_delete_nmbs="$HOME/data-bench/query/delete-nmbs-graph.sql"
isql_delete_delijn="$HOME/data-bench/query/delete-delijn-graph.sql"
isql_load_nmbs="$HOME/data-bench/query/nmbs-load.sql"
isql_load_delijn="$HOME/data-bench/query/delijn-load.sql"

# Define the name of the CSV file to store the data
csv_iqsl_clear="$HOME/benchmark/bench-isql-clear.csv"
csv_isql_del_nmbs="$HOME/benchmark/bench-isql-delete-nmbs.csv"
csv_isql_del_delijn="$HOME/benchmark/bench-isql-delete-delijn.csv"
csv_isql_load_nmbs="$HOME/benchmark/bench-isql-load-nmbs.csv"
csv_isql_load_delijn="$HOME/benchmark/bench-isql-load-nmbs.csv"


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

monitor_virtuoso() {
    isql_command=$1
    csv_file=$2
    virtuoso_pid=$3

    # Write headers to the CSV file
    echo "PID, Time, CPU %, Memory %, Memory Bytes, Virtual Memory Bytes" > $csv_file

    isql 1111 dba dba $isql_command &
    pid_isql=$!
    
    start_time=$(($(date +%s%N) / 1000000))
    # Loop to run the script and monitor performance every second
    while ps -p $pid_isql > /dev/null; do
        # Get the current time stamp
        timestamp=$(($(date +%s%N) / 1000000))
        
        runtime=$(($timestamp - $start_time))
        # ps_output=$(ps aux | grep $virtuoso_pid | grep -v grep | grep -v sudo)
        ps_output=$(top -b -n 1 -H -p $virtuoso_pid)

        while read -r line; do
            pid=$(echo "$line" | awk '{print $1}')
            cpu_usage=$(echo "$line" | awk '{print $5}' | tr , . )
            memory_usage=$(echo "$line" | awk '{print $6}' | tr , . )
            # mem_temp=$(echo "$line" | awk '{print $4}')
            # check_bytes $(echo "$line" | awk '{print $3}')
            memory_bytes=$(check_bytes $(echo "$line" | awk '{print $4}' | tr , . ))
            virt_memory_bytes=$(check_bytes $(echo "$line" | awk '{print $2}' | tr , . ))
            echo "$pid, $runtime, $cpu_usage, $memory_usage, $memory_bytes, $virt_memory_bytes" >> $csv_file ;
        done <<< "$ps_output"
        # Sleep for 0.1 seconds     --> no sleep needed, process takes around 500 milliseconds to complete
        # sleep 0.1
    done
    totaltime=$((($(date +%s%N) /1000000)  - $start_time))
    echo "Total runtime of $isql_command is $totaltime milliseconds"
}

monitor_virtuoso $isql_clear_bulk $csv_iqsl_clear 9529
monitor_virtuoso $isql_delete_nmbs $csv_isql_del_nmbs 9529
monitor_virtuoso $isql_load_nmbs $csv_isql_load_nmbs 9529
monitor_virtuoso $isql_delete_delijn $csv_isql_del_delijn 9529
monitor_virtuoso $isql_load_delijn $csv_isql_load_delijn 9529