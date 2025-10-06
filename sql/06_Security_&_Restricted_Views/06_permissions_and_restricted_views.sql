-- Day 6: Security & Restricted Views
-- Dataset: Kaggle Ecommerce Dataset

-- Step 2: Set Up Permissions

-- Secure staging tables
-- REVOKE ALL ON TABLE
-- 	stg_kaggle_customers,
-- 	stg_kaggle_order_items,
-- 	stg_kaggle_orders,
-- 	stg_kaggle_products,
-- 	stg_kaggle_raw_orders
-- FROM PUBLIC;

-- Data engineers: full access to staging tables
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE
	stg_kaggle_customers,
	stg_kaggle_order_items,
	stg_kaggle_orders,
	stg_kaggle_products,
	stg_kaggle_raw_orders
TO data_engineer;

-- Anaylsts: read-only on cleaned tables
GRANT SELECT ON TABLE
	kaggle_customers,
	kaggle_orders,
	kaggle_order_items,
	kaggle_products
TO analyst;

-- Business users: no table access (will see restricted views later)
REVOKE ALL ON TABLE
	kaggle_customers,
	kaggle_orders,
	kaggle_order_items,
	kaggle_products
FROM business_user;

-- Analysts and business users should not access staging
REVOKE ALL ON TABLE
	stg_kaggle_customers,
	stg_kaggle_order_items,
	stg_kaggle_orders,
	stg_kaggle_products,
	stg_kaggle_raw_orders
FROM analyst, business_user;

-- Building restricted views for business_users
-- Restricted view: Customers
CREATE OR REPLACE VIEW v_customers_public AS
SELECT
	md5(CAST(CustomerID AS text)) AS CustomerID_hashed, -- mask CustomerID
	country
FROM kaggle_customers;

-- Restricted view: Orders summary
CREATE OR REPLACE VIEW v_orders_summary AS
SELECT
	md5(CAST(o.CustomerID AS text)) AS CustomerID_hashed,
	COUNT(DISTINCT o.InvoiceNo) AS total_orders,
	SUM(oi.Quantity * p.UnitPrice) AS total_spent,
	MIN(o.InvoiceDate) AS first_order_date,
	MAX(o.InvoiceDate) AS last_order_date
FROM kaggle_orders o
INNER JOIN kaggle_order_items oi ON o.InvoiceNo = oi.InvoiceNo
INNER JOIN kaggle_products p ON oi.StockCode = p.StockCode
GROUP BY o.CustomerID;

-- Restricted view: Products
CREATE OR REPLACE VIEW v_products_public AS
SELECT
	StockCode,
	Description,
	UnitPrice
FROM kaggle_products;

GRANT SELECT ON v_customers_public TO business_user;
GRANT SELECT ON v_orders_summary TO business_user;
GRANT SELECT ON v_products_public TO business_user;
