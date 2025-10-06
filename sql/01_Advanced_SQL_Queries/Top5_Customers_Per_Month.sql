/*
Calculates the top 5 customers by total spend for each month.
Demonstrates use of aggregation, window functions, and date truncation.
*/

WITH customer_monthly_spend_cte AS (
	SELECT
		"CustomerID",
		DATE_TRUNC('month', "InvoiceDate"::timestamp) AS month,
		SUM("Quantity" * "UnitPrice"::numeric) AS total_spend
	FROM kaggle_ecommerce_dataset AS kaggle
	WHERE "CustomerID" IS NOT NULL AND "CustomerID" <> ''
	GROUP BY "CustomerID", month
)
SELECT
	"CustomerID",
	month,
	ROUND(total_spend, 2) AS total_spend
FROM (
	SELECT 
		"CustomerID",
		month,
		total_spend,
		ROW_NUMBER() OVER (PARTITION BY month ORDER BY total_spend DESC) as ranking
	FROM customer_monthly_spend_cte
) AS ranked
WHERE ranking <= 5
ORDER BY month, total_spend DESC;





	