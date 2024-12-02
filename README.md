# 📊 SQL Data Analysis: Business Insights for Customer and Sales Management

## 🌟 Quick Access Links
Explore the project details using these resources:
- 📓 **[SQL Script 1](./sprint%209%20project.sql)**: Queries for customer, sales, and product line analysis.
- 📓 **[SQL Script 2](./sprint%2010%20project.sql)**: Advanced queries, triggers, and business-focused insights.
- 📊 **[PDF Presentation](./Sprint_9_and_10_Project_Presentation.pdf)**: Summary of key findings and query results.

---

## 📜 Project Introduction
This project uses SQL to analyze customer, sales, and product data to derive actionable business insights. By writing and executing advanced SQL queries, the project focuses on:
- Understanding customer behavior and credit limits.
- Analyzing sales trends and revenue patterns.
- Exploring product performance and shipping efficiency.

As a **data analyst**, this project emphasizes:
- Data-driven decision-making using SQL queries.
- Efficient database management with triggers and insights.
- A structured approach to solving business problems.

---

## 🎯 Objectives
### Key Goals
1. **Customer Behavior Analysis**:
   - Identify top customers by credit limits and sales.
   - Highlight customers without orders to target for re-engagement.

2. **Sales and Revenue Trends**:
   - Analyze monthly sales trends and identify top-performing orders.
   - Explore delayed shipments to improve operational efficiency.

3. **Product and Inventory Insights**:
   - Assess product performance and popular combinations.
   - Summarize product line distribution for inventory optimization.

4. **Automation and Triggers**:
   - Create triggers to automate credit limit updates and log product quantity changes.

---

## 🛠️ Methodology
### Data Analysis Process
1. **Customer Insights**:
   - Query for top 10 customers by credit limit:
     ```sql
     SELECT customerName, creditLimit
     FROM customers
     ORDER BY creditLimit DESC
     LIMIT 10;
     ```
     **Interpretation**: Identifies high-value customers for priority engagement.

   - Query for customers without orders:
     ```sql
     SELECT customerName
     FROM customers
     WHERE customerNumber NOT IN (SELECT customerNumber FROM orders);
     ```
     **Interpretation**: Targets inactive customers for reactivation campaigns.

2. **Sales Analysis**:
   - Query for monthly sales revenue:
     ```sql
     SELECT DATE_FORMAT(orderDate, '%Y-%m') AS month, 
            SUM(orderdetails.quantityOrdered * orderdetails.priceEach) AS totalRevenue
     FROM orders
     JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
     GROUP BY month;
     ```
     **Interpretation**: Provides insights into sales trends to plan seasonal promotions.

   - Query for the top 10 most profitable orders:
     ```sql
     SELECT o.orderNumber, SUM(od.quantityOrdered * od.priceEach) AS totalRevenue
     FROM orders o
     JOIN orderdetails od ON o.orderNumber = od.orderNumber
     GROUP BY o.orderNumber
     ORDER BY totalRevenue DESC
     LIMIT 10;
     ```
     **Interpretation**: Highlights high-revenue orders for benchmarking and replication.

3. **Product and Inventory Insights**:
   - Query for product sales summary:
     ```sql
     SELECT products.productName, 
            SUM(orderdetails.quantityOrdered) AS totalQuantitySold
     FROM products
     JOIN orderdetails ON products.productCode = orderdetails.productCode
     GROUP BY products.productName;
     ```
     **Interpretation**: Analyzes product sales performance to optimize inventory.

   - Query for popular product combinations:
     ```sql
     SELECT od1.productCode AS product1, od2.productCode AS product2, 
            COUNT(*) AS combinationCount
     FROM orderdetails od1
     JOIN orderdetails od2 ON od1.orderNumber = od2.orderNumber 
            AND od1.productCode < od2.productCode
     GROUP BY product1, product2
     ORDER BY combinationCount DESC;
     ```
     **Interpretation**: Identifies frequently purchased product pairs to improve bundling strategies.

4. **Automation with Triggers**:
   - Trigger to update customer credit limit after new orders:
     ```sql
     CREATE TRIGGER update_credit_limit AFTER INSERT ON orders
     FOR EACH ROW
     BEGIN
         UPDATE customers
         SET creditLimit = creditLimit - NEW.orderTotal
         WHERE customerNumber = NEW.customerNumber;
     END;
     ```
     **Interpretation**: Automates credit limit adjustments, enhancing operational efficiency.

   - Trigger to log product quantity changes:
     ```sql
     CREATE TRIGGER log_quantity_changes AFTER INSERT OR UPDATE ON orderdetails
     FOR EACH ROW
     BEGIN
         INSERT INTO product_quantity_log (orderNumber, productCode, oldQuantity, newQuantity, changeDate)
         VALUES (NEW.orderNumber, NEW.productCode, OLD.quantityOrdered, NEW.quantityOrdered, NOW());
     END;
     ```
     **Interpretation**: Tracks changes in product quantities for better inventory management.

---

## 📈 Key Insights and Highlights
- **Customer Behavior**:
  - Top customers by credit limit and sales drive significant revenue.
  - Customers without orders represent untapped opportunities for growth.

- **Sales Trends**:
  - Monthly revenue trends reveal peak sales periods, enabling seasonal marketing strategies.
  - High-revenue orders provide benchmarks for sales strategies.

- **Product Performance**:
  - Popular product combinations offer opportunities for bundling.
  - Product line distribution highlights areas for inventory adjustments.

- **Operational Efficiency**:
  - Triggers streamline operations, ensuring accurate credit management and inventory tracking.

---

## 🏁 Conclusion
This project demonstrates how SQL can provide **critical business insights** to improve customer engagement, sales strategies, and operational efficiency.

### Key Takeaways:
- **Customer Focus**:
  - Engage high-value customers and re-target inactive ones.
- **Revenue Growth**:
  - Leverage monthly and product-level sales trends for planning.
- **Operational Enhancements**:
  - Automate routine processes with triggers to save time and reduce errors.

### Business Impact:
These insights enable businesses to:
1. Enhance customer relationship management (CRM).
2. Improve sales performance with data-driven strategies.
3. Optimize inventory and streamline operations.

---
