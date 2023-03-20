#!/bin/bash

# Start the target script
./target_script.sh &

# Get the PID of the target script
pid=$!

# Record the time the script starts
start_time=$(date +%s)

# Record the memory and CPU usage every second
echo "Timestamp, CPU Load, Memory Usage, Swap Usage, Virtual Memory" >> usage-top.csv
while true; do
    top -b -n1 -p $pid | awk 'NR>7 {print $9, $10, $6, $5}' >> usage-top.csv
    sleep 1
    if ! ps -p $pid > /dev/null ; then
        break
    fi
done

# Record the time the script ends
end_time=$(date +%s)

# Calculate the execution time
execution_time=$((end_time - start_time))
echo "Execution time: $execution_time seconds" >> usage-top.csv
