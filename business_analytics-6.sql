-- ============================================================
-- 1. Select the Business Analytics Database
-- ============================================================
USE business_analytics;

-- ============================================================
-- 2. Create Initial Customer Table
-- ============================================================
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    gender VARCHAR(20),
    city VARCHAR(50),
    country VARCHAR(50),
    signup_date DATE
);

-- ============================================================
-- 3. Create Initial Product Table
-- ============================================================
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2),
    cost DECIMAL(10,2)
);

-- ============================================================
-- 4. Create Initial Orders Table
-- ============================================================
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(30),
    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- ============================================================
-- 5. Create Initial Order Items Table
-- ============================================================
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- ============================================================
-- 7. Remove Initial Table Structure
-- These tables were replaced by the final e-commerce schema.
-- ============================================================
SHOW TABLES;

DROP TABLE IF EXISTS order_items;

DROP TABLE IF EXISTS orders;

DROP TABLE IF EXISTS customers;

show TABLES;

drop table if exists products;

-- Check remaining tables
show tables;

-- ============================================================
-- 8. Create Final Products Table
-- Stores product information used throughout the analysis.
-- ============================================================
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    created_at DATETIME,
    product_name VARCHAR(255)
);

-- ============================================================
-- 9. Create Website Sessions Table
-- Stores website visit/session information.
-- ============================================================
CREATE TABLE website_sessions (
    website_session_id INT PRIMARY KEY,
    created_at DATETIME,
    user_id INT,
    is_repeat_session TINYINT,
    utm_source VARCHAR(100),
    utm_campaign VARCHAR(100),
    utm_content VARCHAR(100),
    device_type VARCHAR(50),
    http_referer VARCHAR(500)
);

-- ============================================================
-- 9. Create Website Sessions Table
-- Stores website visit/session information.
-- ============================================================
CREATE TABLE website_pageviews (
    website_pageview_id INT PRIMARY KEY,
    created_at DATETIME,
    website_session_id INT,
    FOREIGN KEY (website_session_id)
        REFERENCES website_sessions(website_session_id)
);

-- ============================================================
-- 11. Create Orders Table
-- Stores completed customer orders and their session information.
-- ============================================================
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    created_at DATETIME,
    website_session_id INT,
    user_id INT,
    primary_product_id INT,
    items_purchased INT,
    price_usd DECIMAL(10,2),
    cogs_usd DECIMAL(10,2),
    FOREIGN KEY (website_session_id)
        REFERENCES website_sessions(website_session_id),
    FOREIGN KEY (primary_product_id)
        REFERENCES products(product_id)
);

-- ============================================================
-- 12. Create Order Items Table
-- Stores individual products included in each order.
-- ============================================================
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    created_at DATETIME,
    order_id INT,
    product_id INT,
    is_primary_item TINYINT,
    price_usd DECIMAL(10,2),
    cogs_usd DECIMAL(10,2),
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- ============================================================
-- 13. Create Order Item Refunds Table
-- Stores refund transactions associated with order items.
-- ============================================================
CREATE TABLE order_item_refunds (
    order_item_refund_id INT PRIMARY KEY,
    created_at DATETIME,
    order_item_id INT,
    order_id INT,
    refund_amount_usd DECIMAL(10,2),
    FOREIGN KEY (order_item_id)
        REFERENCES order_items(order_item_id),
    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
);

-- ============================================================
-- 13. Create Order Item Refunds Table
-- Stores refund transactions associated with order items.
-- ============================================================
show tables;

-- ============================================================
-- 15. Inspect Database Schema
-- Displays columns, data types, nullability, and key information.
-- ============================================================
USE business_analytics;

SELECT
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'business_analytics'
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- ============================================================
-- 16. Inspect Important Table Structures
-- ============================================================
DESCRIBE orders;

DESCRIBE order_items;

-- ============================================================
-- 17. Basic Product Data Validation
-- Checks the number of products and previews the data.
-- ============================================================
USE business_analytics;

SELECT COUNT(*) AS total_products
FROM products;

SELECT *
FROM products;

-- ============================================================
-- 18. Review Products Ordered by Product ID
-- ============================================================
USE business_analytics;

SELECT *
FROM products
ORDER BY product_id;

-- ============================================================
-- 19. Basic Row Counts for the Tables
-- Provides an overview of the available dataset size.
-- ============================================================
SELECT COUNT(*) AS total_sessions
FROM website_sessions;

SELECT COUNT(*) AS total_orders
FROM orders;

-- ============================================================
-- 20. Preview Order Data
-- ============================================================
SELECT *
FROM orders
LIMIT 10;

SELECT COUNT(*) AS total_order_items
FROM order_items;

SELECT COUNT(*) AS total_refunds
FROM order_item_refunds;

SELECT 'website_pageviews', COUNT(*)
FROM website_pageviews

