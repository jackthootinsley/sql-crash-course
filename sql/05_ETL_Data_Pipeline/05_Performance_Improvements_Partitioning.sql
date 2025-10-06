-- Day 5: ETL / Data Pipeline
-- Step 5: Performance improvements (Partitioning)
-- Dataset: NYC Yello Taxi Jan 2025

-- Create the parent partitioned table
CREATE TABLE nyc_yellow_taxi_jan2025_part (
	vendorid INTEGER,
	tpep_pickup_datetime TIMESTAMP,
	tpep_dropoff_datetime TIMESTAMP,
	passenger_count INTEGER,
	trip_distance FLOAT,
	payment_type INTEGER,
	fare_amount FLOAT,
	tip_amount FLOAT,
	total_amount FLOAT
) PARTITION BY RANGE (tpep_pickup_datetime);

-- Automation to create weekly partitions for Jan 2025
DO $$
DECLARE
    start_date DATE := '2025-01-01';
    end_date DATE := '2025-02-01'; -- exclusive
    next_week DATE;
BEGIN
    next_week := start_date + INTERVAL '7 days';
    WHILE start_date < end_date LOOP
        EXECUTE format('
            CREATE TABLE nyc_yellow_taxi_%s PARTITION OF nyc_yellow_taxi_jan2025_part
            FOR VALUES FROM (%L) TO (%L);',
            to_char(start_date, 'YYYY_MM_DD'),
            start_date,
            next_week
        );
        start_date := next_week;
        next_week := start_date + INTERVAL '7 days';
        IF next_week > end_date THEN
            next_week := end_date;
        END IF;
    END LOOP;
END $$;

-- Populate parent partitioned table (automatically routes each row to the correct weekly partition)
INSERT INTO nyc_yellow_taxi_jan2025_part (
    vendorid,
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    payment_type,
    fare_amount,
    tip_amount,
    total_amount
)
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
WHERE tpep_pickup_datetime >= '2025-01-01'
	AND tpep_pickup_datetime < '2025-02-01'

-- Add indexes to partitions
CREATE INDEX idx_vendorid ON nyc_yellow_taxi_jan2025_part(vendorid);
CREATE INDEX idx_passenger_count ON nyc_yellow_taxi_jan2025_part(passenger_count);
CREATE INDEX idx_fare_amount ON nyc_yellow_taxi_jan2025_part(fare_amount);

-- Baseline on original table
EXPLAIN ANALYZE
SELECT COUNT(*)
FROM nyc_yellow_taxi_jan2025
WHERE tpep_pickup_datetime >= '2025-01-08'
  AND tpep_pickup_datetime < '2025-01-15';

-- On partitioned table with indexes
EXPLAIN ANALYZE
SELECT COUNT(*)
FROM nyc_yellow_taxi_jan2025_part
WHERE tpep_pickup_datetime >= '2025-01-08'
  AND tpep_pickup_datetime < '2025-01-15';


