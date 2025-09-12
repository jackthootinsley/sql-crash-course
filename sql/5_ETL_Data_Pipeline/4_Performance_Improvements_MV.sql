-- Day 5: ETL / Data Pipeline
-- Step 4: Performance improvements (Materialised Views)
-- Dataset: Kaggle Ecommerce Dataset

-- Identify slow queries (looking at Day 4 KPIs)
EXPLAIN ANALYZE
SELECT
	o."CustomerID",
	ROUND(SUM(oi."Quantity" * p."UnitPrice"), 2) AS total_spend,
	COUNT(DISTINCT o."InvoiceNo") AS total_orders
FROM kaggle_orders o
INNER JOIN kaggle_order_items oi
	ON o."InvoiceNo" = oi."InvoiceNo"
INNER JOIN kaggle_products p
	ON oi."StockCode" = p."StockCode"
WHERE o."CustomerID" <> ''
	AND oi."Quantity" > 0
GROUP BY o."CustomerID"

-- Create the Materialised View
CREATE MATERIALIZED VIEW customer_metrics_mv AS
SELECT
	o."CustomerID",
	ROUND(SUM(oi."Quantity" * p."UnitPrice"), 2) AS total_spend,
	COUNT(DISTINCT o."InvoiceNo") AS total_orders
FROM kaggle_orders o
INNER JOIN kaggle_order_items oi
	ON o."InvoiceNo" = oi."InvoiceNo"
INNER JOIN kaggle_products p
	ON oi."StockCode" = p."StockCode"
WHERE o."CustomerID" <> ''
	AND oi."Quantity" > 0
GROUP BY o."CustomerID"

-- Test MV
EXPLAIN ANALYZE SELECT * FROM customer_metrics_mv; 

-- Refresh whenever there is new or updated data
REFRESH MATERIALIZED VIEW customer_metrics_mv;
