--File for testing De Lijn loading static data and changing with realtime data

ld_dir('/home/thomas/graphs-bench', 'knowledge-graph-delijn-test.nt', 'http://example.com/de-lijn');
ld_dir('/home/thomas/graphs-bench', 'knowledge-graph-delijn-test2.nt', 'http://example.com/de-lijn');
-- select * from DB.DBA.load_list;
rdf_loader_run();
checkpoint;
checkpoint_interval(60);
scheduler_interval(10);