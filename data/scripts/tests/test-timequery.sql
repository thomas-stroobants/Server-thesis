SPARQL
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?subject ?predicate ?object
WHERE {
  ?subject ?predicate ?object .
  ?subject gtfs:departureTime ?time .
  FILTER (?time >= "08:00:00"^^xsd:time && ?time <= "10:00:00"^^xsd:time)
}
;