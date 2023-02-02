import requests
import subprocess
import http.client, urllib.request, urllib.parse, urllib.error, base64
from google.transit import gtfs_realtime_pb2
import time
import datetime
import json
from google.protobuf.json_format import MessageToJson
from pathlib import Path

nmbs_url = "https://sncb-opendata.hafas.de/gtfs/static/c21ac6758dd25af84cca5b707f3cb3de"
nmbs_rt_url = "https://sncb-opendata.hafas.de/gtfs/realtime/c21ac6758dd25af84cca5b707f3cb3de"
de_lijn_rt_url = "https://api.delijn.be/gtfs/v2/realtime?"
de_lijn_rt1_url = "https://api.delijn.be/gtfs/v1/realtime"
de_lijn_url = "https://api.delijn.be/DLKernOpenData/api/v1/"


subscription_key = '9ebca7dad65d4c1bb7d4cb7729b3c967'
subscription_key_kern = '78099eddec5a4c698e9424c53c46831e'

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

paramsjson = urllib.parse.urlencode({
    # Request parameters
    'json': 'true',
    'delay': 'true',
    'canceled': 'true',
    'source': '{string}',
    'gtfsversion': '{string}',
})

# Download GTFS-RT Protobuf data from URL
def get_protobuf_gtfs_rt(url, file_name, params=None, headers=None):
    feed = gtfs_realtime_pb2.FeedMessage()
    # Download Protobuf data from the server
    response = requests.get(url, params=params, headers=headers)
    if response.status_code == 200:
        # Convert data to string and to JSON
        feed.ParseFromString(response.content)
        feed_json = MessageToJson(feed)
        #write data to file
        open(file_name, "w").write(feed_json)
    else: 
        print(f"Request failed with status code: {response.status_code}")

# Donwload GTFS-RT JSON data from URL
def get_json_gtfs_rt(url, file_name, params=None, headers=None):
    # Download the JSON response from the server
    response = requests.get(url, params=params, headers=headers)

    if response.status_code == 200:
        # Write the results to a JSON file
        with open(file_name, "w") as out_file:
            json.dump(response.json(), out_file, indent=4)

    else: 
        print(f"Request failed with status code: {response.status_code}")

isotime = datetime.datetime.now().replace(microsecond=0).isoformat()
# get_protobuf_gtfs_rt(de_lijn_rt_url, f"{Path.home()}/data/de-lijn-rt-data/de-lijn-rt-gtfs-{isotime}.json", params=params, headers=headers)
get_protobuf_gtfs_rt(nmbs_rt_url, f"{Path.home()}/data/nmbs-rt-data/nmbs-rt-gtfs-{isotime}.json")
get_json_gtfs_rt(de_lijn_rt_url, f"{Path.home()}/data/de-lijn-rt-data/de-lijn-rt-{isotime}.json", params=paramsjson, headers=headers)
# get_protobuf_gtfs_rt(de_lijn_rt1_url, f"{Path.home()}/data/de-lijn-rt-data/de-lijn-rt-gtfs1-{isotime}.json", headers=headers)
