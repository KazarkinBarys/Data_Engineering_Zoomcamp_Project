{{ config(materialized='table') }}

WITH 
T_C AS (SELECT collision_id, date_part('year', crash_date) AS "year", borough, vhc_1_code, contr_f_vhc_1 FROM "MVC_C_2012" UNION ALL 
	   SELECT collision_id, date_part('year', crash_date) AS "year", borough, vhc_1_code, contr_f_vhc_1 FROM "MVC_C_2013" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", borough, vhc_1_code, contr_f_vhc_1 FROM "MVC_C_2014" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", borough, vhc_1_code, contr_f_vhc_1 FROM "MVC_C_2015" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", borough, vhc_1_code, contr_f_vhc_1 FROM "MVC_C_2016" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", borough, vhc_1_code, contr_f_vhc_1 FROM "MVC_C_2017" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", borough, vhc_1_code, contr_f_vhc_1 FROM "MVC_C_2018" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", borough, vhc_1_code, contr_f_vhc_1 FROM "MVC_C_2019" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", borough, vhc_1_code, contr_f_vhc_1 FROM "MVC_C_2020" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", borough, vhc_1_code, contr_f_vhc_1 FROM "MVC_C_2021" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", borough, vhc_1_code, contr_f_vhc_1 FROM "MVC_C_2022" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", borough, vhc_1_code, contr_f_vhc_1 FROM "MVC_C_2023" ),
T_V AS (SELECT collision_id, date_part('year', crash_date) AS "year", vhc_type, vhc_year, dr_lic_status FROM "MVC_V_2012" UNION ALL
		SELECT collision_id, date_part('year', crash_date) AS "year", vhc_type, vhc_year, dr_lic_status FROM "MVC_V_2013" UNION ALL
		SELECT collision_id, date_part('year', crash_date) AS "year", vhc_type, vhc_year, dr_lic_status FROM "MVC_V_2014" UNION ALL
		SELECT collision_id, date_part('year', crash_date) AS "year", vhc_type, vhc_year, dr_lic_status FROM "MVC_V_2015" UNION ALL
		SELECT collision_id, date_part('year', crash_date) AS "year", vhc_type, vhc_year, dr_lic_status FROM "MVC_V_2016" UNION ALL
		SELECT collision_id, date_part('year', crash_date) AS "year", vhc_type, vhc_year, dr_lic_status FROM "MVC_V_2017" UNION ALL
		SELECT collision_id, date_part('year', crash_date) AS "year", vhc_type, vhc_year, dr_lic_status FROM "MVC_V_2018" UNION ALL
		SELECT collision_id, date_part('year', crash_date) AS "year", vhc_type, vhc_year, dr_lic_status FROM "MVC_V_2019" UNION ALL
		SELECT collision_id, date_part('year', crash_date) AS "year", vhc_type, vhc_year, dr_lic_status FROM "MVC_V_2020" UNION ALL
		SELECT collision_id, date_part('year', crash_date) AS "year", vhc_type, vhc_year, dr_lic_status FROM "MVC_V_2021" UNION ALL
		SELECT collision_id, date_part('year', crash_date) AS "year", vhc_type, vhc_year, dr_lic_status FROM "MVC_V_2022" UNION ALL
		SELECT collision_id, date_part('year', crash_date) AS "year", vhc_type, vhc_year, dr_lic_status FROM "MVC_V_2023"  ),
T_P AS (SELECT collision_id, date_part('year', crash_date) AS "year", age, sex FROM "MVC_P_2012" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", age, sex FROM "MVC_P_2013" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", age, sex FROM "MVC_P_2014" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", age, sex FROM "MVC_P_2015" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", age, sex FROM "MVC_P_2016" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", age, sex FROM "MVC_P_2017" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", age, sex FROM "MVC_P_2018" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", age, sex FROM "MVC_P_2019" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", age, sex FROM "MVC_P_2020" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", age, sex FROM "MVC_P_2021" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", age, sex FROM "MVC_P_2022" UNION ALL
	   SELECT collision_id, date_part('year', crash_date) AS "year", age, sex FROM "MVC_P_2023"),
