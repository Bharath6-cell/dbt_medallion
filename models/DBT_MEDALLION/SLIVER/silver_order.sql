{{ config(
    materialized='incremental',
    schema='SILVER',
    alias='ORDERS',
) }}


WITH CLEANSED_DATA  as (
    select
        cast(ID as int) as ORDER_ID,
        to_date(ORDERDATE) as ORDER_DATE,
        trim(ORDERNUMBER) as ORDER_NUMBER,
        cast(CUSTOMERID as int) as CUSTOMER_ID,
        cast(TOTALAMOUNT as numeric(12,2)) as TOTAL_AMOUNT,
        current_timestamp() as LOAD_TIMESTAMP
    from {{ ref('ORDERS') }}
)
select *
from CLEANSED_DATA
