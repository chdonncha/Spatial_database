SELECT * FROM pgr_dijkstra('SELECT gid AS id, source, target, length AS cost
FROM route',1, 2);

SELECT * FROM route
JOIN
(SELECT * FROM pgr_dijkstra('SELECT gid AS id, source, target, length AS cost
FROM route',array[1,2], array[5,6])) AS shortest_path
ON
route.gid =
shortest_path.edge;


CREATE INDEX source_id ON route(source);	
CREATE INDEX target_id ON route(target);	

CREATE INDEX geom_idx ON route USING GIST(the_geom	
GIST_GEOMETRY_OPS);
