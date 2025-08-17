{{ config(
    materialized='incremental',
    schema='SILVER',
    alias='CUSTOMER',
) }}


WITH CLEANSED_DATA as (
SELECT
    cast(ID as int) AS CUSTOMER_ID,
    INITCAP(TRIM(FIRSTNAME)) AS FIRST_NAME,
    INITCAP(TRIM(LASTNAME)) AS LAST_NAME,
    INITCAP(TRIM(CITY)) AS CITY,         
    UPPER(COUNTRY) AS COUNTRY,
    trim(PHONE) as PHONE ,
    CURRENT_TIMESTAMP() AS LOAD_TIMESTAMP
FROM {{ ref('customer') }}
WHERE ID IS NOT NULL
)

select * from CLEANSED_DATA


