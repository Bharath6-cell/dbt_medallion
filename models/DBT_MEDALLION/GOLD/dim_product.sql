{{ config(
    materialized='table',
    schema='GOLD',
) }}

WITH Ranked_product as ( 
    SELECT     
    p.product_id,
    p.product_name,
    p.supplier_id,
    s.company_name as supplier_name,
    p.unit_price,
    p.package,
    p.is_discontinued,
    FROM {{ ref('silver_product') }} p
    left join {{ ref('silver_supplier') }} s
    on p.supplier_id = s.supplier_id
    qualify  row_number() over (partition by p.product_id  order by p.load_timestamp desc) =1)

    select * from Ranked_product
