{{ config(materialized='table') }}

WITH  
temp_table AS (SELECT * FROM {{ source('MVC_C','MVC_C_2014') }}),
temp_table2 AS (SELECT * FROM {{ source('MVC_V','MVC_V_2014') }}),
temp_table3 AS (SELECT * FROM {{ source('MVC_P','MVC_P_2014') }}),
ind AS (SELECT ind from generate_series(1, 1000, 1) ind),
inj AS (SELECT injured, inj_am, ROW_NUMBER() OVER() AS ind FROM (SELECT injured, COUNT(*) AS inj_am FROM temp_table GROUP BY injured ORDER BY 2 DESC)inj1),
kld AS (SELECT killed, kld_am, ROW_NUMBER() OVER() AS ind FROM (SELECT killed, COUNT(*) AS kld_am FROM temp_table WHERE killed IS NOT NULL GROUP BY killed ORDER BY 2 DESC )kld1),
brg AS (SELECT borough, brg_am, ROW_NUMBER() OVER() AS ind FROM (SELECT borough, COUNT(*) AS brg_am FROM temp_table GROUP BY borough ORDER BY 2 DESC)brg1),
vhc_type AS (SELECT vhc_type AS vhc_type, vhc_type_am, ROW_NUMBER() OVER() AS ind FROM (
	SELECT vhc_type_ AS vhc_type, count(*) AS vhc_type_am FROM (
	SELECT CASE
	WHEN lower(vhc_type) LIKE 'amb%' THEN 'Ambulance'
	when lower(vhc_type) LIKE 'fire%' THEN 'Firetruck'
	when lower(vhc_type) LIKE 'box%' THEN 'Boxtruck'
	ELSE vhc_type END AS vhc_type_
	FROM temp_table2 WHERE vhc_type IS NOT NULL) vhc_t 
	GROUP BY vhc_type_ HAVING COUNT(*) > 2  ORDER BY 2 DESC)vhc_tt),
contr_f AS (SELECT contr_f, contrf_am , ROW_NUMBER() OVER() AS ind FROM(SELECT contr_f, COUNT(*) AS contrf_am FROM 
			  (SELECT contr_f_vhc_1 AS contr_f FROM temp_table UNION ALL
			  SELECT contr_f_vhc_2 AS contr_f FROM temp_table UNION ALL
			  SELECT contr_f_vhc_3 AS contr_f FROM temp_table UNION ALL
			  SELECT contr_f_vhc_4 AS contr_f FROM temp_table) amr_f WHERE contr_f IS NOT NULL AND contr_f != 'Unspecified' GROUP BY contr_f ORDER BY 2 DESC )amr_f1),			  
