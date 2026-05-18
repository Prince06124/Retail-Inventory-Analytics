# Retail Inventory Analytics Dashboard

End-to-end data analyst portfolio project built with **Python (Pandas)**, **SQL Server**, and **Power BI**.

## Project summary

This project analyzes retail inventory movement across stores, products, categories, regions, seasonality, weather, promotions, and pricing.  
The workflow is:

1. **Raw data cleaning in Python** using Pandas  
2. **SQL analysis in SQL Server Management Studio** for KPIs and reusable views  
3. **Dashboarding in Power BI** for executive reporting and decision-making

## Dataset overview

- Rows: **73,100**
- Columns: **15**
- Date range: **2022-01-01 to 2024-01-01**
- Stores: **5**
- Products: **20**
- Categories: **5**
- Regions: **4**

## Key business metrics

- Total revenue: **550,228,884.91**
- Total units sold: **9,975,582**
- Inventory turnover ratio: **36,344.91**
- Forecast accuracy: **96.45%**

## Data quality notes

- The original notebook called `drop_duplicates()` without assignment, so duplicates were not actually removed.
- The dataset contains **673 rows** with negative demand forecast values.
- The dataset contains **360 rows** with zero units sold.

These points are important to mention in the project write-up because they show real data-quality awareness.

## Workflow

### 1. Python / Pandas
- Load the raw CSV
- Convert `Date` to datetime
- Check schema, missing values, duplicates, and summary statistics
- Export a cleaned CSV

### 2. SQL Server
Created KPI queries and views such as:
- `vw_sales_analysis`
- `vw_inventory_analysis`
- `vw_executive_summary`
- `vw_revenue_trend`
- `vw_overstock_analysis`
- `vw_stockout_risk`
- `vw_inventory_by_category`
- `vw_promotion_analysis`
- `vw_weather_analysis`
- `vw_seasonal_analysis`
- `vw_discount_analysis`
- `vw_product_performance`
- `vw_forecast_analysis`

### 3. Power BI
Report pages in the PBIX:
- Executive Overview
- Inventory Analytics
- Demand & Customer Analytics
- Product Performance

### 3. Dashboard View
### Executive Overview
![Overview]("[Dashboard Images/Executive Overview.png](https://github.com/Prince06124/Retail-Inventory-Analytics/blob/main/Dashboard%20Images/Executive%20Overview.png)")

### Inventory Analytics
![Inventory]("[H:\Inventory project\Retail-Inventory-Analytics\Dashboard Images\Inventory Analytics.png](https://github.com/Prince06124/Retail-Inventory-Analytics/blob/main/Dashboard%20Images/Inventory%20Analytics.png)")

### Demand & Customer Analytics
![Demand]("H:\Inventory project\Retail-Inventory-Analytics\Dashboard Images\Demand & Customer Analytics.png")

### Product Performance
![Product]("H:\Inventory project\Retail-Inventory-Analytics\Dashboard Images\Product Performance.png")

## Suggested README structure for GitHub

### Repository contents
- `Project-2_Rewritten.ipynb` — cleaned and explained EDA notebook
- `SQLQuery1(1).sql` — SQL KPI and view script
- `Inventory shop(3).pbix` — Power BI report
- `retail_store_inventory(1).csv` — raw dataset
- `retail_store_inventory_ready(1).csv` — cleaned dataset

### How to run
1. Open the notebook in Jupyter Lab
2. Update the CSV path if you rename files
3. Run all cells
4. Load the cleaned CSV into SQL Server
5. Run the SQL script
6. Open the PBIX file in Power BI Desktop

## Stronger project narrative for interviews

A strong one-line summary:

> Built an end-to-end retail inventory analytics pipeline by cleaning raw data in Python, modeling KPIs in SQL Server, and presenting business insights in Power BI.

## Improvement opportunities

To make the project even stronger:
- add actual printed outputs or screenshots from the notebook
- include one or two custom DAX measures in the README
- add brief explanation for each Power BI page
- mention the exact business objective in the first section of the notebook

## File notes

This repository can be presented as a portfolio-ready analytics project once the rewritten notebook and README are added.
