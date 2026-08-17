/*
============================================================
Retail Sales Analytics
Geographic Performance Analysis
============================================================

Purpose:
Evaluate regional and state-level sales and profitability,
identify loss-making markets, and compare geographic
performance using SQL.
============================================================
*/

-- 1. Regional Performance
SELECT
    region,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales
GROUP BY region
ORDER BY total_profit DESC;


-- 2. State Performance
SELECT
    state,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales
GROUP BY state
ORDER BY total_profit DESC;


-- 3. Loss-Making States
WITH state_performance AS (
    SELECT
        state,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit,
        ROUND(AVG(discount), 3) AS average_discount
    FROM retail_sales
    GROUP BY state
)

SELECT
    state,
    total_sales,
    total_profit,
    average_discount,
    ROUND(
        total_profit / NULLIF(total_sales, 0) * 100,
        2
    ) AS profit_margin_pct
FROM state_performance
WHERE total_profit < 0
ORDER BY total_profit;


-- 4. State Profit Ranking
WITH state_profit AS (
    SELECT
        state,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit
    FROM retail_sales
    GROUP BY state
)

SELECT
    state,
    total_sales,
    total_profit,
    RANK() OVER (
        ORDER BY total_profit DESC
    ) AS profit_rank
FROM state_profit
ORDER BY profit_rank;


-- 5. High-Discount Geographic Performance
WITH high_discount_states AS (
    SELECT
        state,
        COUNT(*) AS transactions,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit,
        ROUND(AVG(discount), 3) AS average_discount
    FROM retail_sales
    WHERE discount >= 0.30
    GROUP BY state
)

SELECT
    state,
    transactions,
    total_sales,
    total_profit,
    average_discount,
    RANK() OVER (
        ORDER BY total_profit
    ) AS loss_rank
FROM high_discount_states
ORDER BY loss_rank;


-- 6. Texas Detailed Performance
SELECT
    state,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount), 3) AS average_discount,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales
WHERE state = 'Texas'
GROUP BY state;
