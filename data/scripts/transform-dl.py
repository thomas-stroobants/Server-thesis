import json
import time
import os

with open("/home/thomas/data/de-lijn-rt-data/de-lijn-rt-gtfs.json") as sfile:
    data = json.load(sfile)

    data["header"]["timestamp"] = time.strftime('%Y-%m-%dT%H:%M:%S', time.localtime(int(data["header"]["timestamp"])))

    for item in data["entity"]:
        # item["tripUpdate"]["stopTimeUpdate"][0]["timestamp"]=time.strftime('%H:%M:%S', time.localtime(int(item['tripUpdate']['timestamp'])))
            # item["tripUpdate"]["stopTimeUpdate"][0]["tripId"]=item['tripUpdate']['trip']['tripId']
            # item["tripUpdate"]["stopTimeUpdate"][0]["scheduleRelationship"]=item["tripUpdate"]["trip"]['scheduleRelationship']
            # for it in item["tripUpdate"]["stopTimeUpdate"]:
            #     it["timestamp"] = time.strftime('%H:%M:%S', time.localtime(int(item['tripUpdate']['timestamp'])))
            #     it["tripId"] = item['tripUpdate']['trip']['tripId']
            #     it['scheduleRelationship'] = item["tripUpdate"]["trip"]['scheduleRelationship']
            # item["tripUpdate"]["trip"]['timestamp'] = time.strftime('%H:%M:%S', time.localtime(int(item['tripUpdate']['timestamp'])))
        if 'stopTimeUpdate' in item["tripUpdate"]:
            for it in item["tripUpdate"]["stopTimeUpdate"]:
                it["timestamp"] = time.strftime('%H:%M:%S', time.localtime(int(item['tripUpdate']['timestamp'])))
                it["tripId"] = item['tripUpdate']['trip']['tripId']

        #adapting the time format from posix to hh:mm:ss 
        # item['tripUpdate']['timestamp'] = time.strftime('%H:%M:%S', time.localtime(int(item['tripUpdate']['timestamp'])))
        

        elif 'startDate' in item["tripUpdate"]["trip"]:
            new_data = [{ "timestamp" : time.strftime('%H:%M:%S', time.localtime(int(item['tripUpdate']['timestamp']))),
                         "tripId" : item['tripUpdate']['trip']['tripId'],
                         "scheduleRelationship" : item["tripUpdate"]["trip"]['scheduleRelationship'] }]
            stopTime = { "stopTimeUpdate" : new_data}
            item["tripUpdate"]["stopTimeUpdate"] = new_data
            

with open('/home/thomas/data/de-lijn-rt-data/de-lijn-rt-gtfs-new-adap.json', 'w') as ofile:
    json.dump(data, ofile, indent = 2, sort_keys=True)