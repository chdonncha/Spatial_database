CREATE TABLE route (gid serial PRIMARY KEY, source integer, target integer,length double precision);
SELECT AddGeometryColumn('route','the_geom','-1', 'MULTILINESTRING',2);
INSERT INTO route (the_geom) select ST_GeomFromText('MULTILINESTRING((10 0,10 5),(10 5,10 15),(10 15,10 20),(10 20, 10 30),(10 30, 10 35))',-1);
INSERT INTO route (the_geom) select ST_GeomFromText('MULTILINESTRING((10 20, 20 20))', -1);
INSERT INTO route (the_geom) select ST_GeomFromText('MULTILINESTRING((10 15, 0 15))', -1);
SELECT pgr_createTopology('route', 0.001,'the_geom', 'gid');
UPDATE route SET length = ST_Length(the_geom);
