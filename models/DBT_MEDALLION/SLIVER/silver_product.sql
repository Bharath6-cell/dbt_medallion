{{ 
config(
    materialized='incremental',
    schema='SILVER',
    alias='PRODUCT'
) 
}}

WITH CLEANSED_DATA AS (
    select
        cast(ID as int) as PRODUCT_ID,
        initcap(trim(PRODUCTNAME)) as PRODUCT_NAME,
        cast(SUPPLIERID as int) as SUPPLIER_ID,
        cast(UNITPRICE as numeric(12,2)) as UNIT_PRICE,
        trim(PACKAGE) as PACKAGE,
        case 
            when upper(ISDISCONTINUED) in ('TRUE','1','Y') then true
            else false
        end as IS_DISCONTINUED,
        current_timestamp() as LOAD_TIMESTAMP
    from {{ ref('PRODUCT') }}  -- reference Bronze layer
)

select *
from CLEANSED_DATA

