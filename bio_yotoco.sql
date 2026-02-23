-- Calculo de área a reforestar por predio

SELECT current_schema();
SET search_path TO guadualitos, public;

SELECT
	a.codigo AS cedula_catastral, 
	ROUND(a.area_ha::numeric,2) AS area_has,
	ROUND((SUM(ST_Area(ST_Intersection(a.geom, b.geom)))/10000.0)::numeric,2) AS remanente_ecosistema_natural,
	ROUND(a.area_ha - (SUM(ST_Area(ST_Intersection(a.geom, b.geom)))/10000.0)::numeric,2) AS area_a_reforestar
FROM
	catastro_bio_yotoco a
JOIN
	fragmentacion_guadualitos b ON ST_Intersects(a.geom, b.geom)
GROUP BY
	cedula_catastral,
	a.area_ha
ORDER BY
	area_a_reforestar DESC; 


	