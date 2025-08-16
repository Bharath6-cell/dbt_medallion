{{ config(
    materialized='table',
    schema='BRONZE'
) }}

SELECT *
FROM {{ source('DBT_MEDALLION', 'SUPPLIER') }}