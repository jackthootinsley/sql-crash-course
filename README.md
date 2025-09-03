# SQL Crash Course – Supabase Project

## Overview

This repository contains my work for a **2-week SQL crash course** using a real-world dataset from Kaggle.  
The goal is to practice and demonstrate **professional SQL skills**, including data modeling, queries, aggregations, joins, window functions, and performance optimization.  

All work is done using **Supabase** (PostgreSQL) for the database, **pgAdmin** for query testing, and **VSCode + GitHub** for version control and documentation.  

---

## Dataset

**Kaggle Online Retail Dataset**  
- Source: [Kaggle E-commerce Dataset](https://www.kaggle.com/datasets/carrie1/ecommerce-data)  
- Description: Contains transactions from an online retail store, including invoice numbers, product codes, descriptions, quantities, prices, and customer info.  
- Imported into Supabase as table: `kaggle_ecommerce_dataset`  
- A synthetic primary key (`id`) has been added for unique row identification.  

---

## 2-Week SQL Crash Course Plan

**Week 1: Core SQL & Data Exploration**
- Day 1: Basic SELECT queries, filtering, ordering  
- Day 2: Aggregations, GROUP BY, HAVING  
- Day 3: Joins (INNER, LEFT, RIGHT, FULL)  
- Day 4: Common Table Expressions (CTEs)  
- Day 5: Window functions (RANK, ROW_NUMBER, SUM OVER)  
- Day 6: Subqueries and nested queries  
- Day 7: Review & consolidate queries  

**Week 2: Advanced SQL & Data Modeling**
- Day 8: Database design, normalization, primary/foreign keys  
- Day 9: Indexing and query performance optimization  
- Day 10: Advanced joins and multi-level aggregations  
- Day 11: Views and materialized views  
- Day 12: User-defined functions and stored procedures  
- Day 13: Mini-project: build a dashboard-ready dataset  
- Day 14: Final review, cleanup, and GitHub portfolio preparation  

---

## Goals

By the end of the 2-week crash course, I aim to:  
- Build confidence writing professional SQL queries  
- Understand how to model relational data and maintain referential integrity  
- Optimize queries for performance  
- Track all work in GitHub to showcase SQL projects and portfolio readiness  

---

## How to Run Queries

1. Connect to the Supabase database using **pgAdmin**.  
2. Open SQL scripts from the `sql/` folder.  
3. Execute queries in pgAdmin or Supabase SQL Editor.  
4. Results can be optionally saved as screenshots in `dashboards/` for portfolio presentation.  

---

## Notes

- Table and column names are quoted when necessary due to spaces (e.g., `"kaggle ecommerce dataset"`).  
- All queries are version-controlled and tracked in GitHub for reproducibility and portfolio purposes. 