from pyoxigraph import *

store = Store()
store.bulk_load("./graphs/knowledge-graph-nmbs.nt", "application/n-triples")

print(list(store.query('SELECT ?s WHERE { ?s ?p ?o }')))