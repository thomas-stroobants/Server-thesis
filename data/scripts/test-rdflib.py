from rdflib import Graph

g = Graph()
g.parse("./graphs/knowledge-graph-nmbs.nt")

print(len(g))