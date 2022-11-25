import morph_kgc
import requests


# generate the triples and load them to an RDFLib graph

# graph = morph_kgc.materialize(config)
# or
graph = morph_kgc.materialize('config.ini')

# work with the RDFLib graph
q_res = graph.query(' SELECT DISTINCT ?classes WHERE { ?s a ?classes } ')


# nmbs_url = "https://sncb-opendata.hafas.de/gtfs/static/c21ac6758dd25af84cca5b707f3cb3de"
# nmbs_rt_url = "https://sncb-opendata.hafas.de/gtfs/realtime/c21ac6758dd25af84cca5b707f3cb3de"

# response = requests.get(nmbs_url)
# open("nmbs_static.zip", "wb").write(response.content)


# import http.client, urllib.request, urllib.parse, urllib.error, base64

# from google.transit import gtfs_realtime_pb2
# import requests

# subscription_key = '9ebca7dad65d4c1bb7d4cb7729b3c967'

# headers = {
#     # Request headers
#     'Ocp-Apim-Subscription-Key': f'{subscription_key}',
# }

# params = urllib.parse.urlencode({
#     # Request parameters
#     'json': 'false',
#     'delay': 'true',
#     'canceled': 'true',
#     'source': '{string}',
#     'gtfsversion': '{string}',
# })

# feed = gtfs_realtime_pb2.FeedMessage()
# response = requests.get('https://api.delijn.be/gtfs/v2/realtime?', params=params, headers=headers)
# feed.ParseFromString(response.content)
# for entity in feed.entity:
#   if entity.HasField('trip_update'):
#     print(entity)
# # print(feed)
# # with open('readme.txt', 'w') as f:
# #     f.write(feed)