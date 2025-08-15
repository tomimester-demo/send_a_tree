# Send-A-Tree 📦🌳  
*Descriptive Analytics Project — Junior Data Analyst Role*

## Overview  
Send-A-Tree is a **hypothetical startup** with a delightfully simple mission:  
> Let users send pictures of trees to their friends — and for those who want to go premium — send *super-trees*.  

This repository contains the scripts and SQL queries I developed while working as a **junior data analyst** for the project. The goal: use **data-driven analysis** to answer the CEO’s big question — *will people actually pay to send a digital super-tree?*

---

## Business Context  
- **Product**: Online application with one core feature — send digital trees.  
- **Monetization**:  
  - First *super-tree* is free.  
  - All additional *super-trees* cost $1.  
- **Growth to date**:  
  - 5 months of tracked data.  
  - Registrations grew from **~100/day** to **~1,800/day**.  
  - Tree sends grew from **~300/day** to **~16,000/day**.  

The analysis in this project is designed to determine if the business is headed in the right direction and whether premium engagement is sustainable.

---

## Repository Contents  

### 1. `send-a-tree.sql`  
SQL queries for:
- **Data Discovery**
  - Registrations by source.
  - Activity by source.
  - Micro-segmentation by device, location, and source.
- **Revenue Analysis**
  - Total revenue by source.
  - Daily revenue changes.
- **Funnel Analysis**
  - Conversion tracking from registrations → free users → super users → paying users.
- **Looker Dashboard Prep**
  - KPI table creation for daily active users.

### 2. `automation.sh`  
A Bash automation script that:
1. Downloads and stores daily logs.  
2. Splits log files into **registrations**, **free tree sends**, and **super tree sends**.  
3. Loads these into PostgreSQL tables (`registrations`, `free_tree`, `super_tree`) for analysis.

---

## Data Flow Diagram  

logs (.csv)
↓
automation.sh
↓
PostgreSQL tables:
registrations
free_tree
super_tree
↓
send-a-tree.sql
↓
Aggregations, KPIs, funnel metrics
↓
Looker Dashboard


---

## Getting Started  

### Prerequisites  
- **PostgreSQL** installed and running.  
- A valid `$DATABASE_URL` or local DB credentials.  
- Access to raw log files (in `/home/tomi/logs` or update paths in `automation.sh`).  

### Running the Pipeline  
```bash
# Step 1: Make automation script executable
chmod +x automation.sh

# Step 2: Run automation to download & process logs
./automation.sh

# Step 3: Execute SQL analysis
psql -U <username> -d <dbname> -f send-a-tree.sql
```
---

## Example Analyses

- **Daily Active Users (DAU)**  
  Track changes in unique senders of free and super-trees.

- **Revenue by Source**  
  Compare monetization effectiveness across acquisition channels.

- **Funnel Drop-off**  
  See where users drop between registration → free → premium → paying.

---

## Disclaimer

This project is **entirely fictional**. Any resemblance to actual companies, products, or individuals is purely coincidental. The data is synthetic and used for **educational purposes**.

---

## Author

**Tomi Mester** — Junior Data Analyst  
[Data36.com](https://data36.com)
