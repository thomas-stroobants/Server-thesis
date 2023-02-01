########### Python 3.2 #############
import http.client, urllib.request, urllib.parse, urllib.error, base64
from google.transit import gtfs_realtime_pb2
from google.protobuf.json_format import MessageToJson

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
    feed.ParseFromString(response.read())
    feed_json = MessageToJson(feed)
    print(feed_json)
    conn.close()
except Exception as e:
    print("[Errno {0}] {1}".format(e.errno, e.strerror))

####################################