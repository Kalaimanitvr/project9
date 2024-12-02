-- Task 1
-- 1: Find the top 10 customers by credit limit
SELECT customerName, creditLimit
FROM customers
ORDER BY creditLimit DESC
LIMIT 10;
-- Interpretation: This data shows the top 10 customer by credit limit

-- 2: Find the average credit limit for customers in each country
SELECT country, AVG(creditLimit) AS averageCreditLimit
FROM customers
GROUP BY country;
-- Interpretation: this data shows the average credit limit for customer in each country
-- 3: Find the number of customers in each state 
SELECT state, COUNT(*) AS numberOfCustomers
FROM customers
GROUP BY state;
-- Interpretation: this data shows the number of customer in each state
-- 4: Find the customers who haven't placed any orders
SELECT customerName
FROM customers
WHERE customerNumber NOT IN (SELECT customerNumber FROM orders);
-- Interpretation: this data shows the customer who haven't placed any orders
-- 5: Calculate total sales for each customer
SELECT customers.customerName, SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS totalSales
FROM customers
JOIN orders ON customers.customerNumber = orders.customerNumber
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
GROUP BY customers.customerName;
-- Interpretation: this data shows the total sales for each customer
-- 6: List customers with their assigned sales representatives
SELECT customers.customerName, employees.firstName AS salesRepFirstName, employees.lastName AS salesRepLastName
FROM customers
JOIN employees ON customers.salesRepEmployeeNumber = employees.employeeNumber;
-- Interpretation: this data shows the List customers with their assigned sales representatives
-- 7: Retrieve customer information with their most recent payment details
SELECT customers.customerName, payments.paymentDate, payments.amount
FROM customers
JOIN payments ON customers.customerNumber = payments.customerNumber
WHERE (payments.customerNumber, payments.paymentDate) IN (
    SELECT customerNumber, MAX(paymentDate)
    FROM payments
    GROUP BY customerNumber
);
-- Interpretation: this data shows the customer information with their most recent payment details
-- 8: Identify the customers who have exceeded their credit limit
SELECT customers.customerName, customers.creditLimit, SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS totalSpent
FROM customers
JOIN orders ON customers.customerNumber = orders.customerNumber
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
GROUP BY customers.customerName, customers.creditLimit
HAVING totalSpent > customers.creditLimit;
-- Interpretation: this data shows the customers who have exceeded their credit limit
-- 9: Find the names of all customers who have placed an order for a product from a specific product line
SELECT DISTINCT customers.customerName
FROM customers
JOIN orders ON customers.customerNumber = orders.customerNumber
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
JOIN products ON orderdetails.productCode = products.productCode
WHERE products.productLine = 'Classic Cars';  -- Replace 'Classic Cars' with the desired product line
-- Interpretation: this data shows the names of all customers who have placed an order for a product from a specific product line
-- 10: Find the names of all customers who have placed an order for the most expensive product
SELECT DISTINCT customers.customerName
FROM customers
JOIN orders ON customers.customerNumber = orders.customerNumber
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
JOIN products ON orderdetails.productCode = products.productCode
WHERE products.buyPrice = (SELECT MAX(buyPrice) FROM products);
-- Interpretation: the names of all customers who have placed an order for the most expensive product

-- Task 2

-- 1: Count the number of employees working in each office

SELECT officeCode, COUNT(employeeNumber) AS numberOfEmployees
FROM employees
GROUP BY officeCode;
-- interpretation : This task helps identify the distribution of employees across different offices

-- 2: Identify the offices with less than a certain number of employees (e.g., less than 5)

SELECT officeCode, COUNT(employeeNumber) AS numberOfEmployees
FROM employees
GROUP BY officeCode
HAVING numberOfEmployees <5;
-- interpretation: This list offices have less than 5 employees
-- 3: List offices along with their assigned territories

SELECT officeCode, territory
FROM offices;
-- Interpretation: List offices along with their assigned territories
-- 4: Find the offices that have no employees assigned to them  
SELECT officeCode
FROM offices
WHERE officeCode NOT IN (SELECT DISTINCT officeCode FROM employees);
-- 5: Retrieve the most profitable office based on total sales
SELECT e.officeCode, SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN orders o ON c.customerNumber = o.customerNumber
JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY e.officeCode
ORDER BY totalSales DESC
LIMIT 1;
-- Interpretation: the most profitable office based on total sales
-- 6: Find the office with the highest number of employees

SELECT officeCode, COUNT(employeeNumber) AS numberOfEmployees
FROM employees
GROUP BY officeCode
ORDER BY numberOfEmployees DESC
LIMIT 1;
-- Interpretation: office with the highest number of employees
-- 7: Find the average credit limit for customers in each office

