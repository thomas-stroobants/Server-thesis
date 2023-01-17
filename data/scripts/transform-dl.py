import json
import time

with open('de-lijn-data/de-lijn-rt-gtfs-new.json') as sfile:
    data = json.load(sfile)

    data["header"]["timestamp"] = time.strftime('%Y-%m-%dT%H:%M:%S', time.localtime(int(data["header"]["timestamp"])))

    for item in data["entity"]:
        if 'startDate' in item["tripUpdate"]["trip"]:
            item["tripUpdate"]["trip"]['startDate'] = time.strftime('%Y-%m-%d', time.localtime(int(item["tripUpdate"]["trip"]['startDate'])))
            
        #adapting the time format from posix to hh:mm:ss 
        item['tripUpdate']['timestamp'] = time.strftime('%H:%M:%S', time.localtime(int(item['tripUpdate']['timestamp'])))
        

with open('de-lijn-rt-gtfs-new-adap.json', 'w') as ofile:
    json.dump(data, ofile, indent = 2, sort_keys=True)