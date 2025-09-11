-- Day 5: ETL / Data Pipeline
-- Goal: Load raw CSV into staging tables
-- Dataset: Kaggle Ecommerce Dataset

-- CREATE TABLE stg_kaggle_raw_orders (
-- 	"InvoiceNo" VARCHAR,
-- 	"StockCode" VARCHAR,
-- 	"Description" TEXT,
-- 	"Quantity" INTEGER,
-- 	"InvoiceDate" TIMESTAMP,
-- 	"UnitPrice" NUMERIC,
-- 	"CustomerID" VARCHAR,
-- 	"Country" VARCHAR
-- )

-- CREATE TABLE stg_kaggle_customers(
-- 	"CustomerID" VARCHAR,
-- 	"Country" VARCHAR
-- )

-- CREATE TABLE stg_kaggle_products (
-- 	"StockCode" VARCHAR,
-- 	"Description" TEXT,
-- 	"UnitPrice" NUMERIC
-- )

-- CREATE TABLE stg_kaggle_orders (
-- 	"InvoiceNo" VARCHAR,
-- 	"CustomerID" VARCHAR,
-- 	"InvoiceDate" TIMESTAMP
-- )

-- CREATE TABLE stg_kaggle_order_items (
-- 	"InvoiceNo" VARCHAR,
-- 	"StockCode" VARCHAR,
-- 	"Quantity" INTEGER
-- )


-- Load the full Kaggle CSV into the raw staging table
-- Due to Supabase restriction, I have run this through psql with \copy
-- COPY stg_kaggle_raw_orders (
-- 	"InvoiceNo",
-- 	"StockCode",
-- 	"Description",
-- 	"Quantity",
-- 	"InvoiceDate",
-- 	"UnitPrice",
-- 	"CustomerID",
-- 	"Country"
-- )
-- FROM '/Users/jackthootinsley/development/projects/sql-projects/datasets/kaggle_ecommerce_dataset.csv'
-- DELIMITER ','
-- CSV HEADER; -- Skip the first row containing column header

-- Populate entity staging tables
-- INSERT INTO stg_kaggle_customers ("CustomerID", "Country")
-- SELECT DISTINCT "CustomerID", "Country"
-- FROM stg_kaggle_raw_orders;

-- INSERT INTO stg_kaggle_products ("StockCode", "Description", "UnitPrice")
-- SELECT DISTINCT "StockCode", "Description", "UnitPrice"
-- FROM stg_kaggle_raw_orders;

-- INSERT INTO stg_kaggle_orders ("InvoiceNo", "CustomerID", "InvoiceDate")
-- SELECT DISTINCT "InvoiceNo", "CustomerID", "InvoiceDate"
-- FROM stg_kaggle_raw_orders;

-- INSERT INTO stg_kaggle_order_items ("InvoiceNo", "StockCode", "Quantity")
-- SELECT "InvoiceNo", "StockCode", "Quantity"
-- FROM stg_kaggle_raw_orders;

