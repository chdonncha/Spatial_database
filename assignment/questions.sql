-- Question 1
-- 1

SELECT name FROM buildings_geodir WHERE st_dwithin (
		buildings_geodir.the_geom, 
		(SELECT the_geom FROM buildings_geodir WHERE name = 'DIT Kevin Street'),
		500
);


-- 2



-- 3
-- FIXME
SELECT count(*) FROM stops WHERE st_dwithin (
	(
	
	)
)


-- 4

SELECT count(*) FROM dubroads2 WHERE st_crosses (
	(
	SELECT the_geom
	FROM dubeds 
	WHERE saps_label LIKE '%Royal Exchange A'
	),
dubroads2.the_geom
);

-- query: 44

SELECT count(*) FROM dublin_highway1 WHERE st_crosses (
	(
	SELECT the_geom
	FROM dubeds 
	WHERE saps_label LIKE '%Royal Exchange A'
	),
dublin_highway1.the_geom
);

-- query: 38


-- 5

SELECT * FROM dubroads2 WHERE st_contains (
	(
	SELECT the_geom
	FROM dubeds 
	WHERE saps_label LIKE '%Royal Exchange B'
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


-- 4

SELECT * FROM route
JOIN
(SELECT * FROM pgr_dijkstra('SELECT gid AS id, source, target, length AS cost
FROM route',6, 4, false)) AS shortest_path
ON
route.gid =
shortest_path.edge;


-- Question 3

-- 1

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

-- 2 (change up)

SELECT topo1.topogeom from topo1, topology.ST_GetFaceEdges('toposchema1', topo1.id) as te (seq, edge)
WHERE te.edge = 3;


-- Question 4

-- 1

-- choropleth map of white irish population

spplot(csoeds, "T2_2WI", main='Irish White Population')


-- 2

load pie chart
--------------

library(plotrix)	
plot(csoeds)

#floating.pie(coordinates(csoeds)[1],coordinates(csoeds)[1,2],c(csoeds$T2_2WI[1], 
#csoeds$T2_3T[1]),radius=10,  col=c("#ff0000","#80ff00","#00ffff","#44bbff","#8000ff"))

mypercent <- paste(round(100*(csoeds$T2_2WI/csoeds$T2_3T),1),"%") 
text(coordinates(csoeds)+10, labels=mypercent, cex=0.5) 

#for(i in 1:162){cat("iteration number", "->",i,"\n")} 	

for(i in 1:162) { 
floating.pie(coordinates(csoeds)[i],coordinates(csoeds)[i,2],c(csoeds$ 
T2_2WI[i],csoeds$T2_3T[i]),radius=200,  
col=c("#ff0000","#80ff00","#00ffff","#44bbff","#8000ff")) 
text(coordinates(csoeds)+10, labels=mypercent, cex=0.5)}


-- 3
-- FIXME


-- 4


library(sp)	
library(maptools)	
gpclibPermit()	
library(spdep)	
library(spgwr)	
library(RColorBrewer)

cso.nb <- poly2nb(csoeds,queen = TRUE) 
cso.I <- moran.test(csoeds$T2_2WI, nb2listw(cso.nb)) 
moran.plot(csoeds$T2_2WI,labels=csoeds$GEOGDESC,listw=nb2listw(cso.nb)) 
title(paste("Map 1: Moran's I =",as.character(round(cso.I$estimate[1],2)))) 


