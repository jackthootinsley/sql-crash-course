/*
Find customers who purchased both Product A (StockCode: 23537) and Product B (StockCode: 21936).
Simulates a separate products table using a CTE to demonstrate a join.
Shows CustomerID, total spend, and number of orders for those customers.
Demonstrates joins, aggregation, window functions, and subqueries in PostgreSQL.
*/

WITH products AS (
	SELECT 
		DISTINCT "StockCode",
		"Description"
	FROM kaggle_ecommerce_dataset AS kaggle
	WHERE "StockCode" IS NOT NULL AND "StockCode" <> ''
),
customer_orders AS (
	SELECT
		"CustomerID",
		"StockCode",
		SUM("Quantity"*"UnitPrice")::numeric AS total_spend,
		COUNT(DISTINCT "InvoiceNo") AS total_orders
	FROM kaggle_ecommerce_dataset AS kaggle
	WHERE "CustomerID" IS NOT NULL AND "CustomerID" <> ''
	GROUP BY "CustomerID", "StockCode"
)

SELECT
	co1."CustomerID",
	SUM(co1.total_spend + co2.total_spend) AS total_spend,
	SUM(co1.total_orders + co2.total_orders) AS total_orders
FROM customer_orders co1
INNER JOIN customer_orders co2
	ON co1."CustomerID" = co2."CustomerID"
WHERE co1."StockCode" = '23537'
	AND co2."StockCode" = '21936'
GROUP BY co1."CustomerID"
ORDER BY total_spend DESC;