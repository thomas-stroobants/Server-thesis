#! /usr/bin/bash

# top -b -d1 -o +%MEM | grep -A1 'KiB Mem' >> memory.log

log_monitor="$HOME/benchmark/log/test-nmbs-morph.log"

# Define the name of the Python script to be monitored
script_nmbs_1="$HOME/graphs-bench/config/config-nmbs-1.ini"
script_nmbs_2="$HOME/graphs-bench/config/config-nmbs-2.ini"
script_nmbs_3="$HOME/graphs-bench/config/config-nmbs-3.ini"
script_nmbs_4="$HOME/graphs-bench/config/config-nmbs-4.ini"
script_nmbs_5="$HOME/graphs-bench/config/config-nmbs-5.ini"
script_nmbs_6="$HOME/graphs-bench/config/config-nmbs-6.ini"
script_nmbs_7="$HOME/graphs-bench/config/config-nmbs-7.ini"
script_nmbs_8="$HOME/graphs-bench/config/config-nmbs-8.ini"

# Define the name of the CSV file to store the data
csv_nmbs_1="$HOME/benchmark/bench-morph/bench-morph-nmbs-1.csv"
csv_nmbs_2="$HOME/benchmark/bench-morph/bench-morph-nmbs-2.csv"
csv_nmbs_3="$HOME/benchmark/bench-morph/bench-morph-nmbs-3.csv"
csv_nmbs_4="$HOME/benchmark/bench-morph/bench-morph-nmbs-4.csv"
csv_nmbs_5="$HOME/benchmark/bench-morph/bench-morph-nmbs-5.csv"
csv_nmbs_6="$HOME/benchmark/bench-morph/bench-morph-nmbs-6.csv"
csv_nmbs_7="$HOME/benchmark/bench-morph/bench-morph-nmbs-7.csv"
csv_nmbs_8="$HOME/benchmark/bench-morph/bench-morph-nmbs-8.csv"

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
            # if [[ "$pid" == "PID" ]]
            # then 
            #     continue        #skip loop, header output
            # fi
            # echo "$line"
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

monitor_morph_kgc $script_nmbs_1 $csv_nmbs_1
monitor_morph_kgc $script_nmbs_2 $csv_nmbs_2
monitor_morph_kgc $script_nmbs_3 $csv_nmbs_3
monitor_morph_kgc $script_nmbs_4 $csv_nmbs_4
monitor_morph_kgc $script_nmbs_5 $csv_nmbs_5
monitor_morph_kgc $script_nmbs_6 $csv_nmbs_6
monitor_morph_kgc $script_nmbs_7 $csv_nmbs_7
monitor_morph_kgc $script_nmbs_8 $csv_nmbs_8