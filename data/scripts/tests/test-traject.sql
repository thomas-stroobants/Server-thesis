--test for data retrieval trajects
SPARQL
PREFIX rr: <http://www.w3.org/ns/r2rml#> 
PREFIX rml: <http://semweb.mmlab.be/ns/rml#> 
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX ql: <http://semweb.mmlab.be/ns/ql#> 
PREFIX map: <http://mapping.example.com/> 
PREFIX ma: <http://www.w3.org/ns/ma-ont#> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> 
PREFIX sd: <http://www.w3.org/ns/sparql-service-description#> 
PREFIX dc: <http://purl.org/dc/elements/1.1/> 
PREFIX foaf: <http://xmlns.com/foaf/0.1/> 
PREFIX rev: <http://purl.org/stuff/rev#> 
PREFIX v: <http://rdf.data-vocabulary.org/#> 
PREFIX schema: <http://schema.org/> 
PREFIX gtfs: <http://vocab.gtfs.org/terms#> 
PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#> 
PREFIX dct: <http://purl.org/dc/terms/> 
SELECT ?trip_id ?stop ?depature_time ?name from <http://example.com/de-lijn> 
where { 
    ?stop gtfs:code "204391".
    ?stop rdf:type gtfs:Stop .
    ?stoptime gtfs:stop ?stop .
    ?stoptime gtfs:trip ?trip_id .
    ?stoptime gtfs:departureTime ?depature_time.
    ?trip_id gtfs:headsign ?name .
    FILTER (?depature_time >= "2023-02-21T08:00:00"^^xsd:dateTime && ?depature_time <= "2023-02-21T10:00:00"^^xsd:dateTime)
} 
LIMIT 20;



---------------------------------
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?departureTime ?stopName
WHERE {
  # Find the stop ID for the start stop name
  ?startStop gtfs:stop_name "START_STOP_NAME" .
  # Find the stop ID for the destination stop name
  ?destStop gtfs:stop_name "DESTINATION_STOP_NAME" .
  # Find the trip ID that goes from start stop to destination stop at the given arrival time
  ?trip gtfs:route ?route ;
        gtfs:trip_headsign ?destStop ;
        gtfs:service ?service ;
        gtfs:direction_id ?direction ;
        gtfs:trip_id ?tripId .
  ?service gtfs:has_service_date ?date ;
           gtfs:has_day_of_week ?dayOfWeek .
  FILTER(str(?date) = "2023-02-22"^^xsd:date && ?dayOfWeek = "http://vocab.gtfs.org/terms#Monday")
  # Get the departure time of the trip at the start stop
  ?stopTime gtfs:trip ?trip ;
            gtfs:stop ?startStop ;
            gtfs:departure_time ?departureTime .
  # Get the stop sequence and name for all stops between start and destination
  ?stopTime2 gtfs:trip ?trip ;
             gtfs:stop ?stop ;
             gtfs:stop_sequence ?stopSeq .
  ?stop gtfs:stop_name ?stopName .
  FILTER(?stopSeq >= (SELECT ?stopSeq2 WHERE {
                        ?stopTime3 gtfs:trip ?trip ;
                                   gtfs:stop ?startStop ;
                                   gtfs:stop_sequence ?stopSeq2 .
                      }))
  FILTER(?stopSeq <= (SELECT ?stopSeq3 WHERE {
                        ?stopTime4 gtfs:trip ?trip ;
                                   gtfs:stop ?destStop ;
                                   gtfs:stop_sequence ?stopSeq3 .
                      })))
}
ORDER BY ?stopSeq



--------------------------------------------


SELECT ?departureTime ?stopName
WHERE {
    ?startStop a gtfs:Stop .
    ?startStop foaf:name "Stekene Kerk" .

    ?destStop a gtfs:Stop .
    ?destStop foaf:name "Sint-Niklaas Noordlaan" .
    
    ?trip a gtfs:Trip .
    ?trip gtfs:route ?route .
    ?trip gtfs:direction ?direction .
    ?trip dct:identifier ?tripId .

    ?stopTime a gtfs:StopTime .
    ?stopTime gtfs:trip ?trip .
    ?stopTime gtfs:stop ?startStop .
    ?stopTime gtfs:departureTime ?departureTimeStart .

    ?stopTime2 a gtfs:StopTime .
    ?stopTime2 gtfs:trip ?trip .
    ?stopTime2 gtfs:stop ?destStop .
    ?stopTime2 gtfs:stopSequence ?destSeq.

} ORDER BY ?stopSeq
-----------------------------------

SPARQL
PREFIX rr: <http://www.w3.org/ns/r2rml#> 
PREFIX rml: <http://semweb.mmlab.be/ns/rml#> 
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX ql: <http://semweb.mmlab.be/ns/ql#> 
PREFIX map: <http://mapping.example.com/> 
PREFIX ma: <http://www.w3.org/ns/ma-ont#> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> 
PREFIX sd: <http://www.w3.org/ns/sparql-service-description#> 
PREFIX dc: <http://purl.org/dc/elements/1.1/> 
PREFIX foaf: <http://xmlns.com/foaf/0.1/> 
PREFIX rev: <http://purl.org/stuff/rev#> 
PREFIX v: <http://rdf.data-vocabulary.org/#> 
PREFIX schema: <http://schema.org/> 
PREFIX gtfs: <http://vocab.gtfs.org/terms#> 
PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#> 
PREFIX dct: <http://purl.org/dc/terms/> 


SELECT ?startStop ?stopCode1 ?time1 ?stopTime ?seq1 ?trip ?destStop ?time2 ?seq2 ?stopTime2 ?trip2 ?direction
WHERE {
    ?startStop a gtfs:Stop .
    ?startStop foaf:name "Stekene Kerk" .
    ?startStop gtfs:code ?stopCode1 .


    ?destStop a gtfs:Stop .
    ?destStop foaf:name "Sint-Niklaas Uitgang Noordlaan" .
    
    ?trip a gtfs:Trip .
    ?trip gtfs:route ?route .
    ?trip gtfs:direction ?direction .
    ?trip dct:identifier ?tripId .


    ?stopTime a gtfs:StopTime .
    ?stopTime gtfs:stop ?startStop.
    ?stopTime gtfs:trip ?trip .
    ?stopTime gtfs:departureTime ?time1 .
    ?stopTime gtfs:stopSequence ?seq1 .
    FILTER (?time1 >= "2023-02-21T07:00:00"^^xsd:dateTime && ?time1 <= "2023-02-21T08:00:00"^^xsd:dateTime)

    
    ?stopTime2 a gtfs:StopTime .
    ?stopTime2 gtfs:stop ?destStop .
    ?stopTime2 gtfs:trip ?trip .
    ?stopTime2 gtfs:departureTime ?time2 .
    FILTER (?time2 >= "2023-02-21T07:00:00"^^xsd:dateTime && ?time2 <= "2023-02-21T08:00:00"^^xsd:dateTime)

} GROUP BY ?startStop ORDER BY ?time1 ?time2