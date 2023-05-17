--File for testing NMBS loading realtime data

ld_dir('/home/thomas/graphs', 'knowledge-graph-nmbs-rt-test.nt', 'http://example.com/nmbs-rt');

rdf_loader_run();
checkpoint;
checkpoint_interval(60);
scheduler_interval(10);