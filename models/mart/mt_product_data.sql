with getProductData as (
    select product_id, product_name, category from {{ ref("stg_products") }}
)

select * from getProductData