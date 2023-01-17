-- clearing bluk load list, otherwise the next time you try to use the bulk loader with 
-- a newer file with the same name it will think it has already done that task
DELETE FROM DB.DBA.load_list;