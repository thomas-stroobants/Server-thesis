import json
import time
import datetime
from pathlib import Path


# my_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(1347517370))
with open(f'{Path.home()}/data/nmbs-rt-data/nmbs-rt-gtfs.json') as sfile:
    data = json.load(sfile)
    isoheader = datetime.datetime.fromtimestamp(int(data["header"]["timestamp"])).isoformat()
    data["header"]["timestamp"] = isoheader

    for item in data["entity"]:
        trip_id = item["tripUpdate"]["trip"]["tripId"]
        trip_startdate = item["tripUpdate"]["trip"]["startDate"]
        trip_starttime = item["tripUpdate"]["trip"]["startTime"]
        for tripdata in item["tripUpdate"]["stopTimeUpdate"]:
            #adding tripdata to stoptimeupdate --> creates large duplicates
            tripdata['tripId'] = trip_id
            tripdata['tripStartDate'] = trip_startdate
            tripdata['tripStartTime'] = trip_starttime
            #adapting the time format from posix to hh:mm:ss 
            if 'arrival' in tripdata:
                tripdata['arrival']['time'] = datetime.datetime.fromtimestamp(int(tripdata['arrival']['time'])).isoformat()
            if 'departure' in tripdata:
                tripdata['departure']['time'] = datetime.datetime.fromtimestamp(int(tripdata['departure']['time'])).isoformat()

with open(f'{Path.home()}/data/nmbs-rt-data/nmbs-rt-gtfs-adap.json', 'w') as ofile:
    json.dump(data, ofile, indent = 2, sort_keys=True)