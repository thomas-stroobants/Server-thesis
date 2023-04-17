--File for testing BlueBike loading with realtime data

ld_dir('/home/thomas/data/BlueBike', 'bluebike.ttl', 'http://example.com/blue-bike');
-- select * from DB.DBA.load_list;
rdf_loader_run();
checkpoint;
checkpoint_interval(60);
scheduler_interval(10);