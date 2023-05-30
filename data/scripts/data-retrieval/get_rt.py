from google.transit import gtfs_realtime_pb2
from google.protobuf.json_format import MessageToJson
import requests

# Download GTFS-RT Protobuf data from URL
def get_protobuf_gtfs_rt(url, file_name, params=None, headers=None):
    feed = gtfs_realtime_pb2.FeedMessage()
    # Download Protobuf data from the server
    response = requests.get(url, params=params, headers=headers)
    if response.status_code == 200:
        # Convert data to string and to JSON
        feed.ParseFromString(response.content)
        feed_json = MessageToJson(feed)
        # Write data to file
        open(file_name, "w").write(feed_json)
    else: 
        print(f"Request failed with status code: {response.status_code}")
