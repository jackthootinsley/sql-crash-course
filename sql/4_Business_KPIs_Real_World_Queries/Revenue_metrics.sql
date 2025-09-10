
-- Day 4: Customer Metrics - KPIs
-- Goal: Calculate key revenue and product performance metrics
-- Dataset: Kaggle Ecommerce Dataset

-- Key Metrics Included:
-- 1. monthly_revenue     → Total revenue generated per month
-- 2. product_revenue     → Top products by total revenue, quantity sold, and average sale value


WITH monthly_revenue AS (
    SELECT
        TO_CHAR(DATE_TRUNC('month', o."InvoiceDate"), 'YYYY-MM') AS month,
        SUM(oi."Quantity" * p."UnitPrice") AS total_revenue
    FROM kaggle_orders o
    INNER JOIN kaggle_order_items oi
        ON o."InvoiceNo" = oi."InvoiceNo"
    INNER JOIN kaggle_products p
        ON oi."StockCode" = p."StockCode"
    WHERE oi."Quantity" > 0
    GROUP BY month
    ORDER BY month
)
SELECT * FROM monthly_revenue;

-- Step 2: Total revenue per product (top 10)
WITH product_revenue AS (
    SELECT
        p."StockCode" AS product,
        p."Description",
        ROUND(SUM(oi."Quantity" * p."UnitPrice"), 2) AS total_revenue,
        ROUND(AVG(oi."Quantity" * p."UnitPrice"), 2) AS avg_price,
        SUM(oi."Quantity") AS quantity_sold
    FROM kaggle_products p
    INNER JOIN kaggle_order_items oi
        ON p."StockCode" = oi."StockCode"
    GROUP BY product, p."Description"
    ORDER BY total_revenue DESC
    LIMIT 10
)
SELECT * FROM product_revenue;
