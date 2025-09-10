# SQL – 2-Week Project

## Overview

This repository showcases my work from a 2-week intensive SQL project, demonstrating **professional SQL skills** applied to real-world datasets.
The focus is on writing advanced queries, analyzing data, designing databases, building pipelines, and delivering actionable business insights. 

## Skills Demonstrated
- Writing **complex SQL queries** with joins, subqueries, aggregations, and window functions
- Performing **data modeling**: normalization, ER diagrams, and star schemas
- Optimizing queries for **performance on large datasets**
- Building **ETL pipelines** and transforming raw data into analytics-ready tables
- Implementing **security best practices**, restricted views, and role-based access
- Creating **dashboards** to visualize business KPIs
- Using professional workflows with **GitHub version control** and SQL documentation
- Translating **business questions into actionable metrics**

All work is done using **Supabase** (PostgreSQL) for the database, **pgAdmin** for query testing, and **VSCode + GitHub** for version control and documentation.  

---

## Datasets

**1. Kaggle Online Retail Dataset (~0.4M rows)**  
- Source: [Kaggle E-commerce Dataset](https://www.kaggle.com/datasets/carrie1/ecommerce-data)  
- Description: Contains transactions from an online retail store, including invoice numbers, product codes, descriptions, quantities, prices, and customer info.  
- Imported into Supabase as table: `kaggle_ecommerce_dataset`  
- A synthetic primary key (`id`) has been added for unique row identification.
  
**2. NYC Taxi Trip Data, 1 month (trimmed) (~1M rows)**
- Source: [NYC Taxi Trip Dataset, January 2025 Yellow Taxi Trip Records] https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
- Description: Trimmed Yellow Taxi dataset (trimmed due to database size restrictions) (~1M rows) containing only key columns for query optimization: vendor ID, pickup/dropoff timestamps, passenger count, trip distance, payment type, and fare-related amounts.
- Kept only numeric and categorical fields relevant for aggregation, filtering, and indexing practice and dropped irrelevant columns (e.g., extra fees, airport fees, congestion surcharges).
- Imported into Supabase as table: `nyc_yellow_taxi_jan2025`
- A synthetic primary key (`id`) has been added for unique row identification.

**3. Optional Additional Datasets:**  
- Airbnb Seattle Data: [Kaggle Airbnb Dataset](https://www.kaggle.com/datasets/airbnb/seattle)  
- BigQuery public datasets for cloud practice  

---

## 2-Week SQL Project Overview

### Week 1 – Core SQL + Foundations

- [Kaggle Ecommerce Dataset] **Day 1: Advanced SQL Queries** 
  Focus on joins, subqueries, and window functions using the Kaggle dataset.  
  <details> 
  <summary>Tasks / Approach </summary>
    
    - **Top 5 Loyal Customers Per Year:** aggregation, window functions, time-based analysis<br> 
    - **Top 5 Customers Per Month:** aggregation, window functions, date truncation<br> 
    - **Lowest Revenue Product Per Country:** aggregation, window functions, string aggregation<br>
    - **Customer Purchase A&B:** joins, aggregation, window functions, subqueries
    
  </details>

- [NYC Taxi Trip Dataset] **Day 2: Query Optimization & Large Data**
  Query optimisation & indexing on large datasets

  <details>
    <summary>Step 1: Identify a slow query</summary>

    **Count all trips over or equal to 5 miles with fare ≥ 20 and with a passenger count equal to 4**

    **Query**
    ```sql
    SELECT COUNT(id)
    FROM nyc_yellow_taxi_jan2025
    WHERE trip_distance >= 5 AND fare_amount >= 20 AND passenger_count = 4;
    ```

    **Observation**
    - This query takes a time of (~1.41 seconds) because it performs a **sequential scan** over all 1M rows.
    - Most rows are filtered out, so the scan is inefficient.<br>
    - (Note: I previously filtered on only trip_distance and fare_amount which caused the index to be slower showing that an index is not always beneficial. This illustrates that indexes are only beneficial when the filter is selective enough to significantly reduce rows scanned.)

    <br>

    **EXPLAIN ANALYZE Output (baseline without index):**
    <details>
      <summary>Click to expand</summary>

      ```
      Gather  (cost=24670.13..24670.24 rows=1 width=8) (actual time=1406.119..1412.717 rows=2 loops=1)
        Workers Planned: 1
        Workers Launched: 1
        Partial Aggregate  (cost=23670.13..23670.14 rows=1 width=8) (actual time=1354.359..1354.359 rows=1 loops=2)
        Parallel Seq Scan on nyc_yellow_taxi_jan2025  (cost=0.00..23670.12 rows=5 width=4) (actual time=362.282..1354.205 rows=233 loops=2)
          Filter: ((trip_distance >= '20'::double precision) AND (fare_amount >= '50'::double precision) AND (passenger_count = 4))
          Rows Removed by Filter: 499767
      Planning Time: 0.141 ms
      Execution Time: 1412.763 ms
      ```

    </details>
  </details>

  <details>
    <summary>Step 2: Create a composite index to optimise above query</summary>

    **Index on trip_distance, fare_amount, and passenger_count**

    **Query**
    ```sql
    CREATE INDEX index_distance__passenger_fare
    ON nyc_yellow_taxi_jan2025(trip_distance, fare_amount, passenger_count);
    ```

    **Observation**
    - This query takes a time of (~0.03 seconds) because it performs a **index scan** over the specified rows.

    <br>

    **EXPLAIN ANALYZE Output (with index):**
    <details>
      <summary>Click to expand</summary>

      ```
      Aggregate  (cost=156.15..156.16 rows=1 width=8) (actual time=32.986..32.986 rows=1 loops=1)
        Index Scan using index_distance_passenger_fare on nyc_yellow_taxi_jan2025  (cost=0.42..156.13 rows=8 width=4) (actual time=1.049..32.878 rows=466 loops=1)
        Index Cond: ((trip_distance >= '20'::double precision) AND (fare_amount >= '50'::double precision) AND (passenger_count = 4))
      Planning Time: 9.221 ms
      Execution Time: 34.354 ms
      ```

    </details>
  </details>

  <details>
    <summary>Step 3: Further optimise queries with additional filters</summary>

    **Count trips over 20 miles, fare >= 50, passenger_count = 4, for a specific vendor**

    **Query**
    ```sql
    CREATE INDEX index_distance__passenger_fare_vendor
    ON nyc_yellow_taxi_jan2025(trip_distance, fare_amount, passenger_count, vendorid);
    ```

    **Observation**
    - PostgreSQL still uses the **previous composite index** for the first three columns, but `vendorid` is filtered afterwards

    <br>

    **EXPLAIN ANALYZE Output (composite index with additional filter):**
    <details>
      <summary>Click to expand</summary>

      ```
      Aggregate  (cost=156.15..156.16 rows=1 width=8) (actual time=32.986..32.986 rows=1 loops=1)
        Index Scan using index_distance_passenger_fare on nyc_yellow_taxi_jan2025  (cost=0.42..156.13 rows=8 width=4) (actual time=1.049..32.878 rows=466 loops=1)
        Index Cond: ((trip_distance >= '20'::double precision) AND (fare_amount >= '50'::double precision) AND (passenger_count = 4))
      Planning Time: 9.221 ms
      Execution Time: 34.354 ms
      Aggregate  (cost=156.16..156.17 rows=1 width=8) (actual time=0.983..0.984 rows=1 loops=1)
        Index Scan using index_distance_passenger_fare on nyc_yellow_taxi_jan2025  (cost=0.42..156.15 rows=6 width=4) (actual time=0.029..0.923 rows=425 loops=1)
          Index Cond: ((trip_distance >= '20'::double precision) AND (fare_amount >= '50'::double precision) AND (passenger_count = 4))
          Filter: (vendorid = 2)
          Rows Removed by Filter: 41
      Planning Time: 0.134 ms
      Execution Time: 1.013 ms
      ```

    </details>
  </details>

  <details>
    <summary>Step 4: Join optimization with a lookup table</summary>

    **Create a small reference table to optimise joins**

    **Query (create lookup table)**
    ```sql
    CREATE TABLE payment_lookup (
        payment_type INT PRIMARY KEY,
        payment_method TEXT
    );

    INSERT INTO payment_lookup (payment_type, payment_method) VALUES
        (1, 'Credit card'),
        (2, 'Cash'),
        (3, 'No charge'),
        (4, 'Dispute'),
        (5, 'Unknown'),
        (6, 'Voided trip');
    ```

    **Query (join taxi data to lookup table)**
    ```sql
    SELECT pl.payment_method, COUNT(*) AS trips_count
    FROM nyc_yellow_taxi_jan2025 t
    JOIN payment_lookup pl
      ON t.payment_type = pl.payment_type
    GROUP BY pl.payment_method
    ORDER BY trips_count DESC;
    ```

    **Observation**
    - Using a small lookup table allows **efficient aggregation** with descriptive labels instead of numeric codes.
    - Joins are fast because the `payment_lookup` table is tiny and can fit in memory.
    - Demonstrates **query optimization via join indexing** if `payment_type` is indexed on the main table.

  </details>

  <details>
    <summary>Step 5: Window function / time-series analysis</summary>

    **Calculate cumulative fare per vendor ordered by pickup time where fare amount is ≥ 100**

    **Query**
    ```sql
    SELECT 
      vendorid,
      tpep_pickup_datetime,
      fare_amount,
      SUM(fare_amount) OVER(PARTITION BY vendorid ORDER BY tpep_pickup_datetime) AS cumulative_fare
    FROM nyc_yellow_taxi_jan2025
    WHERE fare_amount >= 100;
    ```

    **Observation**
    - On large tables, **window functions** can be slow if the ORDER BY column is not indexed
    - Adding an index on `(vendorid, tpep_pickup_datetime, fare_amount)` can dramatically reduce execution time due to scanning in order without sorting all rows
    - (Note: that it is using a previously defined index to scan, if not for it, it would take drastically longer)

    <br>

    **EXPLAIN ANALYZE Output (baseline without index):**
    <details>
      <summary>Click to expand</summary>

      ```
      WindowAgg  (cost=147059.86..167059.84 rows=1000000 width=28) (actual time=4537.588..5237.766 rows=1000000 loops=1)
        Sort  (cost=147059.84..149559.84 rows=1000000 width=20) (actual time=4537.571..4680.841 rows=1000000 loops=1)
          Sort Key: vendorid, tpep_pickup_datetime
          Sort Method: external merge  Disk: 33312kB
            Seq Scan on nyc_yellow_taxi_jan2025  (cost=0.00..23376.00 rows=1000000 width=20) (actual time=5.316..3686.880 rows=1000000 loops=1)
      Planning Time: 18.464 ms
      Execution Time: 5297.714 ms
      ```

    </details>

    **Observation after adding index**
    ```sql
    CREATE INDEX index_vendor_pickup_fare
      ON nyc_yellow_taxi_jan2025(vendorid, tpep_pickup_datetime, fare_amount);
    ```
    - Query uses **index scan** to read rows in order per vendor, reducing the need for sorting
    - Execution time drops significantly on large tables

    **EXPLAIN ANALYZE Output (with index):**
    <details>
      <summary>Click to expand</summary>

      ```
      WindowAgg  (cost=4.09..13058.62 rows=3560 width=28) (actual time=0.027..33.719 rows=2352 loops=1)
        Index Only Scan using index_vendor_pickup_fare on nyc_yellow_taxi_jan2025  (cost=0.42..12996.32 rows=3560 width=20) (actual time=0.016..32.024 rows=2352 loops=1)
        Index Cond: (fare_amount >= '100'::double precision)
        Heap Fetches: 0
      Planning Time: 0.115 ms
      Execution Time: 33.889 ms
      ```

    </details>
  <br>

- [Kaggle Ecommerce Dataset] **Day 3: Database Design & Modeling**  
  Database design & modeling - normalization, ER diagrams, star schemas  

  <details> 
    <summary>Step 1: Explore the raw table</summary>

    - **Inspect the dataset**
      The table contains the following columns:
      `InvoiceNo`, `StockCode`, `Description`, `Quantity`,  
      `InvoiceDate`, `UnitPrice`, `CustomerID`, `Country`, `id`
      
    - **Identify entities**
      - **Customer info** (`CustomerID`, `Country`) repeats on every row
      - **Product info** (`StockCode`, `Description`, `UnitPrice`) repeats for every order
      - **Order info** (`InvoiceNo`, `InvoiceDate`) repeats for every line item in the order
      
    - **Detect redundancies**
      - Each customer's country is duplicated across all their purchases
      - Each product's description and unit price are duplicated across all orders
      - Each invoice's data is duplicated across all line items
 
    - **Conclusion**
      - The dataset is in a **flat, denormalised format**
      - Next steps: break it into separate entities (Customers, Products, Orders, Order Items) to reduce redundancy

  </details>

  <details>
    <summary>Step 2: Normalisation</summary>

    - **Task:** Split the raw table into 4 normalized tables to achieve 3NF and remove redundancy

    - **Tables created**
      1. `customers` → `CustomerID` (PK), `Country`
      2. `products`  → `StockCode` (PK), `Description`, `UnitPrice`
      3. `orders` → `InvoiceNo` (PK), `CustomerID`, `InvoiceDate`
      4. `order_items` → `InvoiceNo` + `StockCode` (composite PK), `Quantity`
   
    - **Decisions made**
      - Chose appropriate data types (`VARCHAR`, `TEXT`, `NUMERIC`, `INTEGER`, `TIMESTAMP`)
      - Added NOT NULL constraints for critical fields
      - Primary keys defined (including composite key for `order_items`)

    - **Outcome**
      - Tables are fully normalized and ready for defining relationships (foreign keys)
      - Redundancy from the original flat table has been removed

  </details>

  <details>
    <summary>Step 3: Relationships & ER Diagram</summary>

    - **Task:** Link the normalised tables with foreign keys and illustarte the relationships via an ER diagram
 
    - **Foreign Key relationships defined**
    1. `orders.CustomerID` → `customers.CustomerID`
        - Each order **belongs to exactly one customer**
        - One customer can have **many orders**
    2. `order_items.InvoiceNo` → `orders.InvoiceNo`
        - Each order item **belongs to exactly one order**
        - One order can have **many order items**
    3.  `order_items.StockCode` → `products.StockCode`
        - Each order item **refers to exactly one product**
        - One product can appear in **many order items**
      
  - **ER Diagram**
    
      ![ER Diagram](sql/Database_Design_&_Modelling/day3_er_diagram.png)

  - **Outcome**
    - All tables are now **fully normalised** and **linked**
    - Redundancy is eliminated and relationships are explicit
    - Ready for **queries, KPI calculation, and further modeling**
  </details>

- **Day 4: Business KPIs & Real-World Queries**  
  Turn queries into actionable metrics, such as revenue, churn, and repeat purchase rates.
  

- **Day 5: ETL / Data Pipeline Intro**  
  Load raw CSVs into Postgres, clean data, and create transformed analytics-ready tables using materialized views, foreign data wrappers, and partitioning.  
  
- **End of week 1: Mini Project #1**  
  Integrate Week 1 skills: load datasets, write 5–10 queries, document assumptions, and push to GitHub.  

### Week 2 – Professional Practices & Business Context

- **Day 6: Security & Restricted Views**  
  Create roles, grant permissions, and mask sensitive data for professional workflows.  

- **Day 7: Dashboarding**  
  Connect SQL results to Tableau, Power BI, or Metabase to visualize metrics.  

- **Day 8: Cloud SQL / Tooling**  
  Work with cloud datasets like BigQuery; integrate Python (pandas, SQLAlchemy) for analysis.  

- **Day 9: Business Case Simulation**  
  Translate vague business questions into SQL queries, e.g., churn rate, top customer segments, revenue trends.  
  
- **End of week 2: Capstone Mini Project**  
  End-to-end project: choose a dataset, design schema, write KPI queries, create dashboards, and push to GitHub.  

---

## How to Run Queries

1. Connect to the Supabase database using **pgAdmin**.  
2. Open SQL scripts from the `sql/` folder.  
3. Execute queries in pgAdmin or Supabase SQL Editor.  
4. Save results or take screenshots to include in `dashboards/`.  


