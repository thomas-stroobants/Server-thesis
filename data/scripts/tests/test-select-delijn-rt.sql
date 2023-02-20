SPARQL 
-- SELECT * from <http://example.com/nmbs> where { <http://example.com/nmbs/stoptimes/88____%3A046%3A%3A8896008%3A8892601%3A4%3A1614%3A20231208-8892601> ?p ?o . };
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
-- SELECT * from <http://example.com/de-lijn-rt> where { ?s gtfs:stop ?o . };
-- SELECT * from <http://example.com/de-lijn-rt> where { ?s gtfs:stop <http://example.com/de-lijn/stops/150118> . };
SELECT * from <http://example.com/de-lijn-rt> where { <http://example.com/de-lijn/stoptimes/42909920-150118> ?p ?o .};