-- Day 5: ETL / Data Pipeline
-- Step 3: Query Optimisation & Indexing
-- Dataset: Kaggle Ecommerce Dataset

-- Customers: filter by country
CREATE INDEX idx_kaggle_customers_country ON kaggle_customers("Country");

-- Orders: filter by customer
CREATE INDEX idx_kaggle_orders_customerid ON kaggle_orders("CustomerID");

-- Order items: lookups by single columns too (complement composite PK index)
CREATE INDEX idx_order_items_invoiceno ON kaggle_order_items("InvoiceNo");
CREATE INDEX idx_order_items_stockcode ON kaggle_order_items("StockCode");