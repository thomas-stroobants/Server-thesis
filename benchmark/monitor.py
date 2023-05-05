import psutil

while True:
    print(f"The memory usage is {psutil.cpu_percent(interval=0.1)}%")