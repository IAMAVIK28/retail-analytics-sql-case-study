# retail-analytics-sql-case-study
A retail analytics project analyzing product performance, customer segmentation, and purchasing behavior using SQL.

#  Retail Analytics SQL Case Study

##  Project Overview
This project focuses on analyzing retail store data to uncover actionable business insights regarding **product performance variability**, **customer segmentation**, and **purchasing behavior**. By leveraging SQL queries, the project addresses stagnant growth and optimizes inventory and marketing decisions.

---

##  Datasets Used
* **`customer_profiles-1.csv`**: Contains customer demographics (CustomerID, Age, Gender, Location, JoinDate).
* **`product_inventory-1.csv`**: Contains product information (ProductID, ProductName, Category, StockLevel, Price).
* **`sales_transaction-1.csv`**: Contains order and transaction metrics (TransactionID, CustomerID, ProductID, QuantityPurchased, TransactionDate, Price).

---

1: Data Cleaning & Exploratory Data Analysis (EDA)
-- Before jumping into the business metrics, we check for missing values, duplicates, 
-- or data integrity issues across our tables:


SELECT COUNT(*) AS MissingPrices 
FROM product_inventory 
WHERE Price IS NULL;

SELECT 'Customers' AS TableName, COUNT(*) AS TotalRows FROM customer_profiles
UNION ALL
SELECT 'Products', COUNT(*) FROM product_inventory
UNION ALL
SELECT 'Sales', COUNT(*) FROM sales_transaction;



 2: Customer Segmentation 
    Segmented customers based on their total purchase quantities into categories (`No Orders`, `Low`, `Mid`, `High Value`).

SELECT 
    c.CustomerID,
    COALESCE(SUM(s.QuantityPurchased), 0) AS TotalQuantity,
    CASE 
        WHEN COALESCE(SUM(s.QuantityPurchased), 0) = 0 THEN 'No Orders'
        WHEN COALESCE(SUM(s.QuantityPurchased), 0) BETWEEN 1 AND 10 THEN 'Low'
        WHEN COALESCE(SUM(s.QuantityPurchased), 0) > 10 AND COALESCE(SUM(s.QuantityPurchased), 0) <= 30 THEN 'Mid'
        ELSE 'High Value'
    END AS CustomerSegment
FROM customer_profiles c
LEFT JOIN sales_transaction s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID;

3: Identify High and Low Sales Products.
  This query calculates total units sold and revenue for each product to find top performers and laggards:

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

4: Customer Behavior & Repeat Purchases (Loyalty Analysis)To analyze repeat customer behavior 
   and identify loyal buyers based on frequency of transactions:   

SELECT 
    CustomerID,
    COUNT(TransactionID) AS TotalTransactions,
    SUM(QuantityPurchased) AS TotalItemsBought,
    ROUND(SUM(QuantityPurchased * Price), 2) AS TotalSpent
FROM sales_transaction
GROUP BY CustomerID
HAVING COUNT(TransactionID) > 1
ORDER BY TotalTransactions DESC;




