{{ config(materialized='table') }}

{%- set yrs = [ 2012, 2013, 2014, 2015, 
                2016, 2017, 2018, 2019, 
                2020, 2021, 2022, 2023 ] -%}

            {%- for yr in yrs %}
            {%- set src_tbl = 'MVC_summarize.mvc_sum_' ~ yr -%}
	(SELECT * FROM  {{src_tbl}}  )
            {%- if not loop.last %}
    UNION ALL
            {% endif -%}
            {% endfor %}


