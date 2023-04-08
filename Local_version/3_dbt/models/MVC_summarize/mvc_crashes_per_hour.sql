{{ config(materialized='table') }}

WITH temp AS (
(SELECT date_part('year',crash_date)::INTEGER AS "year",date_part('month',crash_date)::INTEGER AS "month", (interval '01:00' * date_part('hour',crash_time))::time as "from time", (interval '01:00' * date_part('hour',crash_time)+'00:59:59')::time as "to time", COUNT(*)::INTEGER AS "all_amount",  SUM(injured)::INTEGER AS "injured_am", SUM(killed)::INTEGER AS "killed_am" 
FROM "MVC_C_2012" GROUP BY date_part('month',crash_date),date_part('year',crash_date), date_part('hour',crash_time) ORDER BY 1,2,3) 
UNION ALL
(SELECT date_part('year',crash_date)::INTEGER AS "year",date_part('month',crash_date)::INTEGER AS "month", (interval '01:00' * date_part('hour',crash_time))::time as "from time", (interval '01:00' * date_part('hour',crash_time)+'00:59:59')::time as "to time", COUNT(*)::INTEGER AS "all_amount",  SUM(injured)::INTEGER AS "injured_am", SUM(killed)::INTEGER AS "killed_am" 
FROM "MVC_C_2013" GROUP BY date_part('month',crash_date),date_part('year',crash_date), date_part('hour',crash_time) ORDER BY 1,2,3) 
UNION ALL
(SELECT date_part('year',crash_date)::INTEGER AS "year",date_part('month',crash_date)::INTEGER AS "month", (interval '01:00' * date_part('hour',crash_time))::time as "from time", (interval '01:00' * date_part('hour',crash_time)+'00:59:59')::time as "to time", COUNT(*)::INTEGER AS "all_amount",  SUM(injured)::INTEGER AS "injured_am", SUM(killed)::INTEGER AS "killed_am" 
FROM "MVC_C_2014" GROUP BY date_part('month',crash_date),date_part('year',crash_date), date_part('hour',crash_time) ORDER BY 1,2,3) 
UNION ALL
(SELECT date_part('year',crash_date)::INTEGER AS "year",date_part('month',crash_date)::INTEGER AS "month", (interval '01:00' * date_part('hour',crash_time))::time as "from time", (interval '01:00' * date_part('hour',crash_time)+'00:59:59')::time as "to time", COUNT(*)::INTEGER AS "all_amount",  SUM(injured)::INTEGER AS "injured_am", SUM(killed)::INTEGER AS "killed_am" 
FROM "MVC_C_2015" GROUP BY date_part('month',crash_date),date_part('year',crash_date), date_part('hour',crash_time) ORDER BY 1,2,3) 
UNION ALL
(SELECT date_part('year',crash_date)::INTEGER AS "year",date_part('month',crash_date)::INTEGER AS "month", (interval '01:00' * date_part('hour',crash_time))::time as "from time", (interval '01:00' * date_part('hour',crash_time)+'00:59:59')::time as "to time", COUNT(*)::INTEGER AS "all_amount",  SUM(injured)::INTEGER AS "injured_am", SUM(killed)::INTEGER AS "killed_am" 
FROM "MVC_C_2016" GROUP BY date_part('month',crash_date),date_part('year',crash_date), date_part('hour',crash_time) ORDER BY 1,2,3) 
UNION ALL
(SELECT date_part('year',crash_date)::INTEGER AS "year",date_part('month',crash_date)::INTEGER AS "month", (interval '01:00' * date_part('hour',crash_time))::time as "from time", (interval '01:00' * date_part('hour',crash_time)+'00:59:59')::time as "to time", COUNT(*)::INTEGER AS "all_amount",  SUM(injured)::INTEGER AS "injured_am", SUM(killed)::INTEGER AS "killed_am" 
FROM "MVC_C_2017" GROUP BY date_part('month',crash_date),date_part('year',crash_date), date_part('hour',crash_time) ORDER BY 1,2,3) 
UNION ALL
(SELECT date_part('year',crash_date)::INTEGER AS "year",date_part('month',crash_date)::INTEGER AS "month", (interval '01:00' * date_part('hour',crash_time))::time as "from time", (interval '01:00' * date_part('hour',crash_time)+'00:59:59')::time as "to time", COUNT(*)::INTEGER AS "all_amount",  SUM(injured)::INTEGER AS "injured_am", SUM(killed)::INTEGER AS "killed_am" 
FROM "MVC_C_2018" GROUP BY date_part('month',crash_date),date_part('year',crash_date), date_part('hour',crash_time) ORDER BY 1,2,3) 
UNION ALL
(SELECT date_part('year',crash_date)::INTEGER AS "year",date_part('month',crash_date)::INTEGER AS "month", (interval '01:00' * date_part('hour',crash_time))::time as "from time", (interval '01:00' * date_part('hour',crash_time)+'00:59:59')::time as "to time", COUNT(*)::INTEGER AS "all_amount",  SUM(injured)::INTEGER AS "injured_am", SUM(killed)::INTEGER AS "killed_am" 
FROM "MVC_C_2019" GROUP BY date_part('month',crash_date),date_part('year',crash_date), date_part('hour',crash_time) ORDER BY 1,2,3) 
UNION ALL
(SELECT date_part('year',crash_date)::INTEGER AS "year",date_part('month',crash_date)::INTEGER AS "month", (interval '01:00' * date_part('hour',crash_time))::time as "from time", (interval '01:00' * date_part('hour',crash_time)+'00:59:59')::time as "to time", COUNT(*)::INTEGER AS "all_amount",  SUM(injured)::INTEGER AS "injured_am", SUM(killed)::INTEGER AS "killed_am" 
FROM "MVC_C_2020" GROUP BY date_part('month',crash_date),date_part('year',crash_date), date_part('hour',crash_time) ORDER BY 1,2,3) 
UNION ALL
(SELECT date_part('year',crash_date)::INTEGER AS "year",date_part('month',crash_date)::INTEGER AS "month", (interval '01:00' * date_part('hour',crash_time))::time as "from time", (interval '01:00' * date_part('hour',crash_time)+'00:59:59')::time as "to time", COUNT(*)::INTEGER AS "all_amount",  SUM(injured)::INTEGER AS "injured_am", SUM(killed)::INTEGER AS "killed_am" 
FROM "MVC_C_2021" GROUP BY date_part('month',crash_date),date_part('year',crash_date), date_part('hour',crash_time) ORDER BY 1,2,3) 
UNION ALL
(SELECT date_part('year',crash_date)::INTEGER AS "year",date_part('month',crash_date)::INTEGER AS "month", (interval '01:00' * date_part('hour',crash_time))::time as "from time", (interval '01:00' * date_part('hour',crash_time)+'00:59:59')::time as "to time", COUNT(*)::INTEGER AS "all_amount",  SUM(injured)::INTEGER AS "injured_am", SUM(killed)::INTEGER AS "killed_am" 
FROM "MVC_C_2022" GROUP BY date_part('month',crash_date),date_part('year',crash_date), date_part('hour',crash_time) ORDER BY 1,2,3) 
UNION ALL
(SELECT date_part('year',crash_date)::INTEGER AS "year",date_part('month',crash_date)::INTEGER AS "month", (interval '01:00' * date_part('hour',crash_time))::time as "from time", (interval '01:00' * date_part('hour',crash_time)+'00:59:59')::time as "to time", COUNT(*)::INTEGER AS "all_amount",  SUM(injured)::INTEGER AS "injured_am", SUM(killed)::INTEGER AS "killed_am" 
FROM "MVC_C_2023" GROUP BY date_part('month',crash_date),date_part('year',crash_date), date_part('hour',crash_time) ORDER BY 1,2,3)) 

SELECT "year", "month", "from time", "to time", 
CONCAT(TO_CHAR((date_part('hour', "from time")),'fm09'),':',TO_CHAR((date_part('minute', "from time")),'fm09'),
'-',TO_CHAR((date_part('hour', "to time")),'fm09'),':',TO_CHAR((date_part('minute', "to time")),'fm09')) AS time_interval,
"all_amount", "injured_am", "killed_am" 
FROM temp
ORDER BY "year", "month", "from time"



