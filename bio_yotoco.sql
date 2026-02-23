-- ===========================================================================================================

-- PROYECTO DE REFORESTACIÓN EN PREDIOS DE RESERVA FORESTAL GUADUALITOS - MUNICIPIO DE YOTOCO VALLE DEL CAUCA

-- ===========================================================================================================

---- Calculo de área a reforestar por predio

SELECT current_schema();
SET search_path TO guadualitos, public;

CREATE VIEW area_a_reforestar AS
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

SELECT * FROM area_a_reforestar;

-------------------------------------------------------------------------------------------------------------------

---- Integracion de indicadores de remanente de ecosistema natural y area a reforestar en capa de predios

------ Creacion de campos correspondientes en la tabla de predios (catastro_bio_yotoco)

ALTER TABLE 
	catastro_bio_yotoco 
ADD COLUMN 
	remanente_eco_natural double precision,
ADD COLUMN
	area_a_reforestar double precision;

------ Integracion de indicadores

UPDATE 
	catastro_bio_yotoco  
SET
	remanente_eco_natural = a.remanente_ecosistema_natural,
	area_a_reforestar = a.area_a_reforestar
FROM
	area_a_reforestar a
WHERE
	catastro_bio_yotoco.codigo = a.cedula_catastral;

------------------------------------------------------------------------------------------------------------------
	



	