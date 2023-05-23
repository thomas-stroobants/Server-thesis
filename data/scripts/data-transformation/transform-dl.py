import json
import datetime
from pathlib import Path

# Return the ISO time from POSIX time
def get_iso_time(posix):
    return datetime.datetime.fromtimestamp(int(posix)).isoformat()

with open(f'{Path.home()}/data/de-lijn-rt-data/de-lijn-rt-gtfs.json') as sfile:
    data = json.load(sfile)

    data["header"]["timestamp"] = get_iso_time(data["header"]["timestamp"])
    
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

with open(f'{Path.home()}/data/de-lijn-rt-data/de-lijn-rt-gtfs-adap.json', 'w') as ofile:
    json.dump(data, ofile, indent = 2, sort_keys=True)