-- ============================================================
-- 21. Validate Database Relationships
-- ============================================================
SELECT COUNT(*) AS invalid_orders
FROM orders o
LEFT JOIN website_sessions ws
    ON o.website_session_id = ws.website_session_id
WHERE ws.website_session_id IS NULL;


SELECT COUNT(*) AS invalid_pageviews
FROM website_pageviews wp
LEFT JOIN website_sessions ws
    ON wp.website_session_id = ws.website_session_id
WHERE ws.website_session_id IS NULL;

SELECT COUNT(*) AS invalid_orders_sessions
FROM orders o
LEFT JOIN website_sessions ws
    ON o.website_session_id = ws.website_session_id
WHERE o.website_session_id IS NOT NULL
  AND ws.website_session_id IS NULL;

SELECT COUNT(*) AS invalid_orders_sessions
FROM orders o
LEFT JOIN website_sessions ws
    ON o.website_session_id = ws.website_session_id
WHERE o.website_session_id IS NOT NULL
  AND ws.website_session_id IS NULL;

SELECT COUNT(*) AS invalid_order_items_orders
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE oi.order_id IS NOT NULL
  AND o.order_id IS NULL;

SELECT COUNT(*) AS invalid_refunds_order_items
FROM order_item_refunds r
LEFT JOIN order_items oi
    ON r.order_item_id = oi.order_item_id
WHERE r.order_item_id IS NOT NULL
  AND oi.order_item_id IS NULL;

SELECT COUNT(*) AS invalid_order_items_products
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE oi.product_id IS NOT NULL
  AND p.product_id IS NULL;

SELECT COUNT(*) AS invalid_refunds_orders
FROM order_item_refunds r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE r.order_id IS NOT NULL
  AND o.order_id IS NULL;

-- ============================================================
-- 22. Check Duplicate Primary Key Values
-- Ensures that primary identifiers are unique across all tables.
-- A result of 0 means no duplicate IDs were detected.
-- ============================================================
SELECT 'products' AS table_name, COUNT(*) - COUNT(DISTINCT product_id) AS duplicate_ids
FROM products

UNION ALL

SELECT 'website_sessions', COUNT(*) - COUNT(DISTINCT website_session_id)
FROM website_sessions

UNION ALL

SELECT 'website_pageviews', COUNT(*) - COUNT(DISTINCT website_pageview_id)
FROM website_pageviews

UNION ALL

SELECT 'orders', COUNT(*) - COUNT(DISTINCT order_id)
FROM orders

UNION ALL

SELECT 'order_items', COUNT(*) - COUNT(DISTINCT order_item_id)
FROM order_items

UNION ALL

SELECT 'order_item_refunds', COUNT(*) - COUNT(DISTINCT order_item_refund_id)
FROM order_item_refunds;


-- 23. EDA & Business Analysis
USE business_analytics;

SELECT
    COUNT(*) AS total_orders,
    ROUND(SUM(price_usd), 2) AS total_revenue,
    ROUND(SUM(cogs_usd), 2) AS total_cogs,
    ROUND(SUM(price_usd - cogs_usd), 2) AS total_profit,
    ROUND(
        SUM(price_usd - cogs_usd) / SUM(price_usd) * 100,
        2
    ) AS profit_margin_pct,
    ROUND(AVG(price_usd), 2) AS average_order_value
FROM orders;


-- Conversion & Session Performance
SELECT
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT o.order_id) /
        COUNT(DISTINCT ws.website_session_id) * 100,
        2
    ) AS conversion_rate_pct
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id;


-- Product Performance
SELECT
    p.product_id,
    p.product_name,
    COUNT(oi.order_item_id) AS units_sold,
    ROUND(SUM(oi.price_usd), 2) AS revenue,
    ROUND(SUM(oi.cogs_usd), 2) AS cogs,
    ROUND(SUM(oi.price_usd - oi.cogs_usd), 2) AS profit,
    ROUND(
        SUM(oi.price_usd - oi.cogs_usd) /
        SUM(oi.price_usd) * 100,
        2
    ) AS profit_margin_pct
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY revenue DESC;


