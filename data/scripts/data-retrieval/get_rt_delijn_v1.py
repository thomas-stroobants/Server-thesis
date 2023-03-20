########### Python 3.2 #############
import http.client, urllib.request, urllib.parse, urllib.error, base64
from google.transit import gtfs_realtime_pb2
from google.protobuf.json_format import MessageToJson
import datetime
from pathlib import Path

headers = {
    # Request headers
    'Ocp-Apim-Subscription-Key': '9ebca7dad65d4c1bb7d4cb7729b3c967',
}

params = urllib.parse.urlencode({
})

try:
    conn = http.client.HTTPSConnection('api.delijn.be')
    conn.request("GET", "/gtfs/v1/realtime?%s" % params, "{body}", headers)
    response = conn.getresponse()
    data = response.read()
    feed = gtfs_realtime_pb2.FeedMessage()
    feed.ParseFromString(data)
    feed_json = MessageToJson(feed)
    print(feed_json)
    isotime = datetime.datetime.now().replace(microsecond=0).isoformat()
    open(f"{Path.home()}/data/de-lijn-rt-data/de-lijn-rt-gtfs1-{isotime}.json", "w").write(feed_json)
    conn.close()
except Exception as e:
    print("[Errno {0}] {1}".format(e.errno, e.strerror))