T_ AS (SELECT "year", count(DISTINCT (collision_id)) AS total_crashes_am FROM T_C GROUP BY "year"),
V_ AS(SELECT T_C."year" AS "year", count(DISTINCT (collision_id)) AS total_v_am
FROM T_C LEFT OUTER JOIN T_V USING(collision_id) WHERE T_V.collision_id IS NOT NULL GROUP BY T_C."year"),
P_ AS (SELECT T_C."year" AS "year", count(DISTINCT (collision_id)) AS total_p_am
FROM T_C LEFT OUTER JOIN T_P USING(collision_id) WHERE T_P.collision_id IS NOT NULL GROUP BY T_C."year"),
B_ AS (SELECT "year", COUNT(*) AS no_borough_data FROM T_C WHERE borough IS NULL GROUP BY "year"),
CF_ AS (SELECT "year", COUNT(*) AS no_contr_f_data FROM T_C WHERE contr_f_vhc_1 IS NULL GROUP BY "year"),
VT_ AS (SELECT "year", COUNT(*) AS no_vhc_type_data FROM T_V  WHERE vhc_type IS NULL GROUP BY "year"),
VY_ AS (SELECT "year", COUNT(*) AS no_vhc_year_data FROM T_V  WHERE vhc_year IS NULL GROUP BY "year"),
DR_ AS (SELECT "year", COUNT(*) AS no_dr_lic_status_data FROM T_V  WHERE dr_lic_status IS NULL  GROUP BY "year"),
TV_ AS (SELECT "year", COUNT(*) AS total_vhc_am FROM T_V GROUP BY "year"),
TP_ AS (SELECT "year", COUNT(*) AS total_vhc_am FROM T_P GROUP BY "year"),
AG_ AS (SELECT "year", COUNT(*) AS no_age_data FROM T_P WHERE age IS NULL GROUP BY "year"),
SX_ AS (SELECT "year", COUNT(*) AS no_sex_data FROM T_P WHERE sex IS NULL OR sex = 'U' GROUP BY "year"),


