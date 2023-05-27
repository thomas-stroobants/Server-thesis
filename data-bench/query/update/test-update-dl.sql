--test for update graph with rt data
SPARQL
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> 

MODIFY <http://example.com/de-lijn>
DELETE
    {
        ?stoptime gtfs:comment ?odelay .
    }
INSERT
    {
        ?stoptime gtfs:comment ?ndelay .
    }
WHERE
    {
        GRAPH <http://example.com/de-lijn>
            {
                ?stoptime gtfs:trip ?trip .
                ?stoptime rdf:type gtfs:StopTime .
                ?stoptime gtfs:stop ?st .
                OPTIONAL {?stoptime gtfs:comment ?odelay} .
            }
        GRAPH <http://example.com/de-lijn-rt>
            {
                ?stoptime gtfs:trip ?trip .
                ?stoptime rdf:type gtfs:StopTime .
                ?stoptime gtfs:stop ?nst .
                OPTIONAL {?stoptime gtfs:comment ?ndelay} .
            }
    }  ;

