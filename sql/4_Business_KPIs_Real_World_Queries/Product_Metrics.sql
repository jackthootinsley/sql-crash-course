
-- Day 4: Product Metrics KPIs
-- Goal: Calculate key product and performance metrics
-- Dataset: Kaggle Ecommerce Dataset

-- Key Metrics Included:
-- 1. top_products   	→ Top-selling products by quantity & revenue
-- 2. product_return 	→ Products with the highest return 
-- 3. no_sales_products → Products that never sold anything


WITH top_products AS (
	SELECT
		p."StockCode",
		p."Description",
		SUM(oi."Quantity" * p."UnitPrice") AS total_revenue,
		SUM(oi."Quantity") AS quantity_sold,
		ROUND(SUM(oi."Quantity" * p."UnitPrice") / NULLIF(SUM(oi."Quantity"), 0), 2) AS avg_price
	FROM kaggle_products p
	INNER JOIN kaggle_order_items oi
		ON p."StockCode" = oi."StockCode"
	WHERE oi."Quantity" > 0
	GROUP BY p."StockCode", p."Description"
	ORDER BY total_revenue DESC
	LIMIT 10
)
SELECT * FROM top_products;

WITH product_returns AS (
	SELECT
		p."StockCode",
		p."Description",
		ABS(SUM(oi."Quantity")) AS returned_quantity
	FROM kaggle_products p
	INNER JOIN kaggle_order_items oi
		ON p."StockCode" = oi."StockCode"
	WHERE oi."Quantity" < 0 -- only return
	GROUP BY p."StockCode", p."Description"
	ORDER BY returned_quantity DESC
	LIMIT 10
)
SELECT * FROM product_returns;

SELECT
    p."StockCode",
    p."Description"
FROM kaggle_products p
LEFT JOIN kaggle_order_items oi
    ON p."StockCode" = oi."StockCode" AND oi."Quantity" > 0
WHERE oi."StockCode" IS NULL;