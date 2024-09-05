WITH getCustomerData AS (
    SELECT 
        customer_id,
        {{ concat_customer_name('first_name', 'last_name') }} AS customer_name,
        gender,
        {{ age_group('DATE_OF_BIRTH') }} AS Age_Group,
        membership_level
    FROM {{ ref('stg_customers') }}
),

getTotalOrders AS (
    SELECT 
        gc.customer_id,
        gc.customer_name,
        gc.gender,
        gc.Age_Group,
        gc.membership_level,
        COUNT(so.order_id) AS Total_Orders_By_Customer,
        SUM(so.total_amount) AS Total_Spent
    FROM getCustomerData AS gc
    LEFT JOIN {{ ref('stg_orders') }} AS so 
    ON gc.customer_id = so.customer_id
    GROUP BY 
        gc.customer_id,
        gc.customer_name,
        gc.gender,
        gc.Age_Group,
        gc.membership_level
),

getAverageOrderValue AS (
    SELECT 
        customer_id,
        Total_Spent / NULLIF(Total_Orders_By_Customer, 0) AS Average_Order_Value
    FROM getTotalOrders
),

getNumberOfReturns AS (
    SELECT 
        so.customer_id,
        COALESCE(COUNT(r.return_id), 0) AS Number_Of_Returns
    FROM {{ ref('stg_returns') }} AS r
    LEFT JOIN {{ ref('stg_orders') }} AS so
    ON r.order_id = so.order_id
    GROUP BY so.customer_id
),

finalCustomerData AS (
    SELECT 
        o.customer_id,
        o.customer_name,
        o.gender,
        o.Age_Group,
        o.membership_level,
        o.Total_Orders_By_Customer,
        a.Average_Order_Value,
        COALESCE(r.Number_Of_Returns, 0) AS Number_Of_Returns
    FROM getTotalOrders AS o
    LEFT JOIN getAverageOrderValue AS a
    ON o.customer_id = a.customer_id
    LEFT JOIN getNumberOfReturns AS r
    ON o.customer_id = r.customer_id
)

SELECT * 
FROM finalCustomerData;
