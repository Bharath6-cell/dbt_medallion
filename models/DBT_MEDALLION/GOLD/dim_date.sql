{{ config(
    materialized='table',
    schema='GOLD',
    alias='DIM_DATE'
) }}

with dates as (
    select dateadd(day, seq4(), '2011-01-01'::date) as date_key
    from table(generator(rowcount => 3650))  -- 10 years
)
select
    date_key,
    date_key as full_date,
    year(date_key) as year,
    month(date_key) as month,
    day(date_key) as day,
    weekofyear(date_key) as week_of_year,
    case when dayofweek(date_key) in (1,7) then 'Weekend' else 'Weekday' end as day_type
from dates
