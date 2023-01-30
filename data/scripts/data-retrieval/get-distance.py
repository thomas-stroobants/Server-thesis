import requests

api_key = '5b3ce3597851110001cf624837aadf66f895432294b476f1fc9093b5'
startLat = 51.2065
startLng = 4.04151
endLat = 51.1737
endLng = 4.1493
start = f'{startLng},{startLat}'
end = f'{endLng},{endLat}'

url = f'https://api.openrouteservice.org/v2/directions/cycling-regular?api_key={api_key}&start={start}&end={end}'

response = requests.get(url)
data = response.json()
# print(data)
time = data['features'][0]['properties']['summary']['duration']
print(time, 'seconds')
