-- Day 5: ETL / Data Pipeline
-- Step 2: Transform & Load Normalised Tables
-- Dataset: Kaggle Ecommerce Dataset

-- Truncate target tables to start fresh
TRUNCATE TABLE kaggle_customers, kaggle_products, kaggle_orders, kaggle_order_items RESTART IDENTITY;

-- Populate tables - dedpulication, remove nulls, handle inconsistencies, and ensure correct linkage
INSERT INTO kaggle_customers ("CustomerID", "Country")
SELECT
	"CustomerID", 
	MAX("Country") AS Country -- pick one country if duplicates exist
FROM stg_kaggle_customers
WHERE "CustomerID" IS NOT NULL
GROUP BY "CustomerID"

INSERT INTO kaggle_products ("StockCode", "Description", "UnitPrice")
SELECT "StockCode",
       MAX("Description") AS Description,
       AVG("UnitPrice") AS UnitPrice
FROM stg_kaggle_products
WHERE "StockCode" IS NOT NULL
GROUP BY "StockCode";

INSERT INTO kaggle_orders ("InvoiceNo", "CustomerID", "InvoiceDate")
SELECT "InvoiceNo", "CustomerID", invoice_ts
FROM (
    SELECT "InvoiceNo",
           "CustomerID",
           "InvoiceDate"::TIMESTAMP AS invoice_ts,
           ROW_NUMBER() OVER (PARTITION BY "InvoiceNo" ORDER BY "InvoiceDate") AS rn
    FROM stg_kaggle_orders
    WHERE "InvoiceNo" IS NOT NULL
      AND "CustomerID" IN (SELECT "CustomerID" FROM kaggle_customers)
) AS sub
WHERE rn = 1;  -- keeps only the first row per InvoiceNo

INSERT INTO kaggle_order_items ("InvoiceNo", "StockCode", "Quantity")
SELECT "InvoiceNo",
       "StockCode",
       SUM("Quantity") AS Quantity
FROM stg_kaggle_order_items oi
WHERE "InvoiceNo" IN (SELECT "InvoiceNo" FROM kaggle_orders)
  AND "StockCode" IN (SELECT "StockCode" FROM kaggle_products)
GROUP BY "InvoiceNo", "StockCode";

-- Check for any orphan order items (should return 0)
SELECT *
FROM kaggle_order_items oi
LEFT JOIN kaggle_products p ON oi."StockCode" = p."StockCode"
WHERE p."StockCode" IS NULL;
