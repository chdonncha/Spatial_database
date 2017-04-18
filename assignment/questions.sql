-- Question 1
-- 1

SELECT name FROM buildings_geodir WHERE st_dwithin (
		buildings_geodir.the_geom, 
		(SELECT the_geom FROM buildings_geodir WHERE name = 'DIT Kevin Street'),
		500
	)
	AND st_contains (
		(SELECT ST_Transform (wkb_geometry, 29900) FROM electoraldivisions 
		WHERE geogdesc =  'Royal Exchange A'),
		buildings_geodir.the_geom
	);


-- 2



-- 3

SELECT count(*) FROM stops WHERE st_dwithin (
	(
	
	)
)


-- 4

SELECT count(*) FROM dubroads2 WHERE st_crosses (
	(
	SELECT ST_Transform (wkb_geometry, 29900) 
	FROM electoraldivisions 
	WHERE geogdesc =  'Royal Exchange A'
	),
dubroads2.the_geom
);

-- query: 44

SELECT count(*) FROM dublin_highway1 WHERE st_crosses (
	(
	SELECT ST_Transform (wkb_geometry, 29900) 
	FROM electoraldivisions 
	WHERE geogdesc =  'Royal Exchange A'
	),
dublin_highway1.the_geom
);

-- query: 38


-- 5

SELECT * FROM dubroads2 WHERE st_contains (
	(
	SELECT ST_Transform (wkb_geometry, 29900) 
	FROM electoraldivisions 
	WHERE geogdesc =  'Royal Exchange B'
	),
dubroads2.the_geom
);


-- 6 NOT COMPLETE

SELECT * FROM dublin_historical WHERE st_dwithin (
		dublin_historical.the_geom, 
		(SELECT the_geom FROM buildings_geodir WHERE name = 'DIT Kevin Street'),
		1000
	);


--7

SELECT * FROM dubeds 
WHERE pop is not null 
order by dubeds.pop DESC limit 1;



-- Question 2
-- 1

/* 

Dubroads2 is purely a graphical table, holding no other information that'd 
be useful to any user of it other than just to see all the roads that exist 
in dublin i.e. it would not be useful for delivery drivers to use as it does
not distinguish between what roads a driver is allowed to use such as footpaths.

The dublin_highways1 table tells us information what is useful in a practical
sense which dubroads2 does not. This comes in the form of telling us what type
the road is as an example not all roads are designed for cars, some are for trucks,
pedestrians etc. For a routing application this would be useful because we can
distinguish which roads a driver is allowed to use.

*/

-- Question 3

(
	SELECT t.seq, t.edge, geom 
	FROM topology.ST_GetFaceEdges('toposchema1', 1) 
	AS t (seq, edge)
	INNER JOIN toposchema1.edge 
	AS e 
	ON abs(t.edge) = e.edge_id
) UNION
(
	SELECT t.seq, t.edge, geom 
	FROM topology.ST_GetFaceEdges('toposchema1', 2) 
	AS t (seq, edge)
	INNER JOIN toposchema1.edge 
	AS e 
	ON abs(t.edge) = e.edge_id
) 

