SELECT * FROM pgr_dijkstra('SELECT gid AS id, source, target, length AS cost
FROM route',1, 2);
