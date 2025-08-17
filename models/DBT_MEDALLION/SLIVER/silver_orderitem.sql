{{ 
config(
    materialized='incremental',
    schema='SILVER',
    alias='ORDERITEM'
) 
}}

WITH CLEANSED_DATA AS (
    select
        cast(ID as int) as ORDER_ITEM_ID,
        cast(ORDERID as int) as ORDER_ID,
        cast(PRODUCTID as int) as PRODUCT_ID,
        cast(UNITPRICE as numeric(12,2)) as UNIT_PRICE,
        cast(QUANTITY as int) as QUANTITY,
        current_timestamp() as LOAD_TIMESTAMP
    from {{ ref('ORDERITEM')}}
)

select *
from CLEANSED_DATA


