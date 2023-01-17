--test for update graph with rt data
SPARQL
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
-- PREFIX dct: <http://purl.org/dc/terms/>
-- PREFIX example: <http://example.com/>

MODIFY <http://example.com/nmbs>
DELETE
    {
        ?s gtfs:arrivalTime ?a .
        ?s gtfs:departureTime ?dt .
    }
INSERT
    {
        ?s gtfs:arrivalTime ?na .
        ?s gtfs:departureTime ?ndt .
    }
WHERE
    {
        GRAPH <http://example.com/nmbs>
            {
                ?s gtfs:stop ?st .
            }
        GRAPH <http://example.com/nmbs-rt>
            {
                ?s gtfs:stop ?nst .
            }
    };