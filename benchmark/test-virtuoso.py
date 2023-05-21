import psutil, subprocess, time, csv, os

isql_clear_bulk = os.path.join(os.path.expanduser('~'), '/data-bench/query/clear-bulk-load-list.sql')
isql_delete_nmbs = os.path.join(os.path.expanduser('~'), '/data-bench/query/delete-nmbs-graph.sql')
isql_delete_delijn = os.path.join(os.path.expanduser('~'), '/data-bench/query/delete-delijn-graph.sql')
isql_load_nmbs = os.path.join(os.path.expanduser('~'), '/data-bench/query/nmbs-load.sql')
isql_load_delijn = os.path.join(os.path.expanduser('~'), '/data-bench/query/delijn-load.sql')

scripts = [
    isql_clear_bulk,
    isql_delete_nmbs,
    isql_delete_delijn,
    isql_load_nmbs,
    isql_load_delijn
]

def monitor_virtuoso(isql_command, csv_file, virtuoso_pid):
    proc = subprocess.Popen(["isql", "1111", "dba", "dba", isql_command])
    start_time= int(time.time_ns() / 1000000)

    proc_virtuoso = psutil.Process(virtuoso_pid)
    results = []

    while proc.poll() is None:
        inter_time = int((time.time_ns() / 1000000) - start_time)
        for thread in proc_virtuoso.threads():
            proc_thread = psutil.Process(thread.id)
            cpu_percent = proc_thread.cpu_percent(interval=0.1)
            mem_percent = proc_thread.memory_percent()
            mem_mbytes = proc_thread.memory_info().rss / (1024 ** 2)
            virt_mem_mbytes = proc_thread.memory_info().vms / (1024 ** 2)
            results.append([inter_time, cpu_percent, mem_percent, mem_mbytes])
            print(f"{thread.id} | {cpu_percent} | {mem_percent} | {mem_mbytes} | {virt_mem_mbytes}")






def get_cvs_filename(script):
    filename = "test.csv"
    if isinstance(script, list):    #for python scripts
        filename = f"{os.path.expanduser('~')}/benchmark/bench-{os.path.splitext(os.path.basename(script[1]))[0]}.csv"
    else:                           #for bash scripts
        filename = f"{os.path.expanduser('~')}/benchmark/bench-{os.path.splitext(os.path.basename(script))[0]}.csv"

    print(f"Filename is {filename}")
    return filename




for script in scripts:
    filename = get_cvs_filename(script)
    print(f"new filename: {filename} and script {script}")
    proc = subprocess.Popen(script)
    record_usage(proc, 0.3, filename)
    loadavg = [round((x / psutil.cpu_count() * 100),2) for x in psutil.getloadavg()]
    print(f"Load average: {loadavg}")

