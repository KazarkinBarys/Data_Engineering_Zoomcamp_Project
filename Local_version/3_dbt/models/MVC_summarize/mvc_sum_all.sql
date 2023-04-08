{{ config(materialized='table') }}

(SELECT * FROM "MVC_summarize".mvc_sum_2012) UNION ALL
(SELECT * FROM "MVC_summarize".mvc_sum_2013) UNION ALL
(SELECT * FROM "MVC_summarize".mvc_sum_2014) UNION ALL
(SELECT * FROM "MVC_summarize".mvc_sum_2015) UNION ALL
(SELECT * FROM "MVC_summarize".mvc_sum_2016) UNION ALL
(SELECT * FROM "MVC_summarize".mvc_sum_2017) UNION ALL
(SELECT * FROM "MVC_summarize".mvc_sum_2018) UNION ALL
(SELECT * FROM "MVC_summarize".mvc_sum_2019) UNION ALL
(SELECT * FROM "MVC_summarize".mvc_sum_2020) UNION ALL
(SELECT * FROM "MVC_summarize".mvc_sum_2021) UNION ALL
(SELECT * FROM "MVC_summarize".mvc_sum_2022) UNION ALL
(SELECT * FROM "MVC_summarize".mvc_sum_2023)

