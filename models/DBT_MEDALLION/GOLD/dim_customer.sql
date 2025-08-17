{{ config(
    materialized='table',
    schema='GOLD',
) }}

WITH Ranked_customer as ( 
    SELECT * 
    FROM {{ ref('silver_customers') }} 
    qualify  row_number() over (partition by customer_id order by load_timestamp desc) =1)

    select * from Ranked_customer


