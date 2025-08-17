{{ config(
    materialized='table',
    schema='GOLD',
) }}

WITH Ranked_supplier as ( 
    SELECT * 
    FROM {{ ref('silver_supplier') }} 
    qualify  row_number() over (partition by supplier_id  order by load_timestamp desc) =1)

    select * from Ranked_supplier