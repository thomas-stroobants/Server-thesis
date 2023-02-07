--test for data retrieval trajects
SPARQL
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
-- PREFIX dct: <http://purl.org/dc/terms/>
-- PREFIX example: <http://example.com/>
SELECT * from <http://example.com/de-lijn> 
where { 
    ?s ?p ?o .
    ?s gtfs:code "204391" . 
} 
LIMIT 20;