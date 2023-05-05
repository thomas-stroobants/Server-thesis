import psutil
import time
import subprocess
import csv
import threading
import os

scripts = ["/home/thomas/data-bench/data-retrieval/get-data.sh", "python3 /home/thomas/data-bench/data-retrieval/get_rt_data.py"]

# get resources from psutil
def get_resource_usage(process):
    # process = psutil.Process(pid)
    cpu_usage = process.cpu_percent()
    memory_usage = process.memory_info().rss
    return cpu_usage, memory_usage

# 
def check_resource_usage(script, process, writer, check_time):
    cpu_usage, memory_usage = get_resource_usage(process)
    writer.writerow([script, check_time, cpu_usage, memory_usage])
    # print(f"CPU usage: {cpu_usage}%")
    # print(f"Memory usage: {memory_usage/(1024**3):.2f}G")
    # timer to repeat every 0.1 seconds
    # timer = threading.Timer(0.1, check_resource_usage, args=[script, pid, writer, time.time()])
    # timer.start()

    # if psutil.Process(pid).status() == psutil.STATUS_ZOMBIE:
    #     timer.cancel()

# # list for subprocesses
# processes = []


# for script in scripts:
#     process = subprocess.Popen(script, shell=True)
#     pid = process.pid
#     start_time = time.time()
#     check_resource_usage(pid)
#     process.join()
#     stop_time = time.time()
#     processes.append((processes, pid ,start_time, stop_time))

# direct wegschrijven naar writer of gebruik maken van array?

for script in scripts:
    log_path = os.path.basename(script).split('.')[0]  + ".log"     # get name for log
    print(f"Log file is {log_path}")
    with open(log_path, "w") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["Script", "Runtime", "CPU usage", "Memory usage"])     # write header to csv
        process = subprocess.Popen(script, shell=False)                          # start script
        pid = process.pid
        ps_process = psutil.Process(pid)
        start_time = time.time()
        while process.poll() is None:
            check_resource_usage(script, ps_process, writer, time.time()) 
            time.sleep(0.3)                  # check resources

        end_time = time.time()
        runtime = end_time - start_time
        print(f"Runtime: {runtime} seconds")

# with open("data.csv", "w") as csvfile:
#     writer = csv.writer(csvfile)
#     writer.writerow(["Script", "Runtime", "CPU usage", "Memory usage"])
#     for script, pid, start_time in processes:
#         end_time = time.time()
#         runtime = end_time - start_time
#         print(f"Runtime: {runtime} seconds")
#         cpu_usage, memory_usage = get_resource_usage(pid)
#         print(f"CPU usage: {cpu_usage}%")
#         print(f"Memory usage: {memory_usage/(1024**3):.2f}G")
#         writer.writerow([script, runtime, cpu_usage, memory_usage])

# while True:
#     # print(f"The memory usage is {psutil.cpu_percent(interval=0.1)}%") #use the interval to block the system for a more accurate value
#     # split_cpu = psutil.cpu_percent(percpu=True, interval=0.1)
#     # for idx, usage in enumerate(split_cpu):
#     #     print(f"CORE {idx+1}: {usage}%")
    

#     mem_usage = psutil.memoru()

#     print(f"Free: {mem_usage.percent}%")
#     print(f"Total: {mem_usage.total/(1024**3):.2f}G")
#     print(f"Used: {mem_usage.used/(1024**3):.2f}G")