CREATE DATABASE RetailAnalyticsProject;
USE RetailAnalyticsProject;

select * from customer_profiles;
select * from product_inventory;
select * from sales_transaction;

-- Objective 1: Data Cleaning & Exploratory Data Analysis (EDA)
-- Before jumping into the business metrics, we check for missing values, duplicates, 
-- or data integrity issues across our tables:

-- Check for any null or missing product pricing
SELECT COUNT(*) AS MissingPrices 
FROM product_inventory 
WHERE Price IS NULL;

-- Check total counts to ensure data loaded correctly
SELECT 'Customers' AS TableName, COUNT(*) AS TotalRows FROM customer_profiles
UNION ALL
SELECT 'Products', COUNT(*) FROM product_inventory
UNION ALL
SELECT 'Sales', COUNT(*) FROM sales_transaction;

-- Objective 2: Identify High and Low Sales Products.
-- This query calculates total units sold and revenue 
-- for each product to find top performers and laggards: 

 SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    SUM(s.QuantityPurchased) AS TotalUnitsSold,
    ROUND(SUM(s.QuantityPurchased * s.Price), 2) AS TotalRevenue
FROM product_inventory p
LEFT JOIN sales_transaction s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category
ORDER BY TotalUnitsSold DESC;

-- Objective 3: Customer Segmentation (Based on Your Guidelines)This matches the exact segmentation 
-- thresholds from your project instructions (0 = No Orders, 1-10 = Low, 10-30 = Mid, >30 = High Value):   

SELECT 
    c.CustomerID,
    c.Location,
    COALESCE(SUM(s.QuantityPurchased), 0) AS TotalQuantityPurchased,
    CASE 
        WHEN COALESCE(SUM(s.QuantityPurchased), 0) = 0 THEN 'No Orders'
        WHEN COALESCE(SUM(s.QuantityPurchased), 0) BETWEEN 1 AND 10 THEN 'Low'
        WHEN COALESCE(SUM(s.QuantityPurchased), 0) > 10 AND COALESCE(SUM(s.QuantityPurchased), 0) <= 30 THEN 'Mid'
        ELSE 'High Value'
    END AS CustomerSegment
FROM customer_profiles c
LEFT JOIN sales_transaction s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.Location;

-- Objective 4: Customer Behavior & Repeat Purchases (Loyalty Analysis)To analyze repeat customer behavior 
-- and identify loyal buyers based on frequency of transactions:   

SELECT 
    CustomerID,
    COUNT(TransactionID) AS TotalTransactions,
    SUM(QuantityPurchased) AS TotalItemsBought,
    ROUND(SUM(QuantityPurchased * Price), 2) AS TotalSpent
FROM sales_transaction
GROUP BY CustomerID
HAVING COUNT(TransactionID) > 1
ORDER BY TotalTransactions DESC;


