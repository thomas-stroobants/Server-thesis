import json
import time
import os
import datetime
from pathlib import Path

with open(f'{Path.home()}/data-bench/de-lijn-rt-data/de-lijn-rt-gtfs.json') as sfile:
    data = json.load(sfile)

    data["header"]["timestamp"] = datetime.datetime.fromtimestamp(int(data["header"]["timestamp"])).isoformat()

    for item in data["entity"]:
        if 'stopTimeUpdate' in item["tripUpdate"]:
            trip_id = item["tripUpdate"]["trip"]["tripId"]

            for stopArr in item["tripUpdate"]["stopTimeUpdate"]:
                stopArr['tripId'] = trip_id
                # delay_seconds = stopArr["departure"]["delay"]
                # if delay_seconds >= 0:
                #     stopArr["departure"]["delay"] = f"P{delay_seconds}M"
                # else: 
                #     stopArr["departure"]["delay"] = f"-P{delay_seconds}M"

with open(f'{Path.home()}/data-bench/de-lijn-rt-data/de-lijn-rt-gtfs-adap.json', 'w') as ofile:
    json.dump(data, ofile, indent = 2, sort_keys=True)