SELECT e.officeCode, AVG(c.creditLimit) AS avgCreditLimit
FROM employees e
JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY e.officeCode;
-- Interpretation: average credit limit for customers in each office
-- 8: Find the number of offices in each country

SELECT country, COUNT(officeCode) AS numberOfOffices
FROM offices
GROUP BY country;
-- Interpretation: number of offices in each country
-----------------------------------------------------------------------------------------------------------------
-- Task:3

-- 1: Count the number of products in each product line

SELECT productLine, COUNT(*) AS numberOfProducts
FROM products
GROUP BY productLine;
-- Interpretation: This query helps determine the variety and distribution of products within each product line, highlighting the most and least diverse product lines.

-- 2: Find the product line with the highest average product price

SELECT productLine, AVG(MSRP) AS averagePrice
FROM products
GROUP BY productLine
ORDER BY averagePrice DESC
LIMIT 1;
-- Interpretation: Identifying the product line with the highest average MSRP can indicate which product line is positioned as the premium range within the company's offerings.

-- 3: Find all products with a price between 50 and 100

SELECT productCode, productName, MSRP
FROM products
WHERE MSRP BETWEEN 50 AND 100;
-- Interpretation: This query lists products within a specific price range, useful for targeted marketing and promotions for mid-range priced items.

-- 4: Find the total sales amount for each product line

SELECT p.productLine, SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productLine;
-- Interpretation: Understanding total sales by product line helps identify which lines generate the most revenue, informing inventory and marketing strategies.

-- 5: Identify products with low inventory levels (less than 10 in stock)

SELECT productCode, productName, quantityInStock
FROM products
WHERE quantityInStock < 10;
-- Interpretation: This query highlights products at risk of stockouts, essential for inventory management and reordering processes.

-- 6: Retrieve the most expensive product based on MSRP

SELECT productCode, productName, MSRP
FROM products
ORDER BY MSRP DESC
LIMIT 1;
-- Interpretation: Finding the most expensive product provides insights into the highest value item offered, useful for premium product marketing and positioning.

-- 7: Calculate total sales for each product

SELECT p.productCode, p.productName, SUM(od.quantityOrdered * od.priceEach) AS totalSales
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY p.productCode, p.productName;
-- Interpretation: Total sales per product helps in identifying the best and worst-performing products, aiding in product line decisions.

-- 8: Identify the top selling products based on total quantity ordered using a stored procedure

DELIMITER //

CREATE PROCEDURE GetTopSellingProducts(IN topN INT)
BEGIN
    SELECT p.productCode, p.productName, SUM(od.quantityOrdered) AS totalQuantity
    FROM products p
    JOIN orderdetails od ON p.productCode = od.productCode
    GROUP BY p.productCode, p.productName
    ORDER BY totalQuantity DESC
    LIMIT topN;
END //

DELIMITER ;
-- Interpretation: This procedure allows dynamic retrieval of top-selling products based on specified input, making it flexible for various reporting needs.

-- 9: Retrieve products with low inventory levels within specific product lines

SELECT productCode, productName, quantityInStock
FROM products
WHERE quantityInStock < 10 AND productLine IN ('Classic Cars', 'Motorcycles');
-- Interpretation: Identifying low stock within key product lines helps ensure popular categories like 'Classic Cars' and 'Motorcycles' remain well-stocked.

-- 10: Find the names of all products that have been ordered by more than 10 customers

SELECT p.productCode, p.productName
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
JOIN orders o ON od.orderNumber = o.orderNumber
JOIN customers c ON o.customerNumber = c.customerNumber
GROUP BY p.productCode, p.productName
HAVING COUNT(DISTINCT c.customerNumber) > 10;
-- Interpretation: This query identifies products with broad customer appeal, indicating strong market demand and potential for increased production.

-- 11: Find the names of all products that have been ordered more than the average number of orders for their product line

SELECT p.productCode, p.productName
FROM products p
JOIN orderdetails od ON p.productCode = od.productCode
JOIN (
    SELECT productLine, AVG(orderCount) AS avgOrders
    FROM (
        SELECT productLine, COUNT(*) AS orderCount
        FROM products p
        JOIN orderdetails od ON p.productCode = od.productCode
        GROUP BY p.productLine, p.productCode
    ) AS productOrders
    GROUP BY productLine
) AS avgProductOrders ON p.productLine = avgProductOrders.productLine
GROUP BY p.productCode, p.productName, avgProductOrders.avgOrders
HAVING COUNT(od.orderNumber) > avgProductOrders.avgOrders;
-- Interpretation: This query highlights products performing better than their product line average, useful for identifying potential star products.