-- Week 1 Round-up: NYC Yellow Taxi Analytics & Optimisation
-- Dataset: NYC Yellow Taxi Dataset

-- Step 1: Data Staging & Cleaning
-- Create a staging table (mimicking raw import already done and trimmed in 2_Query_Optimisation) for NYC Yellow Taxi Jan2025
CREATE TABLE stg_nyc_yellow_taxi_jan2025 AS 
SELECT
	vendorid,
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	passenger_count,
	trip_distance,
	payment_type, 
	fare_amount,
	tip_amount,
	total_amount
FROM nyc_yellow_taxi_jan2025


-- Step 2: Database Normalisation & Schema Design
-- Dimension tables (lookups)
CREATE TABLE nyc_payment_lookup(
	payment_type INT PRIMARY KEY,
	description TEXT
);
INSERT INTO nyc_payments_lookup(payment_type, description)
VALUES
	(1, 'Credit card'),
	(2, 'Cash'),
	(3, 'No charge'),
	(4, 'Dispute'),
	(5, 'Unknown'),
	(6, 'Voided trip');

CREATE TABLE nyc_vendorid_lookup(
	vendorid INT PRIMARY KEY,
	tpep_provider TEXT
);
INSERT INTO nyc_vendorid_lookup(vendorid, tpep_provider)
VALUES
	(1, 'Creative Mobile Technologies'),
	(2, 'Curb Mobility'),
	(6, 'Myle Technologies'),
	(7, 'Helix');

CREATE TABLE nyc_pickup_date_lookup(
	pickup_date DATE PRIMARY KEY,
	day_of_week TEXT,
	is_weekend BOOLEAN,
	month INT,
	year INT
);
INSERT INTO nyc_pickup_date_lookup(pickup_date, day_of_week, is_weekend, month, year)
SELECT DISTINCT
	DATE(tpep_pickup_datetime) AS pickup_date,
	TO_CHAR(tpep_pickup_datetime, 'Day') AS day_of_week,
	CASE WHEN EXTRACT(DOW FROM tpep_pickup_datetime) IN (0,6) THEN TRUE ELSE FALSE END AS is_weekend,
	EXTRACT(MONTH FROM tpep_pickup_datetime):: INT AS month,
	EXTRACT(YEAR FROM tpep_pickup_datetime)::INT AS year
FROM stg_nyc_yellow_taxi_jan2025;

CREATE TABLE nyc_yellow_taxi_analytics AS
SELECT
	vendorid,
	payment_Type,
	DATE(tpep_pickup_datetime) AS pickup_date,
	tpep_pickup_datetime,
	tpep_dropoff_datetime,
	passenger_count,
	trip_distance,
	fare_amount,
	tip_amount,
	total_amount
FROM stg_nyc_yellow_taxi_jan2025
WHERE trip_distance > 0 
	AND fare_amount >= 0
	AND passenger_count > 0;


