#! /usr/bin/bash


log_monitor="$HOME/benchmark/log/test-virtuoso.log"

# Define the name of the Python script to be monitored
isql_clear_bulk="$HOME/data-bench/query/clear-bulk-load-list.sql"
isql_delete_nmbs="$HOME/data-bench/query/delete-nmbs-graph.sql"
isql_delete_delijn="$HOME/data-bench/query/delete-delijn-graph.sql"
isql_load_nmbs="$HOME/data-bench/query/nmbs-load.sql"
isql_load_delijn="$HOME/data-bench/query/delijn-load.sql"

# Define the name of the CSV file to store the data
csv_iqsl_clear="$HOME/benchmark/bench-virtuo/bench-isql-clear.csv"
csv_isql_del_nmbs="$HOME/benchmark/bench-virtuo/bench-isql-delete-nmbs.csv"
csv_isql_del_delijn="$HOME/benchmark/bench-virtuo/bench-isql-delete-delijn.csv"
csv_isql_load_nmbs="$HOME/benchmark/bench-virtuo/bench-isql-load-nmbs.csv"
csv_isql_load_delijn="$HOME/benchmark/bench-virtuo/bench-isql-load-delijn.csv"


check_bytes() {
    value=$1
    unit=${value:(-1)}
    if [ "$unit" == "g" ]; then
        num=$( echo ${value%$unit} | tr , . )
        # num=$(echo ${value%$unit})
        value=$(echo "$num * 1024 * 1024 " | bc | tr . , )        
    fi
    echo $value
}

monitor_virtuoso() {
    isql_command=$1
    csv_file=$2
    virtuoso_pid=$3

    # Write headers to the CSV file
    echo "PID;Time;CPU %;Memory %;Memory Bytes;Virtual Memory Bytes;State" > $csv_file

    isql 1111 dba dba $isql_command &
    pid_isql=$!
    
    start_time=$(($(date +%s%N) / 1000000))
    # Loop to run the script and monitor performance every second
    while ps -p $pid_isql > /dev/null; do
        # Get the current time stamp
        timestamp=$(($(date +%s%N) / 1000000))
        
        runtime=$(($timestamp - $start_time))
        # ps_output=$(ps aux | grep $virtuoso_pid | grep -v grep | grep -v sudo)
        ps_output=$(top -b -n 1 -H -p $virtuoso_pid | grep virtuoso-t)

        while read -r line; do
            pid=$(echo "$line" | awk '{print $1}')
            cpu_usage=$(echo "$line" | awk '{print $5}')
            memory_usage=$(echo "$line" | awk '{print $6}')
            memory_bytes=$(check_bytes $(echo "$line" | awk '{print $3}'))
            virt_memory_bytes=$(check_bytes $(echo "$line" | awk '{print $2}'))
            state=$(echo "$line" | awk '{print $4}' )
            echo "$pid;$runtime;$cpu_usage;$memory_usage;$memory_bytes;$virt_memory_bytes;$state" >> $csv_file ;
        done <<< "$ps_output"
        # Sleep for 0.1 seconds     --> no sleep needed, process takes around 500 milliseconds to complete
        # sleep 0.1
    done
    totaltime=$((($(date +%s%N) /1000000)  - $start_time))
    echo "Total runtime of $isql_command is $totaltime milliseconds" >> $log_monitor
}

pid_server=$1 #read pid from command line

monitor_virtuoso $isql_clear_bulk $csv_iqsl_clear $pid_server
monitor_virtuoso $isql_delete_nmbs $csv_isql_del_nmbs $pid_server
monitor_virtuoso $isql_delete_delijn $csv_isql_del_delijn $pid_server
monitor_virtuoso $isql_load_nmbs $csv_isql_load_nmbs $pid_server
monitor_virtuoso $isql_load_delijn $csv_isql_load_delijn $pid_server