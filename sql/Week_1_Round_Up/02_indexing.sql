-- Week 1 Round-up: NYC Yellow Taxi Analytics & Optimisation
-- Dataset: NYC Yellow Taxi Dataset

-- Step 3: Indexing for Performance
-- Index for time-based aggregation
CREATE INDEX idx_pickup_datetime ON nyc_yellow_taxi_analytics(tpep_pickup_datetime);

-- Composite index for vendor + pickup date queries
CREATE INDEX idx_vendor_pickup ON nyc_yellow_taxi_analytics(vendorid, tpep_pickup_datetime);

-- Index for payment type filtering
CREATE INDEX idx_payment_type ON nyc_yellow_taxi_analytics(payment_type);

-- Index for joining on pickup_date dimension
CREATE INDEX idx_pickup_date ON nyc_yellow_taxi_analytics(pickup_date);

