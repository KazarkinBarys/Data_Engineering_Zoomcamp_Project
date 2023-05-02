{{ config( materialized='table') }}
{%- set yrs = [ 2012, 2013, 2014, 2015, 
                2016, 2017, 2018, 2019, 
                2020, 2021, 2022, 2023 ] -%}

WITH temp AS (
    {%- for yr in yrs %}
    {%- set src_tbl = 'MVC_C_' ~ yr -%}
(SELECT 
date_part('year',crash_date)::INTEGER AS "year",
date_part('month',crash_date)::INTEGER AS "month", 
date_part('hour',crash_time) as "from time", 
date_part('hour',crash_time) as "to time", 
COUNT(*)::INTEGER AS "all_amount",  
SUM(injured)::INTEGER AS "injured_am", 
SUM(killed)::INTEGER AS "killed_am" 
FROM {{ source('MVC_C',src_tbl) }} 
GROUP BY date_part('year',crash_date), 
date_part('month',crash_date), 
date_part('hour',crash_time) 
ORDER BY 1,2,3) 
{%- if not loop.last %}
UNION ALL
{% endif -%}
{% endfor %}
)


SELECT "year", "month", 
CASE WHEN "from time" < 10 THEN '0'||"from time"::varchar ELSE "from time"::varchar
END ||':00'||' - '||CASE WHEN "from time" < 10 THEN '0'||"to time"::varchar ELSE "to time"::varchar END ||':59' as time_interval,
"all_amount", "injured_am", "killed_am", "from time", "to time"

FROM temp
ORDER BY "year", "month", "from time"