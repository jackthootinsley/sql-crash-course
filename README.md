# SQL Crash Course – 2-Week Project

## Overview

This repository contains my work for a **2-week intensive SQL crash course** using real-world datasets.  
The goal is to practice and demonstrate **professional SQL skills**, including advanced queries, data modeling, ETL pipelines, query optimization, security, dashboarding, and portfolio-ready projects.  

All work is done using **Supabase** (PostgreSQL) for the database, **pgAdmin** for query testing, and **VSCode + GitHub** for version control and documentation.  

---

## Datasets

**1. Kaggle Online Retail Dataset**  
- Source: [Kaggle E-commerce Dataset](https://www.kaggle.com/datasets/carrie1/ecommerce-data)  
- Description: Contains transactions from an online retail store, including invoice numbers, product codes, descriptions, quantities, prices, and customer info.  
- Imported into Supabase as table: `"kaggle ecommerce dataset"`  
- A synthetic primary key (`id`) has been added for unique row identification.  

**2. Optional Additional Datasets:**  
- NYC Taxi Trip Data (~1M rows): [TLC Trip Records](https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page)  
- Airbnb Seattle Data: [Kaggle Airbnb Dataset](https://www.kaggle.com/datasets/airbnb/seattle)  
- BigQuery public datasets for cloud practice  

---

## 2-Week SQL Crash Course Plan

### Week 1 – Core SQL + Foundations

- **Day 1: Advanced SQL Queries**  
  Focus on joins, subqueries, and window functions using the Kaggle dataset.  

- **Day 2: Query Optimization & Large Data**  
  Learn performance tuning and indexing; practice with large datasets like NYC Taxi data.  

- **Day 3: Database Design & Modeling**  
  Normalize data, create ER diagrams, and design star schemas for analytics.  

- **Day 4: Business KPIs & Real-World Queries**  
  Turn queries into actionable metrics, such as revenue, churn, and repeat purchase rates.  

- **Day 5: ETL / Data Pipeline Intro**  
  Load raw CSVs into Postgres, clean data, and create transformed analytics-ready tables.  

- **Day 6: Collaboration & Git**  
  Save queries as `.sql` files, commit to GitHub, and practice branching/pull requests.  

- **Day 7: Mini Project #1**  
  Integrate Week 1 skills: load datasets, write 5–10 queries, document assumptions, and push to GitHub.  

### Week 2 – Professional Practices & Business Context

- **Day 8: Security & Restricted Views**  
  Create roles, grant permissions, and mask sensitive data for professional workflows.  

- **Day 9: Dashboarding**  
  Connect SQL results to Tableau, Power BI, or Metabase to visualize metrics.  

- **Day 10: Cloud SQL / Tooling**  
  Work with cloud datasets like BigQuery; integrate Python (pandas, SQLAlchemy) for analysis.  

- **Day 11: Business Case Simulation**  
  Translate vague business questions into SQL queries, e.g., churn rate, top customer segments, revenue trends.  

- **Day 12: Portfolio Polish**  
  Organize SQL scripts, dashboards, and notes in GitHub; add README documentation.  

- **Day 13: Capstone Mini Project**  
  End-to-end project: choose a dataset, design schema, write KPI queries, create dashboards, and push to GitHub.  

- **Day 14: Mock Interview & Review**  
  Practice explaining queries, optimization, OLTP vs OLAP, and business metrics; present your GitHub portfolio.  

---

## Goals

By the end of the 2-week course, I aim to:  
- Write **professional-grade SQL queries** on real-world datasets  
- Understand **relational modeling, normalization, and star schemas**  
- Optimize queries for performance on large datasets  
- Practice **ETL pipelines, security, and dashboard creation**  
- Maintain a **portfolio-ready GitHub repository** with SQL scripts and visualizations  
- Communicate insights effectively to non-technical stakeholders  

---

## How to Run Queries

1. Connect to the Supabase database using **pgAdmin**.  
2. Open SQL scripts from the `sql/` folder.  
3. Execute queries in pgAdmin or Supabase SQL Editor.  
4. Save results or take screenshots to include in `dashboards/`.  

---

## Notes

- Table and column names with spaces are quoted (e.g., `"kaggle ecommerce dataset"`).  
- All queries are version-controlled in GitHub for reproducibility.  
- Dashboards/screenshots provide visualizations of key insights for portfolio purposes.

