-- Day 3: Database Design & Modelling
-- Dataset: Kaggle Ecommerce Dataset

-- Step 1: Inspect the raw dataset
-- Task: Identify entities and redundancies
-- SELECT
-- 	COUNT(DISTINCT "InvoiceNo") as unique_orders,
-- 	COUNT(DISTINCT "Description") as unique_description,
-- 	COUNT(DISTINCT "StockCode") as unique_products,
-- 	COUNT(DISTINCT "CustomerID") as unique_customers,
-- 	COUNT(DISTINCT "Country") as unique_countries
-- FROM kaggle_ecommerce_dataset as kaggle

-- Are customers repeated in multiple orders?
-- SELECT
-- 	"CustomerID",
-- 	COUNT(DISTINCT "InvoiceNo") as orders_count
-- FROM kaggle_ecommerce_dataset as kaggle
-- GROUP BY "CustomerID"
-- ORDER BY orders_count DESC
-- LIMIT 5;


-- Step 2: Normalisation
-- Task: Split the raw dataset into normalised tables to achieve 3NF and remove redundancy
-- CREATE TABLE customers(
-- 	"CustomerID" VARCHAR PRIMARY KEY,
-- 	"Country" VARCHAR
-- )

-- CREATE TABLE products (
-- 	"StockCode" VARCHAR PRIMARY KEY,
-- 	"Description" TEXT,
-- 	"UnitPrice" NUMERIC(10, 2) NOT NULL 
-- )

-- CREATE TABLE orders (
-- 	"InvoiceNo" VARCHAR PRIMARY KEY,
-- 	"CustomerID" VARCHAR NOT NULL,
-- 	"InvoiceDate" TIMESTAMP NOT NULL
-- )

-- CREATE TABLE order_items (
-- 	"InvoiceNo" VARCHAR NOT NULL,
-- 	"StockCode" VARCHAR NOT NULL,
-- 	"Quantity" INTEGER NOT NULL,
-- 	PRIMARY KEY ("InvoiceNo", "StockCode")
-- )


-- Step 3: Relationships & ER Diagram
-- Task: Link the normalised tables with foreign keys
-- ALTER TABLE orders
-- ADD CONSTRAINT fk_orders_customers
-- FOREIGN KEY ("CustomerID")
-- REFERENCES customers("CustomerID");

-- ALTER TABLE order_items
-- ADD CONSTRAINT fk_order_items_orders
-- FOREIGN KEY ("InvoiceNo")
-- REFERENCES orders("InvoiceNo");

-- ALTER TABLE order_items
-- ADD CONSTRAINT fk_order_items_products
-- FOREIGN KEY ("StockCode")
-- REFERENCES products("StockCode");
	