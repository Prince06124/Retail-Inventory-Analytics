-- RETAIL INVENTORY & SALES ANALYTICS PROJECT
-- Tools Used:
-- Python (Pandas), SQL Server, Power BI

use retail_shop
select * from retail_store_inventory_ready

--1. Total Revenue
select sum(units_sold * price) as Total_revenue from retail_store_inventory_ready 

--2. Total Units Sold
select sum(units_sold) as Total_units_sold from retail_store_inventory_ready

--3. Inventory Turnover Ratio
select (CAST(sum(units_sold) as Decimal(18,2))/CAST(AVG(inventory_level) as Decimal(10,2))) as Inventory_turnover_ratio 
from retail_store_inventory_ready

--4. Stock Coverage Days
select date , (CAST(sum(inventory_level) as Decimal(10,2))/CAST(avg(units_sold)as Decimal(10,2)))
as stock_coverage_days from retail_store_inventory_ready group by date order by date DESC

--5. Forecast Accuracy
select 
product_id , 
(1 - ABS(CAST(sum(demand_forecast) as DECIMAL(18,2)) - CAST(sum(units_sold) as DECIMAL(18,2))) /
NULLIF(CAST(sum(demand_forecast)as DECIMAL(18,2)),0)) * 100 as forecast_accuracy
from retail_store_inventory_ready
group by product_id
order by product_id DESC

--6. Out-of-Stock Risk Products
select product_id , (CAST(sum(inventory_level) as DECIMAL(18,2)) - CAST(sum(demand_forecast) as DECIMAL(18,2))) as inventory_gap 
from retail_store_inventory_ready where inventory_level < demand_forecast 
group by product_id
order by inventory_gap DESC

--7. Overstocked Products
select product_id , (CAST(sum(inventory_level) as DECIMAL(18,2)) - CAST(sum(demand_forecast) as DECIMAL(18,2))) as excess_inventory
from retail_store_inventory_ready where inventory_level > (demand_forecast * 2) 
group by product_id
order by excess_inventory DESC

--8. Sales by Category
select category , sum(units_sold) as sales_by_category
from retail_store_inventory_ready group by category order by sales_by_category DESC

--9. Sales by Region
select region , sum(units_sold) as region_wise_sales
from retail_store_inventory_ready group by region order by region_wise_sales DESC

--10. Promotion Impact Analysis
SELECT 
    holiday_promotion,
    SUM(units_sold) AS total_units_sold,
    ROUND(AVG(units_sold),2) AS avg_units_sold
FROM retail_store_inventory_ready
GROUP BY holiday_promotion;

--11. Discount vs Sales Correlation
--only to explain the relation using scatter plot no values to calculate
SELECT 
    discount,
    units_sold
FROM retail_store_inventory_ready;

--12. Seasonal Demand Analysis
SELECT 
    seasonality,
    SUM(units_sold) AS seasonal_units_sold,
    ROUND(AVG(units_sold),2) AS avg_units_sold,
    ROUND(SUM(units_sold * price),2) AS total_revenue
FROM retail_store_inventory_ready
GROUP BY seasonality
ORDER BY seasonal_units_sold DESC;

--13. Weather Impact on Sales
SELECT 
    weather_condition,
    SUM(units_sold) AS total_units_sold,
    ROUND(AVG(units_sold),2) AS avg_units_sold,
    ROUND(SUM(units_sold * price),2) AS total_revenue
FROM retail_store_inventory_ready
GROUP BY weather_condition
ORDER BY total_revenue DESC;

--14. Top Performing Products
SELECT TOP 10
    product_id,
    SUM(units_sold) AS total_sales
FROM retail_store_inventory_ready
GROUP BY product_id
ORDER BY total_sales DESC;

--15. Low Performing Products
SELECT TOP 10
    product_id,
    SUM(units_sold) AS total_sales
FROM retail_store_inventory_ready
GROUP BY product_id
ORDER BY total_sales ASC;

--vw_sales_analysis
CREATE VIEW vw_sales_analysis AS
SELECT 
    category,
    region,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(units_sold * price),2) AS total_revenue,
    ROUND(AVG(units_sold),2) AS avg_units_sold,
    ROUND(AVG(inventory_level),2) AS avg_inventory_level
FROM retail_store_inventory_ready
GROUP BY category,region;
select * from vw_sales_analysis

--vw_inventory_analysis
CREATE VIEW vw_inventory_analysis AS
SELECT 
    SUM(inventory_level) AS total_inventory_stock,
    SUM(units_ordered) AS total_ordered_units,
    ROUND(SUM(demand_forecast),2) AS total_forecast,
    ROUND(SUM(inventory_level) - SUM(demand_forecast),2) AS inventory_gap
FROM retail_store_inventory_ready;
select * from vw_inventory_analysis;

--vw_executive_summary
CREATE VIEW vw_executive_summary AS
SELECT 
    store_id,
    SUM(units_ordered) AS total_ordered_units,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(units_sold * price),2) AS total_revenue
FROM retail_store_inventory_ready
GROUP BY store_id;
SELECT * FROM vw_executive_summary


