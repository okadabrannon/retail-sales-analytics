/*
============================================================
Retail Sales Analytics
Product Performance Analysis
============================================================

Purpose:
Evaluate category and sub-category profitability using
advanced SQL techniques including CTEs and window functions.
============================================================
*/

-- 1. Sub-Category Profitability
SELECT
    sub_category,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM retail_sales
GROUP BY sub_category
ORDER BY total_profit DESC;


-- 2. Rank Sub-Categories by Profit
WITH subcategory_profit AS (
    SELECT
        sub_category,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit
    FROM retail_sales
    GROUP BY sub_category
)

SELECT
    sub_category,
    total_sales,
    total_profit,
    RANK() OVER (
        ORDER BY total_profit DESC
    ) AS profit_rank
FROM subcategory_profit
ORDER BY profit_rank;


-- 3. Rank Sub-Categories Within Each Category
WITH product_performance AS (
    SELECT
        category,
        sub_category,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit
    FROM retail_sales
    GROUP BY category, sub_category
)

SELECT
    category,
    sub_category,
    total_sales,
    total_profit,
    RANK() OVER (
        PARTITION BY category
        ORDER BY total_profit DESC
    ) AS category_profit_rank
FROM product_performance
ORDER BY category, category_profit_rank;


-- 4. Identify Loss-Making Sub-Categories
WITH subcategory_summary AS (
    SELECT
        sub_category,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit,
        ROUND(AVG(discount), 3) AS average_discount
    FROM retail_sales
    GROUP BY sub_category
)

SELECT
    sub_category,
    total_sales,
    total_profit,
    average_discount
FROM subcategory_summary
WHERE total_profit < 0
ORDER BY total_profit;


-- 5. High-Discount Product Performance
WITH high_discount_products AS (
    SELECT
        sub_category,
        COUNT(*) AS transactions,
        ROUND(SUM(sales), 2) AS total_sales,
        ROUND(SUM(profit), 2) AS total_profit,
        ROUND(AVG(discount), 3) AS average_discount
    FROM retail_sales
    WHERE discount >= 0.30
    GROUP BY sub_category
)

SELECT
    sub_category,
    transactions,
    total_sales,
    total_profit,
    average_discount,
    RANK() OVER (
        ORDER BY total_profit
    ) AS loss_rank
FROM high_discount_products
ORDER BY loss_rank;
