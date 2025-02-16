# Question 1
## 1

``` sql

SELECT name FROM buildings_geodir WHERE st_dwithin (
		buildings_geodir.the_geom,
		(SELECT the_geom FROM buildings_geodir WHERE name = 'DIT Kevin Street'),
		500
);

```


## 2

``` sql

SELECT	d1.saps_label, d1.the_geom FROM dubeds d, dubeds d1
WHERE d.saps_label = '144 Royal Exchange A'
and st_touches(d.the_geom, d1.the_geom) = 'TRUE'
and st_Xmin(d1.the_geom) > st_Xmin(d.the_geom)

```

## 3

``` sql

-- FIXME
SELECT count(*) FROM stops WHERE st_dwithin (
	(

	)
)

```

## 4

``` sql

SELECT count(*) FROM dubroads2 WHERE st_crosses (
	(
	SELECT the_geom
	FROM dubeds
	WHERE saps_label LIKE '%Royal Exchange A'
	),
dubroads2.the_geom
);

-- query result: 44

```

``` sql

SELECT count(*) FROM dublin_highway1 WHERE st_crosses (
	(
	SELECT the_geom
	FROM dubeds
	WHERE saps_label LIKE '%Royal Exchange A'
	),
dublin_highway1.the_geom
);

-- query: 38

```

## 5

``` sql

SELECT * FROM dubroads2 WHERE st_contains (
	(
	SELECT the_geom
	FROM dubeds
	WHERE saps_label LIKE '%Royal Exchange B'
	),
dubroads2.the_geom
);

```

## 6

``` sql

SELECT * FROM dublin_historical WHERE st_dwithin (
	dublin_historical.the_geom, (
			(
	SELECT dr.the_geom FROM dubroads2 dr
		JOIN dublin_highway1 hw ON ST_Equals (
			dr.the_geom,
			hw.the_geom
		)
	WHERE hw.name = 'Templeroan Park'
	LIMIT 1
	)
),
	1000
);

```

## 7

``` sql

SELECT * FROM dubeds
WHERE pop is not null
order by dubeds.pop DESC limit 1;

```

# Question 2
## 1

``` sql

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

```

## 2

## 3

``` sql

ALTER TABLE dubroads2 ADD column source integer;
ALTER TABLE dubroads2 ADD column target integer;

SELECT pgr_createTopology('dubroads2', 0.001, 'the_geom', 'gid')

```

``` sql

SELECT * FROM dubroads2
	JOIN (
	SELECT * FROM pgr_dijkstra('SELECT gid AS id,
	source,
	target,
	ST_Length(the_geom) AS cost
	FROM dubroads2'
		,(
		SELECT dr.gid FROM dubroads2 dr
			JOIN dublin_highway1 hw ON ST_Equals (
				dr.the_geom,
				hw.the_geom
			)
		WHERE hw.name = 'Kevin Street Lower'
		),
		(
		SELECT dr.gid FROM dubroads2 dr
			JOIN dublin_highway1 hw ON ST_Equals (
				dr.the_geom,
				hw.the_geom
			)
		WHERE hw.name = 'Templeroan Park'
		LIMIT 1
		),
	false)) AS shortest_path
ON
dubroads2.gid =
shortest_path.edge;		

```

## 4

``` sql

SELECT * FROM route
JOIN
(SELECT * FROM pgr_dijkstra('SELECT gid AS id, source, target, length AS cost
FROM route',6, 4, false)) AS shortest_path
ON
route.gid =
shortest_path.edge;

```

# Question 3

## 1

``` sql

SELECT topology.GetNodeByPoint('toposchema1', point.geom, 1) FROM
	topology.ST_GetFaceGeometry('toposchema1', 1) AS face_geom,
	ST_dumppoints(
		face_geom.face_geom
	) AS point
	WHERE ST_Touches(
	topology.ST_GetFaceGeometry('toposchema1', 2),
	point.geom
);

```

## 2

``` sql

SELECT topo1.topogeom from topo1, topology.ST_GetFaceEdges('toposchema1', topo1.id) as top (seq, edge)
WHERE top.edge = 3;

```

# Question 4

## setting up

``` r

library(spdep)
library(maptools)
library(RColorBrewer)
library(classInt)

setwd("~/College/SpatialDB/assignment/sql_files/cso_eds_data")

csoeds <- readShapePoly("cso_eds_data.shp")

```

## 1 - choropleth map of white irish population

``` r

spplot(csoeds, "T2_2WI", main='Irish White Population')

```

## 2 - load pie chart

``` r

library(plotrix)
plot(csoeds)

mypercent <- paste(round(100*(csoeds$T2_2WI/csoeds$T2_3T),1),"%")
text(coordinates(csoeds)+10, labels=mypercent, cex=0.5)

for(i in 1:162) {
floating.pie(coordinates(csoeds)[i],coordinates(csoeds)[i,2],c(csoeds$
T2_2WI[i],csoeds$T2_3T[i]),radius=200,  
col=c("#ff0000","#80ff00","#00ffff","#44bbff","#8000ff"))
text(coordinates(csoeds)+10, labels=mypercent, cex=0.5)}

```

## 3

### standard deviation

``` r

sd(csoeds$T2_2WI, na.rm = FALSE)

```

-- mean

mean(csoeds$T2_2WI, na.rm = FALSE)

-- also mean

summary(csoeds$T2_2WI)


-- mode

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(T2_2WI, ux)))]
}

Mode(csoeds$T2_2WI)

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