ALTER VIEW vw_executive_summary AS
SELECT 
    SUM(units_sold) AS total_units_sold,

    ROUND(SUM(units_sold * price),2) AS total_revenue,

    CAST(
        (
            1 - ABS(
                SUM(demand_forecast) - SUM(units_sold)
            ) / NULLIF(SUM(demand_forecast),0)
        )
        AS DECIMAL(18,4)) AS forecast_accuracy,

    ROUND(
        CAST(SUM(units_sold) AS DECIMAL(18,2)) /
        NULLIF(CAST(AVG(inventory_level) AS DECIMAL(18,2)),0),
    2) AS inventory_turnover_ratio

FROM retail_store_inventory_ready;


--vw_revenue_trend
CREATE VIEW vw_revenue_trend AS
SELECT 
    MONTH(date) AS sales_month,
    YEAR(date) AS sales_year,
    DATENAME(MONTH, date) AS month_name,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(units_sold * price),2) AS total_revenue,
    ROUND(AVG(units_sold * price),2) AS avg_transaction_revenue
FROM retail_store_inventory_ready
GROUP BY MONTH(date) , YEAR(date) , DATENAME(MONTH, date);
SELECT * FROM vw_revenue_trend;

--vw_overstock_analysis
CREATE VIEW vw_overstock_analysis AS
SELECT 
     product_id ,
     category,
     SUM(inventory_level) as total_stock,
     (CAST(sum(inventory_level) AS DECIMAL(18,2)) - 
     CAST(sum(demand_forecast) AS DECIMAL(18,2))) as excess_inventory
FROM retail_store_inventory_ready 
WHERE inventory_level > (demand_forecast * 2) 
GROUP BY product_id, category;
SELECT * FROM vw_overstock_analysis

--vw_stockout_risk
CREATE VIEW vw_stockout_risk AS
SELECT 
     product_id ,
     category,
     SUM(inventory_level) as total_stock,
     (CAST(sum(demand_forecast) as DECIMAL(18,2))
     - CAST(sum(inventory_level) as DECIMAL(18,2))) as lack_of_inventory
FROM retail_store_inventory_ready 
WHERE inventory_level < demand_forecast
GROUP BY product_id,category;
SELECT * FROM vw_stockout_risk

--vw_inventory_by_category
CREATE VIEW vw_inventory_by_category AS
SELECT 
    category,
    SUM(inventory_level) AS total_inventory_stock,
    SUM(units_ordered) AS total_ordered_units,
    ROUND(SUM(demand_forecast),2) AS total_forecast,
    ROUND(SUM(inventory_level) - SUM(demand_forecast),2) AS inventory_gap
FROM retail_store_inventory_ready
GROUP BY category
SELECT * FROM vw_inventory_by_category

--vw_promotion_analysis
CREATE VIEW vw_promotion_analysis AS
SELECT 
     holiday_promotion,
     SUM(units_sold) AS total_units_sold,
     ROUND(AVG(units_sold),2) AS avg_units_sold
FROM retail_store_inventory_ready
GROUP BY holiday_promotion
SELECT * FROM vw_promotion_analysis

--vw_weather_analysis
CREATE VIEW vw_weather_analysis AS
SELECT 
     weather_condition,
     SUM(units_sold) AS total_units_sold,
     ROUND(AVG(units_sold),2) AS avg_units_sold,
     ROUND(SUM(units_sold * price),2) AS total_revenue
FROM retail_store_inventory_ready
GROUP BY weather_condition
SELECT * FROM vw_weather_analysis

--vw_seasonal_analysis
CREATE VIEW vw_seasonal_analysis AS
SELECT 
     seasonality,
     SUM(units_sold) AS seasonal_units_sold,
     ROUND(AVG(units_sold),2) AS avg_units_sold,
     ROUND(SUM(units_sold * price),2) AS total_revenue
FROM retail_store_inventory_ready
GROUP BY seasonality
SELECT * FROM vw_seasonal_analysis

--vw_discount_analysis
CREATE VIEW vw_discount_analysis AS
SELECT 
     discount,
     SUM(units_sold) AS total_units_sold,
     ROUND(AVG(units_sold),2) AS avg_units_sold,
     ROUND(SUM(units_sold * price),2) AS total_revenue
FROM retail_store_inventory_ready
GROUP BY discount
SELECT * FROM vw_discount_analysis

--vw_product_performance
CREATE VIEW vw_product_performance AS
SELECT 
     product_id,
     SUM(units_sold) AS total_units_sold,
     ROUND(AVG(units_sold),2) AS avg_units_sold,
     ROUND(SUM(units_sold * price),2) AS total_revenue
FROM retail_store_inventory_ready
GROUP BY product_id
SELECT * FROM vw_product_performance ORDER BY total_units_sold DESC

--vw_forecast_analysis
CREATE VIEW vw_forecast_analysis AS
SELECT 
     product_id , 
     SUM(units_ordered) AS total_ordered_units,
     ROUND(SUM(demand_forecast),2) AS total_forecast,
     (1 - ABS(CAST(sum(demand_forecast) as DECIMAL(18,2)) - 
     CAST(sum(units_sold) as DECIMAL(18,2))) /
     NULLIF(CAST(sum(demand_forecast)as DECIMAL(18,2)),0)) * 100 as forecast_accuracy
FROM retail_store_inventory_ready
GROUP BY product_id
SELECT * FROM vw_forecast_analysis

select count(distinct product_id) from retail_store_inventory_ready