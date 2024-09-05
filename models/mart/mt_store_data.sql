WITH store_data AS (
    SELECT 
        store_id, 
        store_name, 
        location, 
        store_type 
    FROM {{ ref('stg_stores') }}
),

getTotalEmployees AS (
    SELECT 
        sd.store_id, 
        sd.store_name, 
        sd.location, 
        sd.store_type,
        COUNT(et.employee_id) AS Total_Employees 
    FROM store_data AS sd
    LEFT JOIN {{ ref('stg_employees') }} AS et 
    ON sd.store_id = et.store_id
    GROUP BY 
        sd.store_id, 
        sd.store_name, 
        sd.location, 
        sd.store_type
),

getTotalUnitSold AS (
    SELECT 
        te.store_id, 
        te.store_name, 
        te.location, 
        te.store_type,
        te.Total_Employees,
        COUNT(ot.order_id) AS Total_Orders,
        COUNT(DISTINCT ot.customer_id) AS Total_Customers
    FROM getTotalEmployees AS te 
    -- Joining stg_orders instead of stg_customers
    LEFT JOIN {{ ref("stg_orders") }} AS ot
    ON te.store_id = ot.store_id
    GROUP BY 
        te.store_id,
        te.store_name,
        te.location,
        te.store_type,
        te.Total_Employees
)

SELECT *
FROM getTotalUnitSold AS FINAL_STORE_DATA
