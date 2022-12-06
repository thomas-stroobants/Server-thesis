import json
import time

# my_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(1347517370))
with open('nmbs-rt-data/nmbs-rt-gtfs.json') as sfile:
    data = json.load(sfile)

for item in data["entity"]:
    for tripdata in item["tripUpdate"]:
        for stopdata in tripdata["stopTimeUpdate"]:
            for arrivaldata in stopdata["arrival"]:
                print(f"delay is {arrivaldata["delay"]}")
                # arrivaldata["delay"] = time.strftime('%H:%M:%S', time.localtime(arrivaldata["delay"]))