import morph_kgc
import requests

nmbs_url = "https://sncb-opendata.hafas.de/gtfs/static/c21ac6758dd25af84cca5b707f3cb3de"
nmbs_rt_url = "https://sncb-opendata.hafas.de/gtfs/realtime/c21ac6758dd25af84cca5b707f3cb3de"

response = requests.get(nmbs_url)
open("nmbs_static.zip", "wb").write(response.content)