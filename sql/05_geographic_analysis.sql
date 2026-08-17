/*
============================================================
Retail Sales Analytics
Geographic Performance Analysis
============================================================

Purpose:
Evaluate regional and state-level sales and profitability,
identify loss-making markets, analyze discount behavior,
and compare geographic performance.

Portfolio Project:
Retail Sales Analytics
============================================================
*/


-- =========================================================
-- 1. REGIONAL PERFORMANCE
-- =========================================================

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


-- =========================================================
-- 2. STATE PERFORMANCE
-- =========================================================

SELECT
    state,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales
GROUP BY state
ORDER BY total_profit DESC;


-- =========================================================
-- 3. IDENTIFY LOSS-MAKING STATES
-- =========================================================

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
ORDER BY total_profit ASC;


-- =========================================================
-- 4. RANK STATES BY PROFIT
-- =========================================================

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


-- =========================================================
-- 5. HIGH-DISCOUNT GEOGRAPHIC PERFORMANCE
-- =========================================================

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
    ROUND(
        total_profit / NULLIF(total_sales, 0) * 100,
        2
    ) AS profit_margin_pct,
    RANK() OVER (
        ORDER BY total_profit ASC
    ) AS loss_rank
FROM high_discount_states
ORDER BY loss_rank;


-- =========================================================
-- 6. TEXAS DETAILED PERFORMANCE
-- =========================================================

SELECT
    state,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount), 3) AS average_discount,
    COUNT(*) AS transactions,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales
WHERE state = 'Texas'
GROUP BY state;


-- =========================================================
-- 7. REGIONAL DISCOUNT ANALYSIS
-- =========================================================

SELECT
    region,
    COUNT(*) AS transactions,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(discount), 3) AS average_discount,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales
GROUP BY region
ORDER BY average_discount DESC;


-- =========================================================
-- 8. TOP 10 STATES BY SALES
-- =========================================================

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
ORDER BY total_sales DESC
LIMIT 10;


-- =========================================================
-- 9. TOP 10 STATES BY PROFIT
-- =========================================================

SELECT
    state,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales
GROUP BY state
ORDER BY total_profit DESC
LIMIT 10;


-- =========================================================
-- 10. GEOGRAPHIC BUSINESS RISK SUMMARY
-- =========================================================

WITH geographic_summary AS (
    SELECT
        state,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        AVG(discount) AS average_discount
    FROM retail_sales
    GROUP BY state
)

SELECT
    state,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,
    ROUND(average_discount, 3) AS average_discount,

    CASE
        WHEN total_profit < 0
             AND average_discount >= 0.30
            THEN 'High Risk'

        WHEN total_profit < 0
            THEN 'Profitability Risk'

        WHEN average_discount >= 0.30
            THEN 'Discount Risk'

        ELSE 'Healthy'
    END AS geographic_risk_status

FROM geographic_summary
ORDER BY total_profit ASC;
