{% macro generate_mvc_sum_year(yr) %}

    {%- set src_tbl_C = 'MVC_C_' ~ yr -%}
    {%- set src_tbl_V = 'MVC_V_' ~ yr -%}
    {%- set src_tbl_P = 'MVC_P_' ~ yr -%}
WITH  
temp_table  AS (SELECT * FROM {{ source('MVC_C',src_tbl_C) }}  ),
temp_table2 AS (SELECT * FROM {{ source('MVC_V',src_tbl_V) }}  ),
temp_table3 AS (SELECT * FROM {{ source('MVC_P',src_tbl_P) }}  ),
inj AS (SELECT injured, COUNT(*) AS inj_am, ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ind FROM temp_table GROUP BY injured ),
kld AS (SELECT killed, COUNT(*) AS kld_am, ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ind FROM temp_table WHERE killed IS NOT NULL GROUP BY killed ),
brg AS (SELECT borough, COUNT(*) AS brg_am, ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ind  FROM temp_table GROUP BY borough ),
contr_f AS (SELECT contr_f, COUNT(*) AS contrf_am, ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ind FROM 
			  (SELECT contr_f_vhc_1 AS contr_f FROM temp_table UNION ALL
			  SELECT contr_f_vhc_2 AS contr_f FROM temp_table UNION ALL
			  SELECT contr_f_vhc_3 AS contr_f FROM temp_table UNION ALL
			  SELECT contr_f_vhc_4 AS contr_f FROM temp_table) amr_f WHERE contr_f IS NOT NULL AND contr_f != 'Unspecified' GROUP BY contr_f),
vhc_type AS (SELECT vhc_type_ AS vhc_type, count(*) AS vhc_type_am, ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ind FROM (
	SELECT CASE
	WHEN lower(vhc_type) LIKE 'amb%' THEN 'Ambulance'
	when lower(vhc_type) LIKE 'fire%' THEN 'Firetruck'
	when lower(vhc_type) LIKE 'box%' THEN 'Boxtruck'
	ELSE vhc_type END AS vhc_type_
	FROM temp_table2 WHERE vhc_type IS NOT NULL) vhc_t 
	GROUP BY vhc_type_ HAVING COUNT(*) > 2 ),
vhc_dmg AS (SELECT vhc_dmg, count(*) AS vhc_dmg_am , ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ind FROM temp_table2 WHERE vhc_dmg IS NOT NULL GROUP BY vhc_dmg ORDER BY 2 DESC),
vhc_year AS (SELECT vhc_year, count(*) AS vhc_year_am, ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ind FROM temp_table2 WHERE vhc_year IS NOT NULL AND vhc_year BETWEEN 1900 AND 2015 GROUP BY vhc_year),
vhc_occupants AS (SELECT vhc_occupants, count(*) AS vhc_oc_am, ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ind FROM temp_table2 WHERE vhc_occupants IS NOT NULL GROUP BY vhc_occupants) ,
dr_lic_status AS (SELECT dr_lic_status, count(*) AS dr_lic_am, ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ind FROM temp_table2 GROUP BY dr_lic_status),
state_reg AS (SELECT state_reg, count(*) AS st_reg_am, ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ind FROM temp_table2 GROUP BY state_reg),
ej AS (SELECT ejection, COUNT(*) AS ej_am, ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ind FROM temp_table3 WHERE pos_in_vhc = 'Driver' GROUP BY ejection),
bd_inj AS (SELECT body_inj, COUNT(*) AS b_inj_am, ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ind FROM temp_table3 GROUP BY body_inj),
age AS (SELECT CASE
        WHEN age BETWEEN 0 AND 9 THEN '0-9'
        WHEN age BETWEEN 10 AND 19 THEN '10-19'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age > 50 THEN '>50' END AS age_, sex,
    COUNT(*) AS age_am, ROW_NUMBER() OVER(ORDER BY COUNT(*) DESC) AS ind FROM temp_table3 WHERE pos_in_vhc = 'Driver' GROUP BY age_, sex )


SELECT {{yr}} AS "year", inj.injured, inj.inj_am, kld.killed, kld.kld_am AS killed_am, brg.borough, brg.brg_am AS borough_am, vhc_type.vhc_type, vhc_type.vhc_type_am,  contr_f.contr_f, contr_f.contrf_am AS contr_f_am,
vhc_dmg.vhc_dmg, vhc_dmg.vhc_dmg_am,  vhc_year.vhc_year, vhc_year.vhc_year_am, vhc_occupants.vhc_occupants, vhc_occupants.vhc_oc_am, 
dr_lic_status.dr_lic_status, dr_lic_status.dr_lic_am, state_reg.state_reg, state_reg.st_reg_am, ej.ejection, ej.ej_am, bd_inj.body_inj, bd_inj.b_inj_am AS body_inj_am, age.age_ AS age, age.sex, age.age_am, contr_f.ind

FROM contr_f
FULL OUTER JOIN inj ON (inj.ind = contr_f.ind) 
FULL OUTER JOIN kld ON (kld.ind = contr_f.ind) 
FULL OUTER JOIN brg ON (brg.ind = contr_f.ind)
FULL OUTER JOIN vhc_type ON (vhc_type.ind = contr_f.ind)
FULL OUTER JOIN vhc_dmg ON (vhc_dmg.ind = contr_f.ind)
FULL OUTER JOIN vhc_year ON (vhc_year.ind = contr_f.ind)
FULL OUTER JOIN vhc_occupants ON (vhc_occupants.ind = contr_f.ind)
FULL OUTER JOIN dr_lic_status ON (dr_lic_status.ind = contr_f.ind)
FULL OUTER JOIN state_reg ON (state_reg.ind = contr_f.ind)
FULL OUTER JOIN bd_inj ON (bd_inj.ind = contr_f.ind)
FULL OUTER JOIN ej ON (ej.ind = contr_f.ind) 
FULL OUTER JOIN age ON (age.ind = contr_f.ind)

WHERE inj.injured IS NOT NULL OR vhc_type.vhc_type IS NOT NULL OR vhc_year.vhc_year  IS NOT NULL OR contr_f.contr_f IS NOT NULL OR 
vhc_occupants.vhc_occupants  IS NOT NULL OR state_reg.state_reg  IS NOT NULL OR  age.age_  IS NOT NULL

{% endmacro %}