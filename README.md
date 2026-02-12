# Credit Card Transactions – SQL Analytics Project

This SQL analytics project analyzes a real credit card transactions dataset using MySQL 8 features such as window functions, CTEs, aggregation, and date functions. The goal is to demonstrate practical SQL skills for a Data Analyst role.

## Dataset
Credit card transactions with columns:
- city
- transaction_date
- card_type
- exp_type
- gender
- amount

## Table of Contents
1. Introduction
2. Database Schema
3. Dataset
4. How to Run
5. Queries & Insights
6. Results & Interpretation
7. Author & Contact

## Objectives
1. Top 5 cities by spend and % contribution
2. Highest spend month per card type
3. Transaction where cumulative spend crosses 1,000,000 per card type
4. City with lowest Gold card spend ratio
5. Highest & lowest expense type per city
6. Female spend contribution by expense type
7. Highest MoM growth in Jan-2014
8. (Optional extensions)
9. Weekend spend ratio per city
10. Fastest city to reach 500 transactions

## Tech Stack
- MySQL 8+
- Window Functions (SUM OVER, RANK, LAG)
- CTEs

## How to Run

0. Install MySQL 8+ and enable local infile:
   ```sql
   SET GLOBAL local_infile = 1;
1. Create DB and tables using `schema.sql`
2. Load data using `load_data.sql`
3. Run analytics in `analysis_queries.sql`

---

Author: Rahul Bhankhad 
Email: irahulbhankhad@gmail.com
Goal: Data Analyst Portfolio Project
