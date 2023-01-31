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

def download_files(url, file_name):
    response = requests.get(url)
    open(file_name, "wb").write(response.content)
    print(f"Content downloaded to {file_name}.")

def unzip_file(file_name, dst_folder):
    subprocess.run(["unzip", file_name, "-d", dst_folder])

def get_gtfs_rt_lijn():
    response = requests.get(de_lijn_rt_url, params=paramsjson, headers=headers)
    # print(response.content)
    # feed.ParseFromString(response.content)
    # feed_json = MessageToJson(feed)
    #write data to file
    # open(f"de-lijn-data/de-lijn-rt1-gtfs.json", "w").write(response.json())
    with open('de-lijn-data/de-lijn-rt1-gtfs.json', 'w') as ofile:
        json.dump(response.json(), ofile, indent = 2, sort_keys=True)

def get_gtfs_rf_nmbs():
    feed = gtfs_realtime_pb2.FeedMessage()
    response = requests.get(nmbs_rt_url)
    feed.ParseFromString(response.content)
    feed_json = MessageToJson(feed)
    print(feed_json)

def get_gtfs_rt(url, file_name, params=None, headers=None):
    feed = gtfs_realtime_pb2.FeedMessage()
    response = requests.get(url, params=params, headers=headers)
    feed.ParseFromString(response.content)
    feed_json = MessageToJson(feed)
    #write data to file
    open(file_name, "w").write(feed_json)


#download_files(nmbs_rt_url, "nmbs-rt-data/nmbs-rt-proto")
# get_gtfs_rt_lijn()
# get_gtfs_rf_nmbs()
get_gtfs_rt(de_lijn_rt_url, f"/home/thomas/data/de-lijn-rt-data/de-lijn-rt-gtfs2-{time.time()}.json", params=params, headers=headers)
get_gtfs_rt(de_lijn_rt1_url, f"/home/thomas/data/de-lijn-rt-data/de-lijn-rt-gtfs1-{time.time()}.json", headers=headers)
get_gtfs_rt(nmbs_rt_url, f"/home/thomas/data/nmbs-rt-data/nmbs-rt-gtfs-{time.time()}.json")
# get_gtfs_rt_lijn()