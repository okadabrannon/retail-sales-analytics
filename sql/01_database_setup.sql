/*
============================================================
Retail Sales Analytics
Database Setup
============================================================

Purpose:
Create the primary retail sales table used for SQL-based
business analysis.

Dataset:
Sample Superstore

Analysis Areas:
- Sales performance
- Profitability
- Product performance
- Customer behavior
- Discount analysis
- Geographic performance
============================================================
*/

CREATE TABLE retail_sales (
    row_id INTEGER PRIMARY KEY,
    order_id VARCHAR(25),
    order_date DATE,
    ship_date DATE,
    ship_mode VARCHAR(50),
    customer_id VARCHAR(25),
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country_region VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    postal_code VARCHAR(20),
    region VARCHAR(50),
    product_id VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(255),
    sales DECIMAL(12,2),
    quantity INTEGER,
    discount DECIMAL(5,2),
    profit DECIMAL(12,2)
);
-- Validate the table structure
SELECT *
FROM retail_sales
LIMIT 10;
