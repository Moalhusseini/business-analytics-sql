# Business Analytics Using SQL

## Project Overview

This project analyzes an e-commerce business dataset using MySQL and SQL to extract business insights from website sessions, pageviews, orders, products, order items, and refunds.

The main objective is to understand business performance, profitability, conversion behavior, product performance, marketing channels, device performance, refund activity, customer session behavior, and revenue growth over time.

The project combines exploratory data analysis, descriptive statistics, business KPIs, segmentation, product ranking, refund analysis, and advanced SQL techniques.

---

## Business Questions

The analysis focuses on the following business questions:

- How much revenue and profit did the business generate?
- What is the average order value?
- What is the overall conversion rate?
- Which products generate the most revenue?
- How do marketing channels perform?
- How does performance differ across devices?
- How does revenue change over time?
- What does the distribution of order values look like?
- What is the impact of refunds?
- How do new and repeat sessions differ?
- Which products contribute the largest share of total revenue?
- How does monthly revenue change over time?

---

## Dataset

The project uses six related tables:

| Table | Description |
|---|---|
| `products` | Product information |
| `website_sessions` | Website session, user, device, and marketing information |
| `website_pageviews` | Website pageview records |
| `orders` | Order-level transaction data |
| `order_items` | Individual products purchased within orders |
| `order_item_refunds` | Refund transactions |

---

## Database Structure

The database relationships are structured around website sessions, orders, products, order items, and refunds.

    website_sessions
           │
           ▼
         orders
           │
           ▼
      order_items
           │
           ├──────────► products
           │
           ▼
    order_item_refunds

The database was validated before analysis to ensure that the main relationships were consistent and that duplicate primary keys were not present.

---

# Key Results

## 1. Overall Business KPIs

| KPI | Result |
|---|---:|
| Total Orders | 32,313 |
| Total Revenue | $1,938,509.75 |
| Total COGS | $722,370.25 |
| Total Profit | $1,216,139.50 |
| Profit Margin | 62.74% |
| Average Order Value | $59.99 |

The business generated approximately **$1.94 million in revenue** and **$1.22 million in profit** across 32,313 orders.

---

## 2. Conversion Rate

| Metric | Result |
|---|---:|
| Total Sessions | 472,871 |
| Total Orders | 32,313 |
| Conversion Rate | 6.83% |

The overall website conversion rate was **6.83%**.

---

## 3. Product Performance

Product-level performance was analyzed using the `order_items` table.

| Product | Revenue | Profit | Revenue Share |
|---|---:|---:|---:|
| The Original Mr. Fuzzy | $1,211,057.74 | $738,893.00 | 62.47% |
| The Forever Love Bear | $347,702.04 | $217,350.00 | 17.94% |
| The Birthday Sugar Panda | $229,260.15 | $157,027.50 | 11.83% |
| The Hudson River Mini bear | $150,489.82 | $102,869.00 | 7.76% |

The Original Mr. Fuzzy generated the largest share of product revenue, accounting for **62.47%** of analyzed product revenue.

---

## 4. Marketing Channel Performance

Marketing performance was analyzed by grouping website sessions according to their acquisition source.

| Marketing Channel | Sessions | Orders | Conversion Rate | Revenue | AOV |
|---|---:|---:|---:|---:|---:|
| gsearch | 316,035 | 21,333 | 6.75% | $1,276,144.89 | $59.82 |
| Direct / Unknown | 83,328 | 6,118 | 7.34% | $371,433.03 | $60.71 |
| bsearch | 62,823 | 4,519 | 7.19% | $268,672.50 | $59.45 |
| socialbook | 10,685 | 343 | 3.21% | $22,259.33 | $64.90 |

gsearch generated the largest number of sessions, orders, and revenue among the analyzed marketing channels.

---

## 5. Device Performance

Website performance was segmented by device type.

| Device | Sessions | Orders | Conversion Rate | Revenue |
|---|---:|---:|---:|---:|
| Desktop | 327,027 | 27,805 | 8.50% | $1,665,757.84 |
| Mobile | 145,844 | 4,508 | 3.09% | $272,751.91 |

Desktop sessions generated more orders and revenue than mobile sessions.

The conversion rate was **8.50% for desktop** compared with **3.09% for mobile**.

---

## 6. Descriptive Statistics

Descriptive statistics were calculated for order value, COGS, profit, and items purchased.

| Metric | Mean | Standard Deviation | Variance |
|---|---:|---:|---:|
| Order Value | $59.99 | $17.81 | 317.14 |
| COGS | $22.36 | $6.24 | 38.92 |
| Profit | $37.64 | $11.75 | 137.97 |
| Items Purchased | 1.24 | 0.43 | 0.18 |

The average order contained approximately **1.24 items**.

The standard deviation of order value was **$17.81**, showing variation around the average order value.

---

## 7. Median Analysis

Median values were calculated to provide a measure of central tendency that is less affected by unusually high or low observations.

| Metric | Median |
|---|---:|
| Order Value | $49.99 |
| COGS | $19.49 |
| Profit | $30.50 |
| Items Purchased | 1 |

The median order value of **$49.99** was lower than the mean order value of **$59.99**.

---

## 8. Refund Analysis

Refund activity was analyzed using the `order_item_refunds` table.

| Refund Metric | Result |
|---|---:|
| Total Refund Transactions | 1,731 |
| Orders with Refunds | 1,723 |
| Total Refund Amount | $85,338.69 |
| Refund Order Rate | 5.33% |
| Refund Amount / Revenue | ~4.40% |

