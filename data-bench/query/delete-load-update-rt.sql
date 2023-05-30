-- Delete NMBS-RT graph
log_enable(3,1);
SPARQL CLEAR GRAPH <http://example.com/nmbs-rt>;

-- Delete De Lijn-RT graph
log_enable(3,1);
SPARQL CLEAR GRAPH <http://example.com/de-lijn-rt>;

-- Clear bulk load list
DELETE FROM DB.DBA.load_list
WHERE ll_state = 2;

-- Prepare graphs for loading
ld_dir('/home/thomas/graphs-bench', 'knowledge-graph-nmbs-rt.nt', 'http://example.com/nmbs-rt');
ld_dir('/home/thomas/graphs-bench', 'knowledge-graph-delijn-rt.nt', 'http://example.com/de-lijn-rt');
-- Start uploading data to virtuoso
rdf_loader_run();
checkpoint;
checkpoint_interval(60);
scheduler_interval(10);

-- Update NMBS-rt
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
                OPTIONAL {?stoptime gtfs:comment ?ndelay} .

            }
    }  ;

-- Update De Lijn-RT (stoptime)
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

-- Update De Lijn-RT (trip)
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