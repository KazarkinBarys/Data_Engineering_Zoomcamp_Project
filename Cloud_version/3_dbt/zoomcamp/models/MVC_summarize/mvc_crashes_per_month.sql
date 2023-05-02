{{ config(materialized='table') }}

WITH tbl AS(
SELECT      "year"||'-'|| CASE 
            WHEN "month" < 10 THEN '0'||"month"::varchar 
            ELSE "month"::varchar
            END  AS "month", 
SUM(all_amount)AS all_amount,
SUM(injured_am) AS injured_am, 
SUM(killed_am) AS killed_am
FROM "MVC_summarize".mvc_crashes_per_hour 
GROUP BY "year"||'-'|| CASE 
            WHEN "month" < 10 THEN '0'||"month"::varchar 
            ELSE "month"::varchar END 
ORDER BY "month")
SELECT * FROM tbl