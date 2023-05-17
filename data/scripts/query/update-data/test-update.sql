--test for update graph with rt data
SPARQL
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> 

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
                OPTIONAL {?trip rdfs:label ?cl} .
                ?stoptime gtfs:trip ?trip .
                ?stoptime rdf:type gtfs:StopTime .
                OPTIONAL {?stoptime rdfs:label ?sk} .
                OPTIONAL {?stoptime gtfs:comment ?odelay} .
            }
        GRAPH <http://example.com/nmbs-rt>
            {
                ?trip rdf:type gtfs:Trip .
                OPTIONAL {?trip rdfs:label ?ncl} .
                ?stoptime gtfs:trip ?trip .
                ?stoptime rdf:type gtfs:StopTime .
                ?stoptime gtfs:stop ?nst .
                OPTIONAL {?stoptime rdfs:label ?nsk} .
                ?stoptime gtfs:comment ?ndelay .

            }
    }  ;
