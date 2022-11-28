import morph_kgc
config =    """
                [Datasource1]
                mappings: ./gtfs-nmbs-csv.rml.ttl

                [CONFIGURATION]
                logging_level: DEBUG
                logging_file: morph-log.log
            """

# Create a Graph
g = morph_kgc.materialize_oxigraph(config)


# Loop through each triple in the graph (subj, pred, obj)
# for subj, pred, obj in g:
#     # Check if there is at least one triple in the Graph
#     if (subj, pred, obj) not in g:
#        raise Exception("It better be!")

# Print the number of "triples" in the Graph
print(f"Graph g has {len(g)} statements.")
# Prints: Graph g has 86 statements.

# Print out the entire Graph in the RDF Turtle format
# print(g.serialize(format="turtle"))

# print(f"Is graph connected? -> {g.connected()}")