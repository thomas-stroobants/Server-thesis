import requests

api_key = 'YOUR_API_KEY'
origin = f'{startLat},{startLng}'
destination = f'{endLat},{endLng}'

url = f'https://maps.googleapis.com/maps/api/directions/json?origin={origin}&destination={destination}&mode=bicycling&key={api_key}'

response = requests.get(url)
data = response.json()
duration = data['routes'][0]['legs'][0]['duration']['text']
print(duration)
