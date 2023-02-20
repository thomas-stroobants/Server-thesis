--test for update graph with rt data
SPARQL
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
-- PREFIX dct: <http://purl.org/dc/terms/>
-- PREFIX example: <http://example.com/>

MODIFY <http://example.com/de-lijn>
-- DELETE
--     {
--         ?s gtfs:departureTime ?dt .
--     }
INSERT
    {
        ?s gtfs:departureTime ?ndt .
    }
WHERE
    {
        GRAPH <http://example.com/de-lijn>
            {
                ?s gtfs:stop ?st .
                ?s gtfs:departureTime ?dt .
            }
        GRAPH <http://example.com/de-lijn-rt>
            {
                ?s gtfs:stop ?nst .
                ?s gtfs:departureTime ?ndt .
            }
    };