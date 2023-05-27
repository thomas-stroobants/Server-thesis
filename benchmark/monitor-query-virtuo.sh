#! /usr/bin/bash

log_monitor="$HOME/benchmark/log/test-virtuoso-query.log"

# Define the name of the Python script to be monitored
isql_stekene_sn="$HOME/data-bench/query/route/test-st-sn.rq"
isql_sn_gsp="$HOME/data-bench/query/route/test-sn-gent.rq"
isql_gsp_imec="$HOME/data-bench/query/route/test-gsp-imec.rq"
isql_steken_imec="$HOME/data-bench/query/route/test-stekene-imec.rq"

# Define the name of the CSV file to store the data
csv_isql_stekene_sn="$HOME/benchmark/bench-isql-test-st-sn.csv"
csv_isql_sn_gsp="$HOME/benchmark/bench-isql-test-sn-gent.csv"
csv_isql_gsp_imec="$HOME/benchmark/bench-isql-test-gsp-imec.csv"
csv_isql_steken_imec="$HOME/benchmark/bench-isql-test-stekene-imec.csv"


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
            cpu_usage=$(echo "$line" | awk '{print $6}')
            memory_usage=$(echo "$line" | awk '{print $7}')
            # mem_temp=$(echo "$line" | awk '{print $4}')
            # check_bytes $(echo "$line" | awk '{print $3}')
            memory_bytes=$(check_bytes $(echo "$line" | awk '{print $4}'))
            virt_memory_bytes=$(check_bytes $(echo "$line" | awk '{print $2}'))
            state=$(echo "$line" | awk '{print $5}' )
            echo "$pid;$runtime;$cpu_usage;$memory_usage;$memory_bytes;$virt_memory_bytes;$state" >> $csv_file ;
        done <<< "$ps_output"
        # Sleep for 0.1 seconds     --> no sleep needed, process takes around 500 milliseconds to complete
        # sleep 0.1
    done
    totaltime=$((($(date +%s%N) /1000000)  - $start_time))
    echo "Total runtime of $isql_command is $totaltime milliseconds" >> $log_monitor
}

pid_server=$1

monitor_virtuoso $isql_stekene_sn $csv_isql_stekene_sn $pid_server
monitor_virtuoso $isql_sn_gsp $csv_isql_sn_gsp $pid_server
monitor_virtuoso $isql_gsp_imec $csv_isql_gsp_imec $pid_server
monitor_virtuoso $isql_steken_imec $csv_isql_steken_imec $pid_server