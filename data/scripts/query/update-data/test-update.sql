--test for update graph with rt data
SPARQL
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> 
-- PREFIX dct: <http://purl.org/dc/terms/>
-- PREFIX example: <http://example.com/>

MODIFY <http://example.com/nmbs>
DELETE
    {
        ?stoptime rdfs:label ?sk .
        ?stoptime gtfs:comment ?odelay .
        ?trip rdfs:label ?cl .
    }
INSERT
    {
        ?stoptime rdfs:label ?nsk .
        ?stoptime gtfs:comment ?ndelay .
        ?trip rdfs:label ?ncl .
    }
WHERE
    {
        GRAPH <http://example.com/nmbs>
            {
                ?trip rdf:type gtfs:Trip .
                ?stoptime rdf:type gtfs:StopTime .
                ?stoptime gtfs:departureTime ?dt .
                OPTIONAL {?stoptime rdfs:label ?sk} .
                OPTIONAL {?stoptime gtfs:comment ?odelay} .
                OPTIONAL {?trip rdfs:label ?cl} .
                -- FILTER (?dt >= "2023-05-16T00:00:00"^^xsd:dateTime && ?dt <= "2023-05-16T24:00:00"^^xsd:dateTime)
            }
        GRAPH <http://example.com/nmbs-rt>
            {
                ?stoptime rdf:type gtfs:StopTime .
                ?stoptime gtfs:stop ?nst .
                OPTIONAL {?stoptime rdfs:label ?nsk} .
                ?stoptime gtfs:comment ?ndelay .
                ?stoptime gtfs:trip ?trip .

                ?trip rdf:type gtfs:Trip .
            }
    }  ;

-- <http://example.com/nmbs/stoptimes/88____%3A007%3A%3A8821006%3A8891702%3A25%3A2250%3A20231208-8892007>