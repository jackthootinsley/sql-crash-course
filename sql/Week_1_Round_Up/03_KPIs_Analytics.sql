-- Week 1 Round-up: NYC Yellow Taxi Analytics & Optimisation
-- Dataset: NYC Yellow Taxi Dataset

-- Step 4: KPIs and Analytics

-- Vendor + Day-of-Week Analytics Query
CREATE MATERIALIZED VIEW  mv_vendor_day_kpis AS
SELECT
    v.tpep_provider,
    d.day_of_week,
    COUNT(*) AS total_trips,
    ROUND(SUM(yt.fare_amount::NUMERIC), 2) AS total_fare,
    ROUND(SUM(yt.tip_amount::NUMERIC), 2) AS total_tips,
    ROUND(SUM(yt.total_amount::NUMERIC), 2) AS total_revenue,
    ROUND(AVG(yt.fare_amount::NUMERIC / NULLIF(yt.trip_distance::NUMERIC, 0))::NUMERIC, 2) AS avg_fare_per_mile,
    ROUND(AVG(yt.tip_amount::NUMERIC / NULLIF(yt.total_amount::NUMERIC, 0))::NUMERIC, 2)*100 AS avg_tip_percentage,
    ROUND(AVG(yt.trip_distance::NUMERIC), 2) AS avg_trip_distance,
    ROUND(AVG(yt.passenger_count::NUMERIC), 2) AS avg_passengers,
    ROUND(SUM(yt.total_amount::NUMERIC)/COUNT(*), 2) AS revenue_per_trip
FROM nyc_yellow_taxi_analytics yt
INNER JOIN nyc_vendorid_lookup v
    ON yt.vendorid = v.vendorid
INNER JOIN nyc_pickup_date_lookup d
    ON yt.pickup_date = d.pickup_date
GROUP BY v.tpep_provider, d.day_of_week
ORDER BY v.tpep_provider,
         CASE d.day_of_week
             WHEN 'Monday' THEN 1
             WHEN 'Tuesday' THEN 2
             WHEN 'Wednesday' THEN 3
             WHEN 'Thursday' THEN 4
             WHEN 'Friday' THEN 5
             WHEN 'Saturday' THEN 6
			 WHEN 'Sunday' THEN 7
         END;

REFRESH MATERIALIZED VIEW mv_vendor_day_kpis;
