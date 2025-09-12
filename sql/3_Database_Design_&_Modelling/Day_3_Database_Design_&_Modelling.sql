-- Day 3: Database Design & Modelling
-- Dataset: Kaggle Ecommerce Dataset

-- Step 1: Inspect the raw dataset
-- Task: Identify entities and redundancies
SELECT
	COUNT(DISTINCT "InvoiceNo") as unique_orders,
	COUNT(DISTINCT "Description") as unique_description,
	COUNT(DISTINCT "StockCode") as unique_products,
	COUNT(DISTINCT "CustomerID") as unique_customers,
	COUNT(DISTINCT "Country") as unique_countries
FROM kaggle_ecommerce_dataset as kaggle

-- Are customers repeated in multiple orders?
SELECT
	"CustomerID",
	COUNT(DISTINCT "InvoiceNo") as orders_count
FROM kaggle_ecommerce_dataset as kaggle
GROUP BY "CustomerID"
ORDER BY orders_count DESC
LIMIT 5;


-- Step 2: Normalisation
-- Task: Split the raw dataset into normalised tables to achieve 3NF and remove redundancy
CREATE TABLE kaggle_customers(
	"CustomerID" VARCHAR PRIMARY KEY,
	"Country" VARCHAR
)

CREATE TABLE kaggle_products (
	"StockCode" VARCHAR PRIMARY KEY,
	"Description" TEXT,
	"UnitPrice" NUMERIC(10, 2) NOT NULL 
)

CREATE TABLE kaggle_orders (
	"InvoiceNo" VARCHAR PRIMARY KEY,
	"CustomerID" VARCHAR NOT NULL,
	"InvoiceDate" TIMESTAMP NOT NULL
)

CREATE TABLE kaggle_order_items (
	"InvoiceNo" VARCHAR NOT NULL,
	"StockCode" VARCHAR NOT NULL,
	"Quantity" INTEGER NOT NULL,
	PRIMARY KEY ("InvoiceNo", "StockCode")
)


-- Step 3: Relationships & ER Diagram
-- Task: Link the normalised tables with foreign keys
ALTER TABLE kaggle_orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY ("CustomerID")
REFERENCES customers("CustomerID");

ALTER TABLE kaggle_order_items
ADD CONSTRAINT fk_order_items_orders
FOREIGN KEY ("InvoiceNo")
REFERENCES orders("InvoiceNo");

ALTER TABLE kaggle_order_items
ADD CONSTRAINT fk_order_items_products
FOREIGN KEY ("StockCode")
REFERENCES products("StockCode");
	
-- Populate the new tables with data from the raw dataset
INSERT INTO kaggle_customers ("CustomerID", "Country")
SELECT DISTINCT 
	"CustomerID", 
	"Country"
FROM kaggle_ecommerce_dataset as kaggle
WHERE "CustomerID" IS NOT NULL
ON CONFLICT ("CustomerID") DO NOTHING;

INSERT INTO kaggle_products ("StockCode", "Description", "UnitPrice")
SELECT DISTINCT 
	"StockCode",
	"Description",
	"UnitPrice"
FROM kaggle_ecommerce_dataset as kaggle
WHERE "StockCode" IS NOT NULL
ON CONFLICT ("StockCode") DO NOTHING;

INSERT INTO kaggle_orders ("InvoiceNo", "CustomerID", "InvoiceDate")
SELECT DISTINCT
	"InvoiceNo",
	"CustomerID",
	"InvoiceDate"::timestamp
FROM kaggle_ecommerce_dataset as kaggle
WHERE "InvoiceNo" IS NOT NULL
	AND "CustomerID" IS NOT NULL
ON CONFLICT ("InvoiceNo") DO NOTHING

INSERT INTO kaggle_order_items("InvoiceNo", "StockCode", "Quantity")
SELECT 
	"InvoiceNo",
	"StockCode",
	"Quantity"
FROM kaggle_ecommerce_dataset as kaggle
WHERE "InvoiceNo" IS NOT NULL
	AND "StockCode" IS NOT NULL
	AND "Quantity"  != 0 -- ignore returns
	AND "CustomerID" IS NOT NULL
ON CONFLICT ("InvoiceNo", "StockCode") DO NOTHING;