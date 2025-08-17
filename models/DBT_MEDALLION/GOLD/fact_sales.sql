{{ 
config(
    materialized='incremental',
    schema='GOLD',
    alias='FACTSALES'
) 
}}

with source_data as (
    select
        o.order_id,
        o.customer_id,
        c.first_name,
        c.last_name,
        c.city as customer_city,
        c.country as customer_country,
        d.date_key,
        oi.product_id,
        p.product_name,
        p.supplier_id,
        s.company_name as supplier_name,
        oi.quantity,
        oi.unit_price,
        (oi.quantity * oi.unit_price) as total_amount,
        row_number() over (
            partition by o.order_id, oi.order_item_id
            order by o.load_timestamp desc
        ) as rn
    from {{ ref('silver_order') }} o
    join {{ ref('silver_orderitem') }} oi
        on o.order_id = oi.order_id
    left join {{ ref('dim_customer') }} c
        on o.customer_id = c.customer_id
    left join {{ ref('dim_product') }} p
        on oi.product_id = p.product_id
    left join {{ ref('dim_supplier') }} s
        on p.supplier_id = s.supplier_id
    left join {{ ref('dim_date') }} d
        on o.order_date = d.date_key
)

select *
from source_data
where rn = 1
{% if is_incremental() %}
  and not exists (
      select 1
      from {{ this }} t
      where t.order_id = source_data.order_id
        and t.product_id = source_data.product_id
  )
{% endif %}
