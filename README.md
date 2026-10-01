# Business Analytics Using SQL

## Project Overview

This project analyzes an e-commerce business dataset using SQL to extract
business insights from website sessions, pageviews, orders, products,
order items, and refunds.

The main objective is to understand business performance, customer behavior,
marketing channels, product performance, profitability, and refund activity
using SQL-based exploratory and advanced analysis.

---

## Business Questions

The analysis focuses on the following questions:

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
- Which products contribute the largest share of revenue?
- How does monthly revenue grow over time?

---

## Dataset

The project uses six related tables:

| Table | Description |
|---|---|
| `products` | Product information |
| `website_sessions` | Website session and marketing information |
| `website_pageviews` | Website pageview records |
| `orders` | Order-level transaction data |
| `order_items` | Individual products purchased within orders |
| `order_item_refunds` | Refund transactions |

---

## Database Structure

The database relationships are structured around website sessions,
orders, products, order items, and refunds.

Main relationships:

```text
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
