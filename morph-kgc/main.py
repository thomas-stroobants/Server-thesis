import morph_kgc
import requests
import subprocess
import http.client, urllib.request, urllib.parse, urllib.error, base64
from google.transit import gtfs_realtime_pb2
import time
import json
from google.protobuf.json_format import MessageToJson

nmbs_url = "https://sncb-opendata.hafas.de/gtfs/static/c21ac6758dd25af84cca5b707f3cb3de"
nmbs_rt_url = "https://sncb-opendata.hafas.de/gtfs/realtime/c21ac6758dd25af84cca5b707f3cb3de"
de_lijn_url = "https://api.delijn.be/gtfs/v2/realtime?"

subscription_key = '9ebca7dad65d4c1bb7d4cb7729b3c967'

headers = {
    # Request headers
    'Ocp-Apim-Subscription-Key': f'{subscription_key}',
}

params = urllib.parse.urlencode({
    # Request parameters
    'json': 'false',
    'delay': 'true',
    'canceled': 'true',
    'source': '{string}',
    'gtfsversion': '{string}',
})


def download_files(url, file_name):
    response = requests.get(url)
    open(file_name, "wb").write(response.content)
    print(f"Content downloaded to {file_name}.")

def unzip_file(file_name, dst_folder):
    subprocess.run(["unzip", file_name, "-d", dst_folder])

def get_gtfs_lijn():
    feed = gtfs_realtime_pb2.FeedMessage()
    response = requests.get('https://api.delijn.be/gtfs/v2/realtime?', params=params, headers=headers)
    feed.ParseFromString(response.content)
    feed_json = MessageToJson(feed)
    # print(type(feed_json))
    
    open(f"de-lijn-data/de-lijn-{int(time.time())}.json", "w").write(feed_json)
    
    # for entity in feed.entity:
    #     if entity.HasField('trip_update'):
    #         print(entity)

#download_files(nmbs_rt_url, "nmbs-rt-data/nmbs-rt-proto")
get_gtfs_lijn()