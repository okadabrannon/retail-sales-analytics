/*
============================================================
Retail Sales Analytics
Sales Performance Analysis
============================================================

Purpose:
Evaluate revenue, profitability, annual growth, and discount
performance using SQL.
============================================================
*/

-- 1. Overall Business Performance
SELECT
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales;


-- 2. Annual Sales and Profit Performance
SELECT
    CAST(strftime('%Y', order_date) AS INTEGER) AS order_year,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales
GROUP BY order_year
ORDER BY order_year;


-- 3. Monthly Sales Performance
SELECT
    CAST(strftime('%m', order_date) AS INTEGER) AS order_month,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders
FROM retail_sales
GROUP BY order_month
ORDER BY order_month;


-- 4. Discount Group Profitability
SELECT
    CASE
        WHEN discount >= 0.30 THEN '30% or Higher'
        ELSE 'Below 30%'
    END AS discount_group,
    COUNT(*) AS transactions,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(profit), 2) AS average_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales
GROUP BY discount_group
ORDER BY total_profit DESC;


-- 5. Loss Rate by Discount Group
SELECT
    CASE
        WHEN discount >= 0.30 THEN '30% or Higher'
        ELSE 'Below 30%'
    END AS discount_group,
    COUNT(*) AS total_transactions,
    SUM(
        CASE
            WHEN profit < 0 THEN 1
            ELSE 0
        END
    ) AS loss_transactions,
    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN profit < 0 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS loss_rate_pct
FROM retail_sales
GROUP BY discount_group;