vhc_dmg AS (SELECT vhc_dmg, vhc_dmg_am, ROW_NUMBER() OVER() AS ind FROM (SELECT vhc_dmg, count(*) AS vhc_dmg_am FROM temp_table2 WHERE vhc_dmg IS NOT NULL GROUP BY vhc_dmg ORDER BY 2 DESC)vhc),
vhc_year AS (SELECT vhc_year, vhc_year_am, ROW_NUMBER() OVER() AS ind FROM(SELECT vhc_year, count(*) AS vhc_year_am FROM temp_table2 WHERE vhc_year IS NOT NULL AND vhc_year BETWEEN 1900 AND 2014 GROUP BY vhc_year ORDER BY 2 DESC)vhc_y),
vhc_occupants AS (SELECT vhc_occupants, vhc_oc_am, ROW_NUMBER() OVER() AS ind FROM(SELECT vhc_occupants, count(*) AS vhc_oc_am FROM temp_table2 WHERE vhc_occupants IS NOT NULL GROUP BY vhc_occupants ORDER BY 2 DESC)vhc_occ),
dr_lic_status AS (SELECT dr_lic_status, dr_lic_am, ROW_NUMBER() OVER() AS ind FROM(SELECT dr_lic_status, count(*) AS dr_lic_am  FROM temp_table2 GROUP BY dr_lic_status ORDER BY 2 DESC)dr_lic),
state_reg AS (SELECT state_reg, st_reg_am, ROW_NUMBER() OVER() AS ind FROM(SELECT state_reg, count(*) AS st_reg_am FROM temp_table2 GROUP BY state_reg ORDER BY 2 DESC)st_r),
ej AS (SELECT ejection, ej_am, ROW_NUMBER() OVER() AS ind FROM (SELECT ejection, COUNT(*) AS ej_am FROM temp_table3 WHERE pos_in_vhc = 'Driver' GROUP BY ejection ORDER BY 2 DESC)ej1),
bd_inj AS (SELECT body_inj, b_inj_am, ROW_NUMBER() OVER() AS ind FROM (SELECT body_inj, COUNT(*) AS b_inj_am FROM temp_table3 GROUP BY body_inj ORDER BY 2 DESC) bdi),
age AS (SELECT age_ AS age, sex, age_am, ROW_NUMBER() OVER() AS ind FROM (
                SELECT CASE
                WHEN age BETWEEN 0 AND 9 THEN '0-9'
                WHEN age BETWEEN 10 AND 19 THEN '10-19'
                WHEN age BETWEEN 20 AND 29 THEN '20-29'
                WHEN age BETWEEN 30 AND 39 THEN '30-39'
                WHEN age BETWEEN 40 AND 49 THEN '40-49'
                WHEN age > 50 THEN '>50' END AS age_, sex,
                COUNT(*) AS age_am FROM temp_table3 WHERE pos_in_vhc = 'Driver' GROUP BY age_, sex ORDER BY 1,3 DESC)ag)

SELECT 2014 AS "year", inj.injured, inj.inj_am, kld.killed, kld.kld_am AS killed_am, brg.borough, brg.brg_am AS borough_am, vhc_type.vhc_type, vhc_type.vhc_type_am,  contr_f.contr_f, contr_f.contrf_am AS contr_f_am,
vhc_dmg.vhc_dmg, vhc_dmg.vhc_dmg_am,  vhc_year.vhc_year, vhc_year.vhc_year_am, vhc_occupants.vhc_occupants, vhc_occupants.vhc_oc_am, 
dr_lic_status.dr_lic_status, dr_lic_status.dr_lic_am, state_reg.state_reg, state_reg.st_reg_am, ej.ejection, ej.ej_am, bd_inj.body_inj, bd_inj.b_inj_am AS body_inj_am, age.age, age.sex, age.age_am

FROM ind
FULL OUTER JOIN kld ON (ind.ind = kld.ind) 
FULL OUTER JOIN brg ON (ind.ind = brg.ind)
FULL OUTER JOIN inj ON (ind.ind = inj.ind)
FULL OUTER JOIN vhc_type ON (ind.ind = vhc_type.ind)
FULL OUTER JOIN contr_f ON (ind.ind = contr_f.ind)
FULL OUTER JOIN vhc_dmg ON (ind.ind = vhc_dmg.ind)
FULL OUTER JOIN vhc_year ON (ind.ind = vhc_year.ind)
FULL OUTER JOIN vhc_occupants ON (ind.ind = vhc_occupants.ind)
FULL OUTER JOIN dr_lic_status ON (ind.ind = dr_lic_status.ind)
FULL OUTER JOIN state_reg ON (ind.ind = state_reg.ind)
FULL OUTER JOIN bd_inj ON (ind.ind = bd_inj.ind)
FULL OUTER JOIN ej ON (ind.ind = ej.ind) 
FULL OUTER JOIN age ON (ind.ind = age.ind)

WHERE inj.injured IS NOT NULL OR vhc_type.vhc_type IS NOT NULL OR vhc_year.vhc_year  IS NOT NULL OR  contr_f.contr_f IS NOT NULL OR 
vhc_occupants.vhc_occupants  IS NOT NULL OR state_reg.state_reg  IS NOT NULL OR  age.age  IS NOT NULL

ORDER BY ind.ind

