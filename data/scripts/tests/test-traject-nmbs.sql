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
SELECT ?trip_id ?stop ?depature_time ?name from <http://example.com/nmbs> 
where { 
    ?stop foaf:name "Sint-Niklaas".
    ?stop rdf:type gtfs:Stop .
    ?stoptime gtfs:stop ?stop .
    ?stoptime gtfs:trip ?trip_id .
    ?stoptime gtfs:departureTime ?depature_time.
    ?trip_id gtfs:headsign ?name .
    FILTER (?depature_time >= "2023-02-21T07:21:00"^^xsd:dateTime && ?depature_time <= "2023-02-21T07:40:00"^^xsd:dateTime)
    FILTER (?name != "Saint-Nicolas")
} 
LIMIT 20;