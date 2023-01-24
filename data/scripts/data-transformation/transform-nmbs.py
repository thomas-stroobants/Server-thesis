import json
import time

# my_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(1347517370))
with open('./nmbs-rt-data/nmbs-rt-gtfs-new.json') as sfile:
    data = json.load(sfile)

    data["header"]["timestamp"] = time.strftime('%Y-%m-%dT%H:%M:%S', time.localtime(int(data["header"]["timestamp"])))

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
                tripdata['arrival']['time'] = time.strftime('%H:%M:%S', time.localtime(int(tripdata['arrival']['time'])))
            if 'departure' in tripdata:
                tripdata['departure']['time'] = time.strftime('%H:%M:%S', time.localtime(int(tripdata['departure']['time'])))

with open('./nmbs-rt-data/nmbs-rt-json-new-adap.json', 'w') as ofile:
    json.dump(data, ofile, indent = 2, sort_keys=True)