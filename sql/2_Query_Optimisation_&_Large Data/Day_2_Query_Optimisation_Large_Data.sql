-- Day 2: Query Optimisation & Large Data
-- Dataset: NYC Yellow Taxi Jan 2025

-- Step 1: Identify a slow query (baseline)
-- Task: Count trips over 20 miles, fare >= 50, and passenger_count = 4
-- EXPLAIN ANALYZE
-- SELECT 
-- 	COUNT(id)
-- FROM nyc_yellow_taxi_jan2025
-- WHERE trip_distance >= 20 
-- 	AND fare_amount >= 50
-- 	AND passenger_count = 4


-- Step 2: Create a composite index to optimise above query
-- Task: Index on trip_distance, fare_amount, and passenger_count
-- CREATE INDEX index_distance_passenger_fare
-- ON nyc_yellow_taxi_jan2025(trip_distance, fare_amount, passenger_count);


-- Step 3: Further optimise queries with additional filters
-- Task: Count trips over 20 miles, fare >= 50,, passenger_count = 4, for a specific vendor
-- CREATE INDEX index_distance_passenger_fare_vendor
-- ON nyc_yellow_taxi_jan2025(trip_distance, fare_amount, passenger_count, vendorid);

-- EXPLAIN ANALYZE
-- SELECT 
-- 	COUNT(id)
-- FROM nyc_yellow_taxi_jan2025
-- WHERE trip_distance >= 20 
-- 	AND fare_amount >= 50
-- 	AND passenger_count = 4
-- 	AND vendorid = 2;


-- Step 4: Join optimisation
-- Create a small lookup table for payment types
-- CREATE TABLE nyc_payment_lookup (
-- 	payment_type INT PRIMARY KEY,
-- 	description TEXT
-- );
-- INSERT INTO nyc_payment_lookup(payment_type, description)
-- VALUES
-- 	(1, 'Credit card'),
-- 	(2, 'Cash'),
-- 	(3, 'No charge'),
-- 	(4, 'Dispute'),
-- 	(5, 'Unknown'),
-- 	(6, 'Voided trip');

-- Count trips per payment type with descriptive labels
-- EXPLAIN ANALYZE
-- SELECT
-- 	p.description,
-- 	COUNT(t.id) AS trip_count
-- FROM nyc_yellow_taxi_jan2025 AS t
-- INNER JOIN nyc_payment_lookup AS p
-- 	ON t.payment_type = p.payment_type
-- GROUP BY p.description
-- ORDER BY trip_count DESC;


-- Step 5: Window function / time-series analysis
-- Calculate cumulative fare per vendor ordered by pickup time

-- Baseline query without index
-- EXPLAIN ANALYZE
-- SELECT 
--     vendorid,
--     tpep_pickup_datetime,
--     fare_amount,
--     SUM(fare_amount) OVER(PARTITION BY vendorid ORDER BY tpep_pickup_datetime) AS cumulative_fare
-- FROM nyc_yellow_taxi_jan2025
-- WHERE fare_amount >= 100;


-- Create index on tpep_pickup_datetime, vendorid, fare_amount
-- CREATE INDEX index_vendor_pickup_fare ON nyc_yellow_taxi_jan2025(vendorid, tpep_pickup_datetime, fare_amount);
