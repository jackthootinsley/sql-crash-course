# SQL Crash Course – 2-Week Project

## Overview

This repository showcases my work from a 2-week intensive SQL crash course, demonstrating **professional SQL skills** applied to real-world datasets.
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
  
  **Count all trips over or equal to 5 miles with fare ≥ 20**
  
  **Query**
  ```sql
  SELECT COUNT(id)
  FROM nyc_yellow_taxi_jan2025
  WHERE trip_distance >= 5 AND fare_amount >= 20
  ```

   **Observation**
  - This query takes a long time (~2.25 seconds) because it performs a **sequential scan** over all 3.5M rows.
  - Most rows are filtered out, so the scan is inefficient.<br>
  
  <br>
  
  **EXPLAIN ANALYZE Output (baseline):**
  <details>
  <summary>Click to expand</summary>
    
  ```
  Gather  (cost=78246.99..78247.10 rows=1 width=8) (actual time=2248.273..2250.276 rows=2 loops=1)
    Workers Planned: 1
    Workers Launched: 1
    Partial Aggregate  (cost=77246.99..77247.00 rows=1 width=8) (actual time=2195.860..2195.861 rows=1 loops=2)
      Parallel Seq Scan on nyc_yellow_taxi_jan2025  (cost=0.00..77063.76 rows=73292 width=4) (actual time=2.458..2174.651 rows=248204 loops=2)
        Filter: ((trip_distance >= '5'::double precision) AND (fare_amount >= '20'::double precision))
        Rows Removed by Filter: 1489409
  Planning Time: 0.097 ms
  Execution Time: 2250.338 ms
  ```
  
  </details>
  
  </details>


- **Day 3: Database Design & Modeling**  
  Database design & modeling - normalisation, ER diagrams, star schemas  

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


