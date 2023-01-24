# XSD date/time formats

# Structure vocabulary RT data


| Field | Type | Mapping/IRI | Needs formatting? |
| ---------- | ---------- | ---------- | ---------- |
| tripID | a gtfs:Trip | http://example.com/nmbs/trips/$(trip_id) | No? |
| trip.startDate | schema:startDate ^^xsd:date
| trip.startTime | 
| ---------- | ---------- | ---------- | ---------- |
| stopTimeUpdate.stopID | 
| stopTimeUpdate.stopID.arrival |
| stopTimeUpdate.stopID.departure |

stopTimeUpdate.stopID --> delay is in seconden!


88____:L70::8841525:8844008:11:1951:20231208
            stopID start: stopID stop: aantal stops: aankomsttijd: tot wanneer geldig?



De Lijn GTFS RT data
- header is zelfde als nmbs

- entity:
        ID: unieke ID voor gtfs updates, incrementeel
        tripupdate:
            trip bevat een tripid
            startdate en schedulerelationship als de trip gecanceled is/wordt. dit komt overeen met een in de static geregistreerde stopID
        stoptimeupdate
            bevat enkele update voor een vertrekn van een bepaalde stopID
            negatieve tijd geeft aan voor op schema
        Vehicle
            id voor het voertuig te identificeren
        timestamp
            tijd van laatste update van voertuig/lijn??


# Setup Virtuoso server
checkpoint interval = 60
scheduler interval = 10


# Testing van morph-kgc engine configuration
Bij het testen is uitgebleken dat morph-kgc voldoende ram geheugen nodig heeft om te kunnen werken.

Uit de paper is te lezen dat er 3 verschillende configuraties zijn:
- zonder mapping partitions
- met mapping partitions en sequentieel processing
- met mapping partitions en parallel processing

Uit de grafieken blijken dat het gebruik van mapping partities met sequentieel processing het minste ram gebruikt maar wel langer aan het werken is (maar een beetke langer dan zonder mapping partities)