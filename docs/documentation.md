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

# Routing schema's
## Optie 1
----
Traject: Stekene -> Sint-Niklaas -> Mechelen -> Sint-Katelijne-Waver

- Stekene: 
    -  Stekene Kerk 
        - 115207,"204391","Stekene Kerk","","51.2065","4.04151",,"https://www.delijn.be/nl/haltes/halte/204391","","",0
        - 116019,"205391","Stekene Kerk","","51.2064","4.04107",,"https://www.delijn.be/nl/haltes/halte/205391","","",1

    - Stekene Spoorwegwegel 
        - 115206,"204390","Stekene Spoorwegwegel","","51.2012","4.04168",,"https://www.delijn.be/nl/haltes/halte/204390","","",0
        - 116018,"205390","Stekene Spoorwegwegel","","51.2013","4.04185",,"https://www.delijn.be/nl/haltes/halte/205390","","",0

- Sint-Niklaas:
    - Sint-Niklaas Noordlaan
        - 114910,"204062","Sint-Niklaas Noordlaan","","51.1737","4.1493",,"https://www.delijn.be/nl/haltes/halte/204062","","",1
        - 115723,"205062","Sint-Niklaas Noordlaan","","51.1736","4.14936",,"https://www.delijn.be/nl/haltes/halte/205062","","",0

        - S8894508,,Saint-Nicolas,,51.1714700,4.14296300,,,1,,
        - 8894508,,Saint-Nicolas,,51.1714700,4.14296300,,,0,S8894508,

- Mechelen: 
        - S8822004,,Malines,,51.0176500,4.48278500,,,1,,
        - 8822004,,Malines,,51.0176500,4.48278500,,,0,S8822004,
        - 108386,"105066","Mechelen Station perron 1","","51.0177","4.48257",,"https://www.delijn.be/nl/haltes/halte/105066","","",1
        - 108450,"105169","Mechelen Station perron 1","","51.0177","4.48268",,"https://www.delijn.be/nl/haltes/halte/105169","","",1
        - 21781,"105219","Mechelen Station perron 17","","51.0188","4.48391",,"https://www.delijn.be/nl/haltes/halte/105219","","",0
        - 21784,"105222","Mechelen Station perron 16","","51.0188","4.48387",,"https://www.delijn.be/nl/haltes/halte/105222","","",0
        - 21785,"105223","Mechelen Station perron 13","","51.0185","4.48357",,"https://www.delijn.be/nl/haltes/halte/105223","","",0
        - 21786,"105224","Mechelen Station perron 19","","51.0187","4.48331",,"https://www.delijn.be/nl/haltes/halte/105224","","",0
        - 106621,"102679","Mechelen Station perron 15","","51.0187","4.48374",,"https://www.delijn.be/nl/haltes/halte/102679","","",0
        - 106634,"103066","Mechelen Station perron 21","","51.0189","4.48368",,"https://www.delijn.be/nl/haltes/halte/103066","","",0
        - 106745,"105221","Mechelen Station perron 10","","51.0183","4.48331",,"https://www.delijn.be/nl/haltes/halte/105221","","",0
        - 106757,"107390","Mechelen Station perron 20","","51.0188","4.48352",,"https://www.delijn.be/nl/haltes/halte/107390","","",0
        - 24362,"108056","Mechelen Station perron 11","","51.0184","4.48339",,"https://www.delijn.be/nl/haltes/halte/108056","","",0
        - 98566,"108057","Mechelen Station perron 12","","51.0185","4.48348",,"https://www.delijn.be/nl/haltes/halte/108057","","",0
        - 14409,"305821","Mechelen Station perron 14","","51.0187","4.48367",,"https://www.delijn.be/nl/haltes/halte/305821","","",0
        - 14411,"305823","Mechelen Station perron 18","","51.0189","4.48397",,"https://www.delijn.be/nl/haltes/halte/305823","","",0
        - 17153,"308817","Mechelen Station perron 16","","51.0188","4.48378",,"https://www.delijn.be/nl/haltes/halte/308817","","",0
        - 107900,"102984","Mechelen Station perron 9","","51.0183","4.48318",,"https://www.delijn.be/nl/haltes/halte/102984","","",1
        - 107922,"103057","Mechelen Station perron 4","","51.0181","4.48167",,"https://www.delijn.be/nl/haltes/halte/103057","","",1

- Sint-Katelijne-Waver:
        - 88917,"102301","Sint-Katelijne-Waver Station","","51.0693","4.49204",,"https://www.delijn.be/nl/haltes/halte/102301","","",0
        - 88918,"102302","Sint-Katelijne-Waver Station","","51.0692","4.49236",,"https://www.delijn.be/nl/haltes/halte/102302","","",0
        - 8822228,,Sint-Katelijne-Waver,,51.0699800,4.49611900,,,0,S8822228,
        - S8822228,,Sint-Katelijne-Waver,,51.0699800,4.49611900,,,1,,

Traject: Stekene -> Sint-Niklaas -> Antwerpen-Berchem -> Sint-Katelijne-Waver
    - Antwerpen-Berchem:
        - S8821121,,Anvers-Berchem,,51.1992300,4.43221900,,,1,,
        - 8821121,,Anvers-Berchem,,51.1992300,4.43221900,,,0,S8821121,


## Optie 2
----
Traject: Stekene -> Sint-Niklaas -> Gent-Sint-Pieters -> Zwijnaarde

## Optie 3
----
Traject: Gent-Sint-Pieters -> Mechelen -> Sint-Katelijne-Waver

## Optie 4
----
Traject: Gent-Sint-Pieters -> Brussel -> Paleis?
