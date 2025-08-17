{{ 
config(
    materialized='incremental',
    schema='SILVER',
    alias='SUPPLIER'
) 
}}

WITH CLEANSED_DATA AS (
    select
        cast(ID as int) as SUPPLIER_ID,
        initcap(trim(COMPANYNAME)) as COMPANY_NAME,
        initcap(trim(CONTACTNAME)) as CONTACT_NAME,
        initcap(trim(CONTACTTITLE)) as CONTACT_TITLE,
        initcap(trim(CITY)) as CITY,
        upper(trim(COUNTRY)) as COUNTRY,
        trim(PHONE) as PHONE,
        trim(FAX) as FAX,
        current_timestamp() as LOAD_TIMESTAMP
    from {{ ref('SUPPLIER') }}  -- reference Bronze table
)

select *
from CLEANSED_DATA


