import psutil, subprocess, time, csv, os

scripts = [
    f"{os.path.expanduser('~')}/data-bench/data-retrieval/get-data.sh",
    ["python3", f"{os.path.expanduser('~')}/data-bench/data-retrieval/get_rt_data.py"],
    ["python3", f"{os.path.expanduser('~')}/data-bench/data-transformation/replace-irail.py"],
    ["python3", f"{os.path.expanduser('~')}/data-bench/data-transformation/connect-datetime.py"],
    ["python3", f"{os.path.expanduser('~')}/data-bench/data-transformation/connect-datetime-dl.py"],
    f"{os.path.expanduser('~')}/data-bench/data-transformation/test-split-stop.sh",
]

def monitor_virtuoso(isql_command, csv_file, virtuoso_pid):
    proc = subprocess.Popen(["isql", "1111", "dba", "dba", isql_command])
    start_time= int(time.time_ns() / 1000000)

    proc_virtuoso = psutil.Process(virtuoso_pid)
    results = []

    while proc.poll() is None:
        for thread in proc_virtuoso.threads():
        # for proc in psutil.process_iter(['pid', 'name', 'cpu_percent', 'memory_percent', 'memory_info']):
            inter_time = int((time.time_ns() / 1000000) - start_time)
            proc_thread = psutil.Process(thread.id)
            cpu_percent = proc_thread.cpu_percent(interval=0.1)
            mem_percent = proc_thread.memory_percent()
            mem_mbytes = proc_thread.memory_info().rss / (1024 ** 2)
            virt_mem_mbytes = proc_thread.memory_info().vms / (1024 ** 2)
            results.append([inter_time, cpu_percent, mem_percent, mem_mbytes])
            print(f"{thread.id} | {cpu_percent} | {mem_percent} | {mem_mbytes} | {virt_mem_mbytes}")
            # if proc.info['name'] == 'virtuoso-t':
            #     pid = proc.info['pid']
            #     cpu_usage = proc.info['cpu_percent']
            #     memory_usage = proc.info['memory_percent']
            #     memory_bytes = proc.info['memory_info'].rss
            #     virt_memory_bytes = proc.info['memory_info'].vms
            #     print(f"{pid} | {cpu_usage} | {memory_bytes} | {virt_memory_bytes}")
            #     results.append([pid, cpu_usage, memory_usage, memory_bytes, virt_memory_bytes])





def get_cvs_filename(script):
    filename = "test.csv"
    if isinstance(script, list):    #for python scripts
        filename = f"{os.path.expanduser('~')}/benchmark/bench-{os.path.splitext(os.path.basename(script[1]))[0]}.csv"
    else:                           #for bash scripts
        filename = f"{os.path.expanduser('~')}/benchmark/bench-{os.path.splitext(os.path.basename(script))[0]}.csv"

    print(f"Filename is {filename}")
    return filename

def record_usage(proc, interval, filename):
    records = []
    process = psutil.Process(proc.pid)

    start_time = time.time()

    while proc.poll() is None:
        cpu_percent = process.cpu_percent(interval=interval)
        mem_percent = process.memory_percent()
        mem_mbytes = process.memory_info().rss / (1024 ** 2)
        inter_time = round((time.time() - start_time), 5)
        records.append([inter_time, cpu_percent, mem_percent, mem_mbytes])
        time.sleep(interval)

    with open(filename, 'w') as f:
        writer = csv.writer(f)
        writer.writerow(['time', 'cpu_percent', 'memory_percent', 'memory_mbytes'])
        writer.writerows(records)
    
    runtime = records[-1][0] - records[0][0]
    print(f"Runtime is {runtime:.5f} seconds")


for script in scripts:
    filename = get_cvs_filename(script)
    print(f"new filename: {filename} and script {script}")
    proc = subprocess.Popen(script)
    record_usage(proc, 0.3, filename)
    loadavg = [round((x / psutil.cpu_count() * 100),2) for x in psutil.getloadavg()]
    print(f"Load average: {loadavg}")

