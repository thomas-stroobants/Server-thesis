SPARQL
PREFIX gtfs: <http://vocab.gtfs.org/terms#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>

SELECT ?subject ?time
WHERE {
  ?subject gtfs:departureTime ?time .
  FILTER (?time >= "2023-01-31T08:00:00"^^xsd:dateTime && ?time <= "2023-01-31T10:00:00"^^xsd:dateTime)
}
;