final AS (
SELECT T_."year" AS "year", T_.total_crashes_am::INTEGER, (T_.total_crashes_am - V_.total_v_am) ::INTEGER AS no_vhc_data_am, ROUND(CAST(((T_.total_crashes_am::FLOAT - V_.total_v_am)/T_.total_crashes_am * 100) AS numeric ),2) AS "no_vhc_data_%",
TV_.total_vhc_am ::INTEGER AS total_vhc_am, TP_.total_vhc_am::INTEGER  AS total_person_am ,(T_.total_crashes_am - P_.total_p_am) ::INTEGER AS no_person_data_am, ROUND(CAST(((T_.total_crashes_am::FLOAT - P_.total_p_am)/T_.total_crashes_am * 100) AS numeric ),2) AS "no_person_data_%",
B_.no_borough_data	AS no_borough_data, ROUND(CAST((B_.no_borough_data::FLOAT /T_.total_crashes_am * 100) AS numeric ),2) AS "no_borough_data_%", CF_.no_contr_f_data	AS no_contr_f_data, ROUND(CAST((CF_.no_contr_f_data::FLOAT /T_.total_crashes_am * 100) AS numeric ),2) AS "no_contr_f_data_%",
VT_.no_vhc_type_data + T_.total_crashes_am - V_.total_v_am AS no_vhc_type_data, ROUND(CAST(((VT_.no_vhc_type_data::FLOAT + T_.total_crashes_am - V_.total_v_am) /(TV_.total_vhc_am + T_.total_crashes_am - V_.total_v_am) * 100) AS numeric ),2) AS "no_vhc_type_data_%",
VY_.no_vhc_year_data + T_.total_crashes_am - V_.total_v_am AS no_vhc_year_data, ROUND(CAST(((VY_.no_vhc_year_data::FLOAT + T_.total_crashes_am - V_.total_v_am) /(TV_.total_vhc_am + T_.total_crashes_am - V_.total_v_am) * 100) AS numeric ),2) AS "no_vhc_year_data_%",
DR_.no_dr_lic_status_data + T_.total_crashes_am - V_.total_v_am AS no_dr_lic_status_data, ROUND(CAST(((DR_.no_dr_lic_status_data::FLOAT + T_.total_crashes_am - V_.total_v_am) /(TV_.total_vhc_am + T_.total_crashes_am - V_.total_v_am) * 100) AS numeric ),2) AS "no_dr_lic_status_data_%",
AG_.no_age_data + T_.total_crashes_am - P_.total_p_am AS no_age_data, ROUND(CAST(((AG_.no_age_data::FLOAT + T_.total_crashes_am - P_.total_p_am) /(TP_.total_vhc_am + T_.total_crashes_am - P_.total_p_am) * 100) AS numeric ),2) AS "no_age_data_%",
SX_.no_sex_data + T_.total_crashes_am - P_.total_p_am AS no_sex_data, ROUND(CAST(((SX_.no_sex_data::FLOAT + T_.total_crashes_am - P_.total_p_am) /(TP_.total_vhc_am + T_.total_crashes_am - P_.total_p_am) * 100) AS numeric ),2) AS "no_sex_data_%"

FROM V_ FULL OUTER JOIN T_ USING ("year")
	FULL OUTER JOIN P_ USING ("year")
	FULL OUTER JOIN B_ USING ("year")
	FULL OUTER JOIN CF_ USING ("year")
	FULL OUTER JOIN VT_ USING ("year")
	FULL OUTER JOIN VY_ USING ("year")
	FULL OUTER JOIN DR_ USING ("year")
	FULL OUTER JOIN TV_ USING ("year")
	FULL OUTER JOIN AG_ USING ("year")
	FULL OUTER JOIN TP_ USING ("year")
	FULL OUTER JOIN SX_ USING ("year") 
)
SELECT "year"::INTEGER, total_crashes_am::INTEGER, COALESCE(total_vhc_am ,0)::INTEGER AS total_vhc_am, COALESCE(total_person_am ,0)::INTEGER AS total_person_am, COALESCE(no_vhc_data_am,total_crashes_am)::INTEGER AS no_vhc_data_am , COALESCE("no_vhc_data_%",100.00) AS "no_vhc_data_%" , 
COALESCE(no_person_data_am ,total_crashes_am)::INTEGER AS no_person_data_am, COALESCE("no_person_data_%",100.00) AS "no_person_data_%",
no_borough_data::INTEGER, "no_borough_data_%", COALESCE(no_contr_f_data,0)::INTEGER AS no_contr_f_data, COALESCE("no_contr_f_data_%",0.00) AS  "no_contr_f_data_%" , 
COALESCE(no_vhc_type_data,total_crashes_am)::INTEGER AS no_vhc_type_data  , COALESCE("no_vhc_type_data_%",100.00) AS "no_vhc_type_data_%"  ,
COALESCE(no_vhc_year_data,total_crashes_am)::INTEGER AS no_vhc_year_data   , COALESCE("no_vhc_year_data_%",100.00) AS "no_vhc_year_data_%"   , 
COALESCE(no_dr_lic_status_data,total_crashes_am)::INTEGER AS no_dr_lic_status_data  , COALESCE("no_dr_lic_status_data_%",100.00) AS "no_dr_lic_status_data_%"  , 
COALESCE(no_age_data,total_crashes_am)::INTEGER AS no_age_data, COALESCE("no_age_data_%",100.00) AS "no_age_data_%", COALESCE(no_sex_data,total_crashes_am)::INTEGER AS no_sex_data, COALESCE("no_sex_data_%",100.00) AS "no_sex_data_%"

FROM final ORDER BY "year"
