#! /usr/bin/bash

log_monitor="$HOME/benchmark/log/test-query.log"

# Define the name of the Python script to be monitored
isql_q_st_sn="$HOME/data-bench/query/route/test-st-sn.rq"
isql_q_sn_gsp="$HOME/data-bench/query/route/test-sn-gent.rq"
isql_q_gsp_imec="$HOME/data-bench/query/route/test-gsp-imec.rq"
isql_q_st_imec_no_rt="$HOME/data-bench/query/route/test-stekene-imec-no-rt.rq"
isql_q_st_imec_rt="$HOME/data-bench/query/route/test-stekene-imec-rt.rq"

# Define the name of the CSV file to store the data
csv_q_st_sn="$HOME/benchmark/bench-query/test-st-sn.csv"
csv_q_sn_gsp="$HOME/benchmark/bench-query/test-sn-gent.csv"
csv_q_gsp_imec="$HOME/benchmark/bench-query/test-gsp-imec.csv"
csv_q_st_imec_no_rt="$HOME/benchmark/bench-query/test-stekene-imec-no-rt.csv"
csv_q_st_imec_rt="$HOME/benchmark/bench-query/test-stekene-imec-rt.csv"


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

monitor_test() {
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
        ps_output=$(top -b -n 1 -p $virtuoso_pid | grep virtuoso-t )

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
        # sleep 0.7
    done
    totaltime=$((($(date +%s%N) /1000000)  - $start_time))
    echo "Total runtime of $isql_command is $totaltime milliseconds" >> $log_monitor

}

pid_server=$1 #read pid from command line
# test st to sn
# for i in {1..10}
# do
#     monitor_test $isql_q_st_sn $csv_q_st_sn $pid_server
#     sleep 1
# done
# # test sn to gsp
# for i in {1..10}
# do
#     monitor_test $isql_q_sn_gsp $csv_q_sn_gsp $pid_server
#     sleep 1
# done
# # test gsp to imec
# for i in {1..10}
# do
#     monitor_test $isql_q_gsp_imec $csv_q_gsp_imec $pid_server
#     sleep 1
# done
# test st to imec without delays
# for i in {1..10}
# do
    # monitor_test $isql_q_st_imec_no_rt $csv_q_st_imec_no_rt $pid_server
#     sleep 1
# done
# # test st to imec with delays
for i in {1..10}
do
    monitor_test $isql_q_st_imec_rt $csv_q_st_imec_rt $pid_server
    sleep 1
done