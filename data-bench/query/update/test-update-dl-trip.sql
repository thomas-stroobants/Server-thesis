--test for update graph with rt data
SPARQL
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> 

MODIFY <http://example.com/de-lijn>
DELETE
    {
        ?trip rdfs:label ?cl .
    }
INSERT
    {
        ?trip rdfs:label ?ncl .
    }
WHERE
    {
        GRAPH <http://example.com/de-lijn>
            {
                ?trip rdf:type gtfs:Trip .
                OPTIONAL {?trip rdfs:label ?cl} .
            }
        GRAPH <http://example.com/de-lijn-rt>
            {
                ?trip rdf:type gtfs:Trip .
                OPTIONAL {?trip rdfs:label ?ncl} .
            }
    }  ;

