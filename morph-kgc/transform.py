import json
import time

# my_time = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(1347517370))
with open('nmbs-rt-data/nmbs-rt-gtfs-new.json') as sfile:
    data = json.load(sfile)

data["header"]["timestamp"] = time.strftime('%Y-%m-%dT%H:%M:%S', time.localtime(int(data["header"]["timestamp"])))

# No need to transform departure/arrival times, the static data also uses posix time, this may however be needed for the development for the skill
# for item in data["entity"]:
#     for tripdata in item["tripUpdate"]["stopTimeUpdate"]:
#         if 'arrival' in tripdata:
#             tripdata['arrival']['time'] = time.strftime('%H:%M:%S', time.localtime(int(tripdata['arrival']['time'])))
#         if 'departure' in tripdata:
#             tripdata['departure']['time'] = time.strftime('%H:%M:%S', time.localtime(int(tripdata['departure']['time'])))

with open('nmbs-rt-json-new-adap.json', 'w') as ofile:
    json.dump(data, ofile, indent = 2, sort_keys=True)