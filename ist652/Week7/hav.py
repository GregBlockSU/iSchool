import math
from collections import namedtuple

def haversine_distance(origin, destination):
    radius = 6371 # FAA approved globe radius in km

    dlat = math.radians(destination.lat-origin.lat)
    dlon = math.radians(destination.lng-origin.lng)
    
    a = math.sin(dlat/2) * math.sin(dlat/2) + math.cos(math.radians(origin.lat)) \
        * math.cos(math.radians(destination.lat)) * math.sin(dlon/2) * math.sin(dlon/2)
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))
    d = radius * c

    # Return distance in km
    return int(math.floor(d))

LatLng = namedtuple('LatLng', 'lat, lng')
  
origin = LatLng(51.507222, -0.1275) # London
destination = LatLng(37.966667, 23.716667) # Athens

dist = haversine_distance(origin, destination)
print(f"Distance between London and Athens (km) is {dist}")