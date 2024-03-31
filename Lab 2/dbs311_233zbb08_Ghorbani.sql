-- *************************
-- Name: Aydin Ghorbani
-- ID: 124170226
-- Date: 10/4/23
-- Purpose: Lab 02 DBS311
-- *************************

-- 1. For each job title, display the number of employees
SELECT job_title, COUNT(*) as employee_count
FROM DBS211_EMPLOYEES.EMPLOYEES
GROUP BY job_title;

-- 2. Calculate high, low, avg, and difference of credit limits for customers
SELECT
  MAX(credit_limit) AS High,
  MIN(credit_limit) AS Low,
  ROUND(AVG(credit_limit), 2) AS Avg,
  ROUND((MAX(credit_limit) - MIN(credit_limit)), 2) AS Difference
FROM DBS211_CUSTOMERS.CUSTOMERS;

-- 3. Display total order amount for each order and filter by amount > 1000
SELECT
  order_id,
  SUM(order_amount) AS total_order_amount
FROM DBS211_ORDERS.ORDERS
GROUP BY order_id
HAVING SUM(order_amount) > 1000;

-- 4. Count the total number of products in each warehouse
SELECT
  w.warehouse_id,
  w.warehouse_name,
  COUNT(p.product_id) AS total_products
FROM DBS211_WAREHOUSES.WAREHOUSES w
LEFT JOIN DBS211_PRODUCTS.PRODUCTS p ON w.warehouse_id = p.warehouse_id
GROUP BY w.warehouse_id, w.warehouse_name;

-- 5. Count the total number of orders for each customer
SELECT
  c.customer_id,
  COALESCE(COUNT(o.order_id), 0) AS total_orders
FROM DBS211_CUSTOMERS.CUSTOMERS c
LEFT JOIN DBS211_ORDERS.ORDERS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- 6. Calculate total and average sale amount for each sales category
SELECT
  category,
  SUM(sale_amount) AS total_sale_amount,
  ROUND(AVG(sale_amount), 2) AS avg_sale_amount
FROM DBS211_SALES.SALES
GROUP BY category;
