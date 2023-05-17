SPARQL
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> 
Select ?stoptime ?dt ?dl ?dtm from <http://example.com/nmbs> where { 

    BIND ( <http://example.com/nmbs/stoptimes/88____%3A007%3A%3A8821006%3A8891702%3A25%3A2250%3A20231208-8892007> as ?stoptime)
    ?stoptime gtfs:departureTime ?dt .
    ?stoptime xsd:integer ?dtm .
    BIND ((?dt + (?dtm)^^xsd:integer) as ?dl)
    FILTER (?dt >= "2023-05-16T00:00:00"^^xsd:dateTime && ?dt <= "2023-05-16T23:59:00"^^xsd:dateTime)

};

SPARQL
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> 
Select * from <http://example.com/de-lijn> where { 

    BIND ( <http://example.com/de-lijn/stoptimes/43584292-107329> as ?stoptime)
    #?stoptime gtfs:departureTime ?dt .
    #OPTIONAL {?stoptime gtfs:comment ?dtm .}
    ?stoptime ?p ?o
#    FILTER (?dt >= "2023-05-16T00:00:00"^^xsd:dateTime && ?dt <= "2023-05-16T23:59:00"^^xsd:dateTime)

};

SPARQL
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> 
Select * from <http://example.com/nmbs> where { 

    BIND ( <http://example.com/nmbs/trips/88____%3A007%3A%3A8896008%3A8894508%3A35%3A2136%3A20231208> as ?trip)
    #?stoptime gtfs:departureTime ?dt .
    #OPTIONAL {?stoptime gtfs:comment ?dtm .}
    ?trip rdfs:label ?o
#    FILTER (?dt >= "2023-05-16T00:00:00"^^xsd:dateTime && ?dt <= "2023-05-16T23:59:00"^^xsd:dateTime)

};


SPARQL
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> 
Select * from <http://example.com/de-lijn> where { 
                BIND ( <http://example.com/de-lijn/stoptimes/43584292-107329> as ?stoptime)
                ?trip rdf:type gtfs:Trip .
                OPTIONAL {?trip rdfs:label ?cl} .
                ?stoptime gtfs:trip ?trip .
                ?stoptime gtfs:departureTime ?dt .
                ?stoptime rdf:type gtfs:StopTime .
                ?stoptime gtfs:stop ?st .
                OPTIONAL {?stoptime gtfs:comment ?odelay} .
                FILTER (?dt >= "2023-05-16T00:00:00"^^xsd:dateTime && ?dt <= "2023-05-16T23:59:00"^^xsd:dateTime)

};