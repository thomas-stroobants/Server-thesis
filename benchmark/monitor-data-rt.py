import psutil, subprocess, time, csv, os

scripts = [
    f"{os.path.expanduser('~')}/data-bench/data-retrieval/get-data.sh",
    ["python3", f"{os.path.expanduser('~')}/data-bench/data-retrieval/get_rt_data.py"],
    ["python3", f"{os.path.expanduser('~')}/data-bench/data-transformation/replace-irail.py"],
    ["python3", f"{os.path.expanduser('~')}/data-bench/data-transformation/connect-datetime.py"],
    ["python3", f"{os.path.expanduser('~')}/data-bench/data-transformation/connect-datetime-dl.py"],
    f"{os.path.expanduser('~')}/data-bench/data-transformation/test-split-stop.sh",

]

# proc = subprocess.Popen(["python3", f"{os.path.expanduser('~')}/data-bench/data-transformation/connect-datetime.py"])
# process = psutil.Process(proc.pid)

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
    print(f"Runtime is {runtime:.2f} seconds")


for script in scripts:
    filename = get_cvs_filename(script)
    print(f"new filename: {filename} and script {script}")
    proc = subprocess.Popen(script)
    record_usage(proc, 0.3, filename)
    loadavg = [round((x / psutil.cpu_count() * 100),2) for x in psutil.getloadavg()]
    print(f"Load average: {loadavg}")

# while proc.poll() is None:
#     cpu_usage.append(process.cpu_percent(interval=0.1))
#     mem_usage.append(process.memory_info())

# print(f"Average CPU: {sum(cpu_usage)/len(cpu_usage)}%")
# print(f"Average mem: {sum(mem_usage)/len(mem_usage)/(1024**3):.2f} bytes")
# print(f"{cpu_usage}")
# print(f"{mem_usage}")