#!/bin/bash

# Check if psutil is installed
if ! python -c "import psutil" &> /dev/null; then
    echo "Installing psutil library..."
    pip install psutil
fi

# Import the psutil library
import psutil

# Start the target script
./target_script.sh &

# Get the PID of the target script
pid=$!

# Record the time the script starts
start_time=$(date +%s)

# Record the memory and CPU usage every second
echo "Timestamp, CPU, Memory, Swap, Virtual Memory" >> usage-psutil.csv
while True:
    process = psutil.Process(pid)
    cpu = process.cpu_percent()
    memory = process.memory_info().rss
    swap = psutil.swap_memory().used
    virtual = process.memory_info().vms
    echo "$(date), $cpu, $memory, $swap, $virtual" >> usage-psutil.csv
    sleep 1
    if process.is_running() == False:
        break

# Record the time the script ends
end_time=$(date +%s)

# Calculate the execution time
execution_time=$((end_time - start_time))
echo "Execution time: $execution_time seconds" >> usage-psutil.csv