-- Marketing Channel Performance
SELECT
    CASE
        WHEN ws.utm_source IS NULL
             OR TRIM(ws.utm_source) = ''
             OR UPPER(TRIM(ws.utm_source)) = 'NULL'
        THEN 'Direct / Unknown'
        ELSE ws.utm_source
    END AS marketing_channel,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT o.order_id) /
        COUNT(DISTINCT ws.website_session_id) * 100,
        2
    ) AS conversion_rate_pct,
    ROUND(COALESCE(SUM(o.price_usd), 0), 2) AS total_revenue,
    ROUND(
        COALESCE(SUM(o.price_usd), 0) /
        NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY
    CASE
        WHEN ws.utm_source IS NULL
             OR TRIM(ws.utm_source) = ''
             OR UPPER(TRIM(ws.utm_source)) = 'NULL'
        THEN 'Direct / Unknown'
        ELSE ws.utm_source
    END
ORDER BY total_revenue DESC;


-- Device Performance
SELECT
    COALESCE(ws.device_type, 'Unknown') AS device_type,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT o.order_id) /
        COUNT(DISTINCT ws.website_session_id) * 100,
        2
    ) AS conversion_rate_pct,
    ROUND(COALESCE(SUM(o.price_usd), 0), 2) AS total_revenue,
    ROUND(
        COALESCE(SUM(o.price_usd), 0) /
        NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY COALESCE(ws.device_type, 'Unknown')
ORDER BY total_revenue DESC;


-- Monthly Business Trends
SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS month,
    COUNT(*) AS total_orders,
    ROUND(SUM(price_usd), 2) AS total_revenue,
    ROUND(SUM(cogs_usd), 2) AS total_cogs,
    ROUND(SUM(price_usd - cogs_usd), 2) AS total_profit,
    ROUND(
        SUM(price_usd - cogs_usd) /
        SUM(price_usd) * 100,
        2
    ) AS profit_margin_pct,
    ROUND(AVG(price_usd), 2) AS average_order_value
FROM orders
GROUP BY DATE_FORMAT(created_at, '%Y-%m')
ORDER BY month;


-- Refund Analysis
SELECT
    COUNT(DISTINCT r.order_item_refund_id) AS total_refunds,
    COUNT(DISTINCT r.order_id) AS refunded_orders,
    ROUND(SUM(r.refund_amount_usd), 2) AS total_refund_amount,
    ROUND(
        SUM(r.refund_amount_usd) /
        NULLIF(SUM(oi.price_usd), 0) * 100,
        2
    ) AS refund_rate_pct
FROM order_item_refunds r
JOIN order_items oi
    ON r.order_item_id = oi.order_item_id;


-- Refunds by Product
SELECT
    p.product_id,
    p.product_name,
    COUNT(DISTINCT r.order_item_refund_id) AS total_refunds,
    ROUND(SUM(r.refund_amount_usd), 2) AS total_refund_amount,
    ROUND(
        SUM(r.refund_amount_usd) /
        NULLIF(SUM(oi.price_usd), 0) * 100,
        2
    ) AS refund_rate_pct
FROM order_item_refunds r
JOIN order_items oi
    ON r.order_item_id = oi.order_item_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_refund_amount DESC;


-- Refunds by Product
SELECT
    p.product_id,
    p.product_name,
    COUNT(DISTINCT r.order_item_refund_id) AS total_refunds,
    ROUND(SUM(r.refund_amount_usd), 2) AS total_refund_amount,
    ROUND(
        SUM(r.refund_amount_usd) /
        NULLIF(SUM(oi.price_usd), 0) * 100,
        2
    ) AS refund_rate_pct
FROM order_item_refunds r
JOIN order_items oi
    ON r.order_item_id = oi.order_item_id
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_refund_amount DESC;


 -- Descriptive Statistical Analysis
SELECT
    COUNT(*) AS total_orders,
    ROUND(AVG(price_usd), 2) AS mean_order_value,
    ROUND(STDDEV_POP(price_usd), 2) AS std_order_value,
    ROUND(VARIANCE(price_usd), 2) AS variance_order_value,
    ROUND(MIN(price_usd), 2) AS min_order_value,
    ROUND(MAX(price_usd), 2) AS max_order_value,
    ROUND(AVG(cogs_usd), 2) AS mean_cogs,
    ROUND(STDDEV_POP(cogs_usd), 2) AS std_cogs,
    ROUND(VARIANCE(cogs_usd), 2) AS variance_cogs,
    ROUND(MIN(cogs_usd), 2) AS min_cogs,
    ROUND(MAX(cogs_usd), 2) AS max_cogs,
    ROUND(AVG(price_usd - cogs_usd), 2) AS mean_profit,
    ROUND(STDDEV_POP(price_usd - cogs_usd), 2) AS std_profit,
    ROUND(VARIANCE(price_usd - cogs_usd), 2) AS variance_profit,
    ROUND(MIN(price_usd - cogs_usd), 2) AS min_profit,
    ROUND(MAX(price_usd - cogs_usd), 2) AS max_profit,
    ROUND(AVG(items_purchased), 2) AS mean_items_purchased,
    ROUND(STDDEV_POP(items_purchased), 2) AS std_items_purchased,
    ROUND(VARIANCE(items_purchased), 2) AS variance_items_purchased,
    MIN(items_purchased) AS min_items_purchased,
    MAX(items_purchased) AS max_items_purchased
FROM orders;


-- 24. Median Analysis
WITH ranked_orders AS (
    SELECT
        price_usd,
        cogs_usd,
        price_usd - cogs_usd AS profit,
        items_purchased,
        ROW_NUMBER() OVER (ORDER BY price_usd) AS rn_price,
        ROW_NUMBER() OVER (ORDER BY cogs_usd) AS rn_cogs,
        ROW_NUMBER() OVER (ORDER BY price_usd - cogs_usd) AS rn_profit,
        ROW_NUMBER() OVER (ORDER BY items_purchased) AS rn_items,
        COUNT(*) OVER () AS total_rows
    FROM orders
)
SELECT
    MAX(CASE
        WHEN rn_price = (total_rows + 1) / 2
        THEN price_usd
    END) AS median_order_value,
    MAX(CASE
        WHEN rn_cogs = (total_rows + 1) / 2
        THEN cogs_usd
    END) AS median_cogs,
    MAX(CASE
        WHEN rn_profit = (total_rows + 1) / 2
        THEN profit
    END) AS median_profit,
    MAX(CASE
        WHEN rn_items = (total_rows + 1) / 2
        THEN items_purchased
    END) AS median_items_purchased
FROM ranked_orders;


-- Advanced Product Revenue Analysis
WITH product_sales AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.price_usd) AS revenue,
        SUM(oi.price_usd - oi.cogs_usd) AS profit
    FROM order_items oi
    JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        p.product_id,
        p.product_name
)
SELECT
    product_id,
    product_name,
    ROUND(revenue, 2) AS revenue,
    ROUND(profit, 2) AS profit,
    ROUND(
        revenue / SUM(revenue) OVER () * 100,
        2
    ) AS revenue_share_pct,
    RANK() OVER (
        ORDER BY revenue DESC
    ) AS revenue_rank
