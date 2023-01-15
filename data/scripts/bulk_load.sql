--bulk loading for virtuoso database
--recommended to use multiple loaders for for multi-core machine
-- pattern to use in sh script: isql 1111 dba dba exec="rdf_loader_run();" &
--                              isql 1111 dba dba exec="rdf_loader_run();" &
--                              wait
--                              isql 1111 dba dba exec="checkpoint;"
-- run with command sh /opt/openlink/virtuoso/bin/bulk_load.sh
ld_dir()

--delta-aware bulk loading of datasets into virtuoso
--bulk loarder is told to use "graph delta" load process with special option with_delete applied in the ld_dir() command
-- IMPORTANT, not available in VOS (Virtuoso Open Source)