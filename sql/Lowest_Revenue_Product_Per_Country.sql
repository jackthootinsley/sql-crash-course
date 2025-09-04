/*
Finds the lowest-revenue product for each country.
Shows total revenue, number of sales, and customers who purchased it.
Demonstrates aggregation, window functions, and string aggregation.
*/

WITH product_country_revenue_cte AS (
	SELECT
		"Country",
		"StockCode",
		SUM("Quantity") as num_of_sales,
		SUM("Quantity"*"UnitPrice")::numeric as total_revenue,
		STRING_AGG(DISTINCT "CustomerID", ', ') AS customer_list
	FROM kaggle_ecommerce_dataset AS kaggle
	WHERE 
		"StockCode" IS NOT NULL AND "StockCode" <> ''
		AND "CustomerID" IS NOT NULL AND "CustomerID" <> ''
		AND "Quantity" > 0 	-- disregard returns
	GROUP BY "Country", "StockCode"
)

SELECT
	"Country",
	"StockCode",
	total_revenue,
	num_of_sales,
	customer_list
FROM (
	SELECT 
		"Country",
		"StockCode",
		total_revenue,
		num_of_sales,
		customer_list,
		ROW_NUMBER() OVER (PARTITION BY "Country" ORDER BY total_revenue ASC) AS rank
	FROM product_country_revenue_cte
) AS ranking
WHERE rank = 1
ORDER BY "Country";