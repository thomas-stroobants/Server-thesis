--file to delete old GTFS data from NMBS
log_enable(3,1);
SPARQL CLEAR GRAPH <http://example.com/de-lijn>;
SPARQL CLEAR GRAPH <http://example.com/de-lijn-rt>;