Approximately **5.33% of orders** were associated with a refund.

The total refunded amount was approximately **$85.34K**.

---

## 9. Advanced Product Ranking

An advanced product ranking analysis was performed using SQL window functions.

Products were ranked according to revenue and their contribution to total product revenue.

| Rank | Product | Revenue Share |
|---:|---|---:|
| 1 | The Original Mr. Fuzzy | 62.47% |
| 2 | The Forever Love Bear | 17.94% |
| 3 | The Birthday Sugar Panda | 11.83% |
| 4 | The Hudson River Mini bear | 7.76% |

The results show that product revenue is highly concentrated, with the top-ranked product generating more than 60% of analyzed product revenue.

---

## 10. Monthly Revenue Growth

Monthly revenue and order activity were analyzed using a CTE and the `LAG()` window function to compare each month with the previous month.

Example results from the monthly analysis:

| Month | Orders | Revenue | Revenue Growth |
|---|---:|---:|---:|
| 2012-03 | 60 | $2,999.40 | -- |
| 2012-04 | 99 | $4,949.01 | 65.00% |
| 2012-05 | 108 | $5,398.92 | 9.09% |
| 2012-06 | 140 | $6,998.60 | 29.63% |
| 2012-07 | 169 | $8,448.31 | 20.71% |
| 2012-08 | 228 | $11,397.72 | 34.91% |
| 2012-09 | 287 | $14,347.13 | 25.88% |
| 2012-10 | 371 | $18,546.29 | 29.27% |
| 2012-11 | 618 | $30,893.82 | 66.58% |

The monthly analysis demonstrates substantial changes in revenue and order volume over time and provides a basis for identifying periods of faster or slower growth.

---

## 11. New vs Repeat Sessions

Website sessions were segmented into new and repeat sessions.

| Session Type | Sessions | Orders | Conversion Rate | Revenue | AOV |
|---|---:|---:|---:|---:|---:|
| New Session | 394,318 | 26,164 | 6.64% | $1,566,274.92 | $59.86 |
| Repeat Session | 78,553 | 6,149 | 7.83% | $372,234.83 | $60.54 |

Repeat sessions had a higher conversion rate than new sessions:

**7.83% vs. 6.64%**

The average order values were relatively close between the two groups.

---

# Data Validation

Before performing the business analysis, the database was validated.

The validation included:

- Primary key uniqueness checks
- Foreign key relationship checks
- Order-to-session relationship validation
- Order-item-to-order relationship validation
- Order-item-to-product relationship validation
- Refund-to-order-item relationship validation
- Refund-to-order relationship validation

All relationship validation checks returned **0 invalid records**, and duplicate primary key checks also returned **0 duplicates**.

---

# SQL Techniques Used

The project applies a range of SQL techniques, including:

- `SELECT`
- `WHERE`
- `GROUP BY`
- `ORDER BY`
- Aggregate functions
- `COUNT()`
- `SUM()`
- `AVG()`
- `MIN()`
- `MAX()`
- `ROUND()`
- `CASE WHEN`
- `COALESCE()`
- `JOIN`
- `LEFT JOIN`
- Common Table Expressions (`WITH`)
- Subqueries
- Window functions
- `ROW_NUMBER()`
- `RANK()`
- `LAG()`
- Conditional aggregation
- Descriptive statistical calculations

---

# Key Business Insights

Based on the SQL analysis:

1. The business generated **$1.94M in revenue** and **$1.22M in profit**.
2. The overall website conversion rate was **6.83%**.
3. The average order value was **$59.99**.
4. The Original Mr. Fuzzy generated **62.47% of analyzed product revenue**.
5. gsearch generated the largest amount of traffic, orders, and revenue among the analyzed marketing channels.
6. Desktop sessions had a higher conversion rate than mobile sessions (**8.50% vs. 3.09%**).
7. The median order value (**$49.99**) was lower than the mean order value (**$59.99**).
8. There were **1,731 refund transactions** across **1,723 orders**, with a total refund amount of **$85,338.69**.
9. Repeat sessions had a higher conversion rate than new sessions (**7.83% vs. 6.64%**).
10. Product revenue was highly concentrated, with the top product generating more than 60% of analyzed product revenue.
11. Monthly analysis showed substantial changes in revenue and order volume throughout the available time period.

---

# SQL Skills Demonstrated

This project demonstrates practical SQL skills for business analytics, including:

- Relational database analysis
- Data validation
- Multi-table joins
- Aggregations
- Business KPI calculation
- Exploratory Data Analysis
- Descriptive statistics
- Segmentation
- CTEs
- Subqueries
- Window functions
- Ranking
- Time-based analysis
- Revenue growth analysis
- Refund analysis
- Conversion analysis

---

# Tools

- MySQL
- DBeaver
- GitHub

---

# Project Structure

    business-analytics-sql/
    │
    ├── README.md
    │
    └── business_analytics-6.sql

The SQL file contains the database setup, data validation, exploratory analysis, business KPIs, segmentation, descriptive statistics, refund analysis, product ranking, monthly growth analysis, and session analysis.

---

# Conclusion

This project demonstrates how SQL can be used to transform raw e-commerce data into structured business insights.

The analysis covers the complete workflow from database creation and validation to exploratory analysis, KPI calculation, segmentation, descriptive statistics, refund analysis, product ranking, and time-based analysis.

The project demonstrates practical SQL skills for business analytics and provides a practical example of how relational business data can be transformed into measurable business insights using SQL.
