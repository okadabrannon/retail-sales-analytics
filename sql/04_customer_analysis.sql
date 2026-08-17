query = """
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
ORDER BY total_profit
LIMIT 10;
"""

loss_states_sql = pd.read_sql_query(query, conn)

loss_states_sql

Move customer analysis to correct SQL directory
