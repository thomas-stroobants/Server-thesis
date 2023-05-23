DELETE FROM DB.DBA.load_list
WHERE ll_state = 2;

log_enable(3,1);
SPARQL CLEAR GRAPH <http://example.com/nmbs>;
SPARQL CLEAR GRAPH <http://example.com/nmbs-rt>;
SPARQL CLEAR GRAPH <http://example.com/de-lijn>;
SPARQL CLEAR GRAPH <http://example.com/de-lijn-rt>;