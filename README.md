# End-to-End E-Commerce Supply Chain & Profitability Engine

## The Business Problem
An e-commerce network was experiencing severe margin degradation and customer trust erosion due to unseen logistics bottlenecks. The objective of this project was to bypass traditional spreadsheet limitations and engineer a relational database architecture to mathematically isolate the root causes of delivery SLA breaches and freight-cost margin leaks across high-volume categories.

## The Engineering Architecture
This project utilizes a pure database-to-BI pipeline:
* **Data Ingestion:** Bypassed GUI memory bottlenecks by reconfiguring local server permissions to execute bulk `LOAD DATA INFILE` commands, instantly ingesting 110,000+ raw order records into a MySQL relational database.
* **Analytical Engine:** Developed advanced SQL queries utilizing Common Table Expressions (CTEs) and Window Functions to generate categorical risk rankings based on delivery severity and frequency.
* **Executive Visualization:** Connected Power BI directly to the local MySQL port (3306). Engineered custom DAX measures to calculate true operational averages without aggregating pre-summarized data.

## Key Financial Insights
Analyzed a dataset representing **$2.45M** in gross revenue and isolated two critical systemic failures:
1. **The Logistics Failure:** Identified a **6.60% overall SLA breach rate**, pinpointing Home Appliances (`electrodomesticos_2`) as the highest-risk operational bottleneck due to high frequency and severe delay duration.
2. **The Profitability Leak:** Uncovered a severe **24.03% company-wide freight ratio**, identifying seasonal goods (`artigos_de_natal`) bleeding 36.52% of their gross revenue purely to shipping costs. 

## Files in this Repository
* `analytical_engine.sql`: The backend analytical queries (CTEs, Window Functions, Risk Ranking).
* `Executive_Dashboard.pbix`: The two-page Power BI executive summary (Operations Risk Matrix & Margin Leakage).
