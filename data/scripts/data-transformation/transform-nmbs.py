import json
import datetime
from pathlib import Path

# Return the ISO time from POSIX time
def get_iso_time(posix):
    return datetime.datetime.fromtimestamp(int(posix)).isoformat()


with open(f'{Path.home()}/data/nmbs-rt-data/nmbs-rt-gtfs.json') as sfile:
    # Read JSON data
    data = json.load(sfile)
    # isoheader = datetime.datetime.fromtimestamp(int(data["header"]["timestamp"])).isoformat()
    data["header"]["timestamp"] = get_iso_time(data["header"]["timestamp"])

    for item in data["entity"]:
        # Get details of tripUpdate
        trip_id = item["tripUpdate"]["trip"]["tripId"]
        trip_startdate = item["tripUpdate"]["trip"]["startDate"]
        trip_starttime = item["tripUpdate"]["trip"]["startTime"]
        for tripdata in item["tripUpdate"]["stopTimeUpdate"]:
            # Add tripdata to stoptimeupdate --> creates large duplicates
            tripdata['tripId'] = trip_id
            tripdata['tripStartDate'] = trip_startdate
            tripdata['tripStartTime'] = trip_starttime
            # Adapt the time format from posix to hh:mm:ss 
            if 'arrival' in tripdata:
                tripdata['arrival']['time'] = get_iso_time(int(tripdata['arrival']['time']))
            if 'departure' in tripdata:
                tripdata['departure']['time'] = get_iso_time(int(tripdata['departure']['time']))

# Write adapted JSON data to JSON file
with open(f'{Path.home()}/data/nmbs-rt-data/nmbs-rt-gtfs-adap.json', 'w') as ofile:
    json.dump(data, ofile, indent = 2, sort_keys=True)