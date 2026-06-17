use shopease;
SET sql_mode = '';
-- 23. Total revenue by region — ordered highest to lowest
SELECT 
    region,
    SUM(net_revenue)            AS total_revenue,
    COUNT(order_id)             AS total_orders
FROM retail_sales
GROUP BY region
ORDER BY total_revenue DESC;

-- Task 24: Top 5 customers by total spending
SELECT 
    customer_id,
    customer_name,
    SUM(net_revenue)           AS total_spent,
    COUNT(order_id)            AS total_orders
FROM retail_sales
GROUP BY customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- Task 25: Monthly revenue trend — year, month, total revenue, total orders
SELECT 
    YEAR(order_date)        AS year,
    MONTH(order_date)       AS month,
    SUM(net_revenue)        AS total_revenue,
    COUNT(order_id)         AS total_orders
FROM retail_sales
GROUP BY year, month
ORDER BY year, month;

-- Task 26: Return rate by category (% of orders returned)
SELECT 
    category,
    COUNT(order_id)                                           AS total_orders,
    SUM(CASE WHEN returned = 'Yes' THEN 1 ELSE 0 END)        AS returned_orders,
    ROUND(
        SUM(CASE WHEN returned = 'Yes' THEN 1 ELSE 0 END) 
        * 100.0 / COUNT(order_id), 2
    )                                                         AS return_rate_pct
FROM retail_sales
GROUP BY category
ORDER BY return_rate_pct DESC;

-- Task 27: Average delivery days by payment method
SELECT 
    payment_method,
    ROUND(AVG(delivery_days), 2)    AS avg_delivery_days,
    MIN(delivery_days)              AS min_days,
    MAX(delivery_days)              AS max_days,
    COUNT(order_id)                 AS total_orders
FROM retail_sales
GROUP BY payment_method
ORDER BY avg_delivery_days ASC;

-- Task 28: Revenue contribution by category (revenue + % of total)
SELECT 
    category,
    SUM(net_revenue)                                        AS category_revenue,
    ROUND(
        SUM(net_revenue) * 100.0 / SUM(SUM(net_revenue)) OVER(), 2
    )                                                       AS pct_of_total
FROM retail_sales
GROUP BY category
ORDER BY category_revenue DESC;

-- Task 29: Customers who have placed more than 5 orders
SELECT 
    customer_id,
    customer_name,
    COUNT(order_id)          AS order_count,
    SUM(net_revenue)         AS total_spent
FROM retail_sales
GROUP BY customer_id, customer_name
HAVING COUNT(order_id) > 5
ORDER BY order_count DESC;

-- Checking maximum orders per customer
SELECT 
    customer_id,
    customer_name,
    COUNT(order_id)     AS order_count
FROM retail_sales
GROUP BY customer_id, customer_name
ORDER BY order_count DESC
LIMIT 10;

-- Task 29: Customers who have placed more than 5 orders
-- Investigation shows maximum orders per customer is 2
-- No customer qualifies for the > 5 threshold
-- This reveals a low repeat purchase rate — a key business insight

SELECT 
    customer_id,
    customer_name,
    COUNT(order_id)          AS order_count,
    SUM(net_revenue)         AS total_spent
FROM retail_sales
GROUP BY customer_id, customer_name
HAVING COUNT(order_id) > 1
ORDER BY order_count DESC;

-- Task 30: Month-over-month revenue growth using LAG() window function
WITH monthly_revenue AS (
    SELECT 
        YEAR(order_date)        AS year,
        MONTH(order_date)       AS month,
        SUM(net_revenue)        AS total_revenue
    FROM retail_sales
    GROUP BY year, month
)
SELECT 
    year,
    month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY year, month)   AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY year, month))
        * 100.0 / LAG(total_revenue) OVER (ORDER BY year, month), 2
    )                                                AS mom_growth_pct
FROM monthly_revenue
ORDER BY year, month;

-- Task 31: Products with above-average revenue per unit
WITH product_stats AS (
    SELECT 
        product_name,
        SUM(net_revenue)                                        AS total_revenue,
        SUM(quantity)                                           AS total_units_sold,
        ROUND(SUM(net_revenue) / SUM(quantity), 2)             AS revenue_per_unit
    FROM retail_sales
    GROUP BY product_name
),
avg_rpu AS (
    SELECT AVG(revenue_per_unit) AS avg_revenue_per_unit 
    FROM product_stats
)
SELECT 
    p.product_name,
    p.total_revenue,
    p.total_units_sold,
    p.revenue_per_unit,
    a.avg_revenue_per_unit,
    ROUND(p.revenue_per_unit - a.avg_revenue_per_unit, 2)  AS above_avg_by
FROM product_stats p
CROSS JOIN avg_rpu a
WHERE p.revenue_per_unit > a.avg_revenue_per_unit
ORDER BY p.revenue_per_unit DESC;

-- Task 32: Rank salespersons by total revenue using RANK()
SELECT 
    salesperson_id,
    SUM(net_revenue)                                      AS total_revenue,
    COUNT(order_id)                                       AS total_orders,
    ROUND(AVG(net_revenue), 2)                            AS avg_order_value,
    RANK() OVER (ORDER BY SUM(net_revenue) DESC)          AS revenue_rank
FROM retail_sales
GROUP BY salesperson_id
ORDER BY revenue_rank;

/*
=============================================================
   PROJECT 1 — RETAIL SALES PERFORMANCE ANALYSIS
   SQL FINDINGS & INSIGHTS SUMMARY
=============================================================

INSIGHT 1 — Lagos Leads in Total Revenue (Task 23)
Lagos recorded the highest total revenue among all regions.
This is expected as Lagos is Nigeria's commercial capital
with the highest population and purchasing power.

INSIGHT 2 — Top Customers Have Equal Spending (Task 24)
Karina Weber and Wesley Bailey tied as the top spending
customers with identical total purchase values.
This suggests a loyalty programme opportunity for VIP customers.

INSIGHT 3 — Clothing Has the Highest Return Rate (Task 26)
Clothing recorded the highest return rate among all categories.
Likely caused by sizing mismatches and product expectation gaps.
Better size guides and product descriptions are recommended.

INSIGHT 4 — Cash Delivers Fastest, Transfer Slowest (Task 27)
Cash payments had the fastest average delivery days while
bank transfers had the slowest. Transfer confirmation delays
likely cause processing bottlenecks in the fulfilment chain.

INSIGHT 5 — Electronics Dominates Revenue (Task 28)
Electronics contributed the highest percentage of total revenue
while Food & Beverages contributed the least. ShopEase should
consider whether to invest more in Food or deprioritise it.

INSIGHT 6 — Extremely Low Repeat Purchase Rate (Task 29)
Maximum orders per customer is only 2, with just 2 customers
placing more than 1 order. This reveals a critical retention
problem — ShopEase is almost entirely dependent on new customers.
A loyalty programme is strongly recommended.

INSIGHT 7 — SP-049 is the Top Salesperson (Task 32)
Out of 50 salespersons, SP-049 ranked first by total revenue.
High performers like SP-049 should be studied to understand
what strategies can be replicated across the sales team.

=============================================================
*/