--file to delete old GTFS RT data from NMBS and De Lijn
log_enable(3,1);
SPARQL CLEAR GRAPH <http://example.com/de-lijn-rt>;
SPARQL CLEAR GRAPH <http://example.com/nmbs-rt>;