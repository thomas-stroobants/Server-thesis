--File for testing NMBS loading static data and changing with realtime data

ld_dir('/home/thomas/graphs', 'knowledge-graph-nmbs.nt', 'http://example.com/nmbs');
select * from DB.DBA.load_list;
rdf_loader_run();
checkpoint;
checkpoint_interval(60);
scheduler_interval(10);