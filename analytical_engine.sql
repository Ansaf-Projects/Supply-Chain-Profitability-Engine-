SET GLOBAL local_infile = 1;
USE ecom_supply_chain;

CREATE TABLE logistics_fact_table (
    order_id TEXT,
    order_item_id int,
    product_id Text,
    seller_id text,
    shipping_limit_date text,
	price DOUBLE,
    freight_value DOUBLE,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TEXT,
    order_delivered_customer_date TEXT,
    order_estimated_delivery_date TEXT,   
    product_category_name TEXT,
    Delivery_SLA_Variance INT
);

-- Note: SHOW VARIABLES doesn't do anything for the import itself, 
-- you just use it to check the path. I removed it from the execution block.

LOAD DATA LOCAL INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/supply_chain_data_mart.csv.csv'
INTO TABLE logistics_fact_table
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select*from logistics_fact_table limit 10;


WITH CategoryLogistics AS (
    SELECT 
        product_category_name,
        COUNT(order_id) AS total_orders,
        SUM(CASE WHEN Delivery_SLA_Variance > 0 THEN 1 ELSE 0 END) AS delayed_orders,
        AVG(CASE WHEN Delivery_SLA_Variance > 0 THEN Delivery_SLA_Variance ELSE NULL END) AS avg_delay_days
    FROM logistics_fact_table
    GROUP BY product_category_name
)
SELECT 
    product_category_name,
    total_orders,
    delayed_orders,
    ROUND((delayed_orders / total_orders) * 100, 2) AS breach_rate_pct,
    ROUND(avg_delay_days, 1) AS avg_delay_severity_days,
    RANK() OVER(ORDER BY (delayed_orders / total_orders) DESC) AS supply_chain_risk_rank
FROM CategoryLogistics
WHERE total_orders > 100 -- Filters out low-volume statistical noise
ORDER BY supply_chain_risk_rank;


WITH ProfitabilityLeak AS (
    SELECT 
        product_category_name,
        SUM(price) AS total_gross_revenue,
        SUM(freight_value) AS total_freight_cost
    FROM logistics_fact_table
    GROUP BY product_category_name
)
SELECT 
    product_category_name,
    total_gross_revenue,
    total_freight_cost,
    ROUND((total_freight_cost / total_gross_revenue) * 100, 2) AS freight_ratio_pct
FROM ProfitabilityLeak
WHERE total_gross_revenue > 5000 
ORDER BY freight_ratio_pct DESC
LIMIT 15;
