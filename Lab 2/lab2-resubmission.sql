-- *************************
-- Name: Aydin Ghorbani
-- ID: 124170226
-- Date: 10/18/23
-- Purpose: Lab 02 DBS311
-- *************************

-- 1. For each job title, display the number of employees
SELECT job_title, COUNT(*) as employee_count
FROM employees
GROUP BY job_title;

-- 2. Calculate high, low, avg, and difference of credit limits for customers
SELECT
  MAX(credit_limit) AS High,
  MIN(credit_limit) AS Low,
  ROUND(AVG(credit_limit), 2) AS Avg,
  ROUND((MAX(credit_limit) - MIN(credit_limit)), 2) AS Difference
FROM customers;

-- 3. Display total order amount for each order and filter by amount > 1000
SELECT orders.order_id, orders.customer_id, SUM(order_items.unit_price) as total_amount
FROM orders
JOIN order_items ON orders.order_id = order_items.order_id
GROUP BY orders.order_id, orders.customer_id
HAVING SUM(order_items.unit_price) > 1000;


-- 4. Count the total number of products in each warehouse
SELECT  w.warehouse_id , sum(i.quantity) as count
FROM warehouses w JOIN inventories i ON w.warehouse_id = i.warehouse_id
GROUP BY w.warehouse_id
ORDER BY w.warehouse_id;

-- 5. Count the total number of orders for each customer
SELECT c.customer_id, COUNT(o.order_id) AS total
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status != 'canceled'
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- 6. Calculate total and average sale amount for each sales category
SELECT pc.category_id , pc.category_name,
sum(p.list_price) AS total,
ROUND(AVG(p.list_price),2) AS average
from product_categories pc join products p ON p.category_id = pc.category_id
group by pc.category_id, pc.category_name
order by pc.category_id;