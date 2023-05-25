ld_dir('/home/thomas/graphs', 'knowledge-graph-nmbs.nt', 'http://example.com/nmbs');
ld_dir('/home/thomas/graphs', 'knowledge-graph-irail.nt', 'http://example.com/nmbs');
ld_dir('/home/thomas/graphs', 'knowledge-graph-delijn.nt', 'http://example.com/de-lijn');
ld_dir('/home/thomas/graphs', 'knowledge-graph-delijn-2.nt', 'http://example.com/de-lijn');

rdf_loader_run();
checkpoint;
checkpoint_interval(60);
scheduler_interval(10);