FROM product_sales
ORDER BY revenue_rank;


-- Monthly Revenue Growth Analysis
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(created_at, '%Y-%m') AS month,
        SUM(price_usd) AS revenue,
        COUNT(*) AS orders
    FROM orders
    GROUP BY DATE_FORMAT(created_at, '%Y-%m')
),
monthly_growth AS (
    SELECT
        month,
        revenue,
        orders,
        LAG(revenue) OVER (
            ORDER BY month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    month,
    orders,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        (revenue - previous_month_revenue) /
        NULLIF(previous_month_revenue, 0) * 100,
        2
    ) AS revenue_growth_pct
FROM monthly_growth
ORDER BY month;


-- New vs Repeat Session Performance
SELECT
    CASE
        WHEN ws.is_repeat_session = 1 THEN 'Repeat Session'
        ELSE 'New Session'
    END AS session_type,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT o.order_id) /
        COUNT(DISTINCT ws.website_session_id) * 100,
        2
    ) AS conversion_rate_pct,
    ROUND(
        COALESCE(SUM(o.price_usd), 0),
        2
    ) AS total_revenue,
    ROUND(
        COALESCE(SUM(o.price_usd), 0) /
        NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS average_order_value
FROM website_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY
    ws.is_repeat_session
ORDER BY total_revenue DESC;


-- Cumulative Revenue Analysis
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(created_at, '%Y-%m') AS month,
        SUM(price_usd) AS monthly_revenue
    FROM orders
    GROUP BY DATE_FORMAT(created_at, '%Y-%m')
)
SELECT
    month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(
        SUM(monthly_revenue) OVER (
            ORDER BY month
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS cumulative_revenue
FROM monthly_sales
ORDER BY month;


-- 25. Final Business KPI Summary
SELECT
    COUNT(*) AS total_orders,
    ROUND(SUM(price_usd), 2) AS total_revenue,
    ROUND(SUM(cogs_usd), 2) AS total_cogs,
    ROUND(
        SUM(price_usd - cogs_usd),
        2
    ) AS total_profit,
    ROUND(
        SUM(price_usd - cogs_usd) /
        SUM(price_usd) * 100,
        2
    ) AS profit_margin_pct,
    ROUND(
        AVG(price_usd),
        2
    ) AS average_order_value,
    ROUND(
        (SELECT COUNT(DISTINCT order_id)
         FROM orders) /
        (SELECT COUNT(DISTINCT website_session_id)
         FROM website_sessions) * 100,
        2
    ) AS conversion_rate_pct,
    ROUND(
        (SELECT SUM(refund_amount_usd)
         FROM order_item_refunds),
        2
    ) AS total_refunds
FROM orders;


-- Top Products by Revenue
SELECT
    p.product_name,
    COUNT(oi.order_item_id) AS units_sold,
    ROUND(SUM(oi.price_usd), 2) AS revenue,
    ROUND(
        SUM(oi.price_usd - oi.cogs_usd),
        2
    ) AS profit
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY revenue DESC
LIMIT 10;