/*
============================================================
Retail Sales Analytics
Customer Performance Analysis
============================================================

Purpose:
Evaluate customer sales, profitability, order frequency,
and revenue concentration using SQL.
============================================================
*/

-- 1. Customer Performance Summary
SELECT
    customer_id,
    customer_name,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales
GROUP BY customer_id, customer_name
ORDER BY total_sales DESC;


-- 2. Rank Customers by Sales
WITH customer_summary AS (
    SELECT
        customer_id,
        customer_name,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit,
        COUNT(DISTINCT order_id) AS total_orders
    FROM retail_sales
    GROUP BY customer_id, customer_name
)

SELECT
    customer_id,
    customer_name,
    total_sales,
    total_profit,
    total_orders,
    RANK() OVER (
        ORDER BY total_sales DESC
    ) AS sales_rank
FROM customer_summary
ORDER BY sales_rank;


-- 3. Rank Customers by Profit
WITH customer_summary AS (
    SELECT
        customer_id,
        customer_name,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit
    FROM retail_sales
    GROUP BY customer_id, customer_name
)

SELECT
    customer_id,
    customer_name,
    total_sales,
    total_profit,
    RANK() OVER (
        ORDER BY total_profit DESC
    ) AS profit_rank
FROM customer_summary
ORDER BY profit_rank;


-- 4. Identify High-Sales but Loss-Making Customers
WITH customer_summary AS (
    SELECT
        customer_id,
        customer_name,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit,
        COUNT(DISTINCT order_id) AS total_orders
    FROM retail_sales
    GROUP BY customer_id, customer_name
)

SELECT
    customer_id,
    customer_name,
    total_sales,
    total_profit,
    total_orders
FROM customer_summary
WHERE total_profit < 0
ORDER BY total_sales DESC;


-- 5. Customer Revenue Concentration
WITH customer_sales AS (
    SELECT
        customer_id,
        customer_name,
        SUM(sales) AS total_sales
    FROM retail_sales
    GROUP BY customer_id, customer_name
),

ranked_customers AS (
    SELECT
        customer_id,
        customer_name,
        total_sales,
        ROW_NUMBER() OVER (
            ORDER BY total_sales DESC
        ) AS sales_rank
    FROM customer_sales
)

SELECT
    ROUND(
        SUM(
            CASE
                WHEN sales_rank <= 10 THEN total_sales
                ELSE 0
            END
        ) /
        SUM(total_sales) * 100,
        2
    ) AS top_10_customer_sales_pct,

    ROUND(
        SUM(
            CASE
                WHEN sales_rank <= 50 THEN total_sales
                ELSE 0
            END
        ) /
        SUM(total_sales) * 100,
        2
    ) AS top_50_customer_sales_pct
FROM ranked_customers;


-- 6. Customer Segment Performance
SELECT
    segment,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales
GROUP BY segment
ORDER BY total_profit DESC;
