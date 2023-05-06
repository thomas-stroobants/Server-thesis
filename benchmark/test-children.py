import psutil, subprocess, time, csv, os

scripts = [
    ["python3", "-m", "morph_kgc", f"{os.path.expanduser('~')}/graphs-bench/config/config-irail.ini"],
    ["python3", "-m", "morph_kgc", f"{os.path.expanduser('~')}/graphs-bench/config/config-nmbs.ini"],
    # ["python3", "-m", "morph_kgc", f"{os.path.expanduser('~')}/graphs-bench/config/config-dl.ini"],
    # ["python3", "-m", "morph_kgc", f"{os.path.expanduser('~')}/graphs-bench/config/config-dl-2.ini"]

]

# proc = subprocess.Popen(["python3", f"{os.path.expanduser('~')}/data-bench/data-transformation/connect-datetime.py"])
# process = psutil.Process(proc.pid)

def get_cvs_filename(script):
    filename = "test.csv"
    if isinstance(script, list):    #for python scripts
        filename = f"{os.path.expanduser('~')}/benchmark/bench-test-{os.path.splitext(os.path.basename(script[-1]))[0]}.csv"
    else:                           #for bash scripts
        filename = f"{os.path.expanduser('~')}/benchmark/bench-test-{os.path.splitext(os.path.basename(script))[0]}.csv"

    print(f"Filename is {filename}")
    return filename

def record_usage(proc, interval, filename):
    records = []
    process = psutil.Process(proc.pid)
    print(f"PID is {proc.pid}")
    # children = process.children()
    # print(f"Children are {children}")
    # for child in children:
    #     print(f"Child PID is {child.pid}")
    #     cpu_percent = child.cpu_percent(interval=interval)
    #     mem_percent = child.memory_percent()
    #     mem_mbytes = child.memory_info().rss / (1024 ** 2)
    #     print(f"{cpu_percent}   |   {mem_mbytes}")
    start_time = time.time()

    while proc.poll() is None:
        cpu_percent = psutil.cpu_percent(interval=interval, percpu=True)
        mem_percent = psutil.virtual_memory().percent
        mem_mbytes = psutil.virtual_memory().active / (1024 ** 2)
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
    print(f"Load average before: {psutil.getloadavg()}")
    filename = get_cvs_filename(script)
    print(f"new filename: {filename} and script {script}")
    proc = subprocess.Popen(script)
    record_usage(proc, 0.3, filename)
    loadavg = [round((x / psutil.cpu_count() * 100),2) for x in psutil.getloadavg()]
    print(f"Load average: {loadavg}")
