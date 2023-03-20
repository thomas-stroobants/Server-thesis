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
PREFIX gtfsroute: <http://example.com/de-lijn/routes/>
PREFIX gtfstrip: <http://example.com/de-lijn/trips/>
PREFIX gtfsstop: <http://example.com/de-lijn/stops/>

SELECT ?routeShortName ?routeDescription ?tripShortName ?stop ?stopLat ?stopLong   WHERE {
	?route a gtfs:Route .
	OPTIONAL { ?route gtfs:shortName ?routeShortName . }
	OPTIONAL { ?route dct:description ?routeDescription . }

	?trip a gtfs:Trip .
	OPTIONAL { ?trip gtfs:shortName ?tripShortName . FILTER (?tripShortName = 100)}
	?trip gtfs:service ?service .
	?trip gtfs:route ?route .

	?stopTime a gtfs:StopTime . 
	?stopTime gtfs:trip ?trip . 
	?stopTime gtfs:stop ?stop . 

	?stop a gtfs:Stop . 
	OPTIONAL { ?stop dct:description ?stopDescription . }
	OPTIONAL {
		?stop geo:lat ?stopLat . 
		?stop geo:long ?stopLong . 
	}

	?stop gtfs:wheelchairAccessible "1" .

    FILTER (?route=gtfsroute:68027 )
    
} GROUP BY ?route
ORDER BY ?stop


-------------------------
--view sequence of trip with details of stoptime/sequence/...
 SELECT * WHERE {
    ?stopTime a gtfs:StopTime .
    ?stopTime gtfs:trip ?trip .
    ?stopTime gtfs:stop ?stop .
    ?stopTime gtfs:stopSequence ?sequence .
    ?stopTime gtfs:departureTime ?depTime .

    ?stop a gtfs:Stop .

    ?trip a gtfs:Trip .
    ?trip gtfs:route ?route .

    OPTIONAL {?stop foaf:name ?stopName} 
    FILTER (?trip=<http://example.com/de-lijn/trips/42697647>)

} ORDER BY ?depTime ?sequence