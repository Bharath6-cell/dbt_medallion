{{ 
config(
    materialized='incremental',
    schema='GOLD',
    alias='FACTSALES'
) 
}}

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
from {{ ref('silver_order') }} o                 -- Silver: orders
join {{ ref('silver_orderitem') }} oi           -- Silver: order items
    on o.order_id = oi.order_id
left join {{ ref('dim_customer') }} c           -- Gold: customer dimension
    on o.customer_id = c.customer_id
left join {{ ref('dim_product') }} p            -- Gold: product dimension
    on oi.product_id = p.product_id
left join {{ ref('dim_supplier') }} s           -- Gold: supplier dimension
    on p.supplier_id = s.supplier_id
left join {{ ref('dim_date') }} d               -- Gold: date dimension
    on o.order_date = d.date_key
{% if is_incremental() %}
    where (o.order_id, oi.order_item_id) not in (
        select order_id, order_item_id from {{ this }}
    )
{% endif %}
qualify rn = 1
