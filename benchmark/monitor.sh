#! /usr/bin/bash

# top -b -d1 -o +%MEM | grep -A1 'KiB Mem' >> memory.log


# Define the name of the Python script to be monitored
script_name="$HOME/graphs-bench/config/config-nmbs.ini"

# Define the name of the CSV file to store the data
csv_file="$HOME/benchmark/performance_data.csv"

# Write headers to the CSV file
echo "PID, Time, CPU %, Memory %, Memory Bytes" > $csv_file

python3 -m morph_kgc ~/graphs-bench/config/config-nmbs.ini &
pid_morph_nmbs=$!
start_time=$(date +%s%N | cut -b1-13)
# Loop to run the script and monitor performance every second
while ps -p $pid_morph_nmbs > /dev/null; do
    # Get the current time stamp
    timestamp=$(date +%s%N | cut -b1-13)

    runtime=$(($timestamp - $start_time))
    ps_output=$(ps aux | grep $script_name | grep -v grep)

    while read -r line; do
        pid=$(echo "$line" | awk '{print $2}')
        cpu_usage=$(echo "$line" | awk '{print $3}')
        memory_usage=$(echo "$line" | awk '{print $4}')
        memory_bytes=$(echo "$line" | awk '{print $6}')
        echo "$pid, $runtime, $cpu_usage, $memory_usage, $memory_bytes" >> $csv_file ;
    done <<< "$ps_output"

    # Sleep for 0.2 seconds
    sleep 0.1
done