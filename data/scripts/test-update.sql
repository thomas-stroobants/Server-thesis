--test for update graph with rt data
SPARQL
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX example: <http://example.com/>

MODIFY example:nmbs
DELETE
    {
        ?s dct:date ?d .
        ?s gtfs:arrivalTime ?a .
        ?s gtfs:departureTime ?dt .
        ?s gtfs:stop ?st .
    }
INSERT
    {
        ?s dct:date ?nd .
        ?s gtfs:arrivalTime ?na .
        ?s gtfs:departureTime ?ndt .
        ?s gtfs:stop ?nst .
    }
WHERE
    {
        GRAPH example:nmbs
            {
                ?s gtfs:stop ?st .
            }
        GRAPH example:nmbs-rt
            {
                ?s gtfs:stop ?st .
            }
    }