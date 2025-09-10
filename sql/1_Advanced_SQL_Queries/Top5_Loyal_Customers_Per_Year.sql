/*
Ranks customers per year by loyalty (number of months they made purchases).
Shows the top 5 most loyal customers per year, along with total spend and total number of orders.
Demonstrates aggregation, window functions, and time-based analysis in PostgreSQL.
*/

SELECT
	year,
	"CustomerID",
	months_active,
	total_orders,
	total_spend,
	customer_rank
FROM (
	SELECT
		EXTRACT(YEAR FROM "InvoiceDate"::timestamp) AS year,
		"CustomerID",
		COUNT(DISTINCT DATE_TRUNC('month', "InvoiceDate"::timestamp)) AS months_active,
		COUNT(DISTINCT "InvoiceNo") AS total_orders,
		ROUND(SUM("Quantity"*"UnitPrice")::numeric, 2) AS total_spend,
		RANK() OVER (PARTITION BY EXTRACT(YEAR FROM "InvoiceDate"::timestamp) ORDER BY COUNT(DISTINCT DATE_TRUNC('month', "InvoiceDate"::timestamp)) DESC, SUM("Quantity"*"UnitPrice") DESC) AS customer_rank
	FROM kaggle_ecommerce_dataset AS kaggle
	WHERE "CustomerID" IS NOT NULL AND "CustomerID" <> ''
	GROUP BY year, "CustomerID"
) AS ranked_customers
WHERE customer_rank <= 5
ORDER BY year ASC, customer_rank ASC;

