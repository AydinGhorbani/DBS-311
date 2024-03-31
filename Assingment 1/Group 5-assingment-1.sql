-- ***********************
-- Name: Aydin Ghorbani ID: 124170226
-- SANIHA ZAIB YOUSUFF ID: 161917216
-- Date: oct/12
-- Purpose: Assignment 1 - DBS311-- 


-- Question 1
-- Display the employee number, full employee name, job title, and hire date of all employees hired in April with the oldest employees displayed last.
SELECT
    employee_id AS employee_number,
    first_name || ' ' || last_name AS full_employee_name,
    job_title,
    hire_date
FROM
    employees
WHERE
    TO_CHAR(hire_date, 'MM') = '04'
ORDER BY
    hire_date;

-- Question 2
-- The company wants to see the total sales amount per salesperson for all orders. Assume that online orders do not have any sales representative. For online orders (orders with no salesman ID), consider the salesman ID as 0. Display the salesman ID and the total sale amount for each employee. Sort the result according to employee number.

SELECT
    COALESCE(salesman_id, 0) AS salesman_id,
    SUM(order_items.unit_price * order_items.quantity) AS total_sale_amount
FROM
    orders
LEFT JOIN
    order_items ON orders.order_id = order_items.order_id
GROUP BY
    COALESCE(salesman_id, 0)
ORDER BY
    salesman_id;
    
-- Question 3
-- Display customer ID, customer name, and the total number of orders for customers whose name falls alphabetically between 'Q' and 'S'. Include customers with no orders in the report if their customer ID falls in the specified alphabetical range. Sort the result by the value of the total orders.

SELECT
    customers.CUSTOMER_ID AS CustId,
    customers.NAME AS Name,
    COALESCE(COUNT(orders.ORDER_ID), 0) AS TotalOrders
FROM
    customers
LEFT JOIN
    orders ON customers.CUSTOMER_ID = orders.CUSTOMER_ID
WHERE
    customers.NAME >= 'Q' AND customers.NAME < 'S'
GROUP BY
    customers.CUSTOMER_ID, customers.NAME
ORDER BY
    TotalOrders;

-- Question 4
-- Display customer ID, customer name, order ID, and order date for all orders of a customer with ID 47 and a total order amount less than $1,000,000. Additionally, show the total quantity and the total amount of each customer's order. Sort the result from the most recent order to the oldest order.

SELECT
    customers.customer_id,
    customers.name AS customer_name,
    order_items.order_id,
    orders.order_date,
    SUM(order_items.quantity) AS total_quantity,
    SUM(order_items.unit_price * order_items.quantity) AS total_amount
FROM
    customers
JOIN
    orders ON customers.customer_id = orders.customer_id
JOIN
    order_items ON orders.order_id = order_items.order_id
WHERE
    customers.customer_id = 47
GROUP BY
    customers.customer_id, customers.name, order_items.order_id, orders.order_date
HAVING
    SUM(order_items.unit_price * order_items.quantity) < 1000000
ORDER BY
    orders.order_date DESC;

-- Question 5
-- Display customer ID, customer name, total number of orders, the total number of items ordered, and the total order amount for customers who have more than 30 orders. Sort the result based on the total value of orders.

SELECT
    cust.customer_id,
    cust.name,
    COUNT(ord.order_id) AS "TotalOrders",
    SUM(oi.quantity) AS "TotalItemsOrdered",
    SUM(oi.quantity * oi.unit_price) AS "TotalAmount"
FROM
    customers cust
JOIN
    orders ord ON cust.customer_id = ord.customer_id
JOIN
    order_items oi ON ord.order_id = oi.order_id
GROUP BY
    cust.customer_id, cust.name
HAVING
    COUNT(ord.order_id) > 30
ORDER BY
    "TotalOrders" ASC;


-- Question 6
-- Display Warehouse ID, warehouse name, product category ID, product category name, and the lowest product standard cost for this combination. Include the rows where the lowest standard cost is less than $200 or more than $500. Sort the output by Warehouse ID, warehouse name, product category ID, and product category name.

SELECT
   w.warehouse_id,
   warehouse_name,
   p.category_id,
   category_name,
   MIN(standard_cost) AS lowest_cost 
FROM
   inventories i 
   JOIN
      warehouses w 
      ON i.warehouse_id = w.warehouse_id 
   JOIN
      products p 
      ON i.product_id = p.product_id 
   JOIN
      product_categories pc 
      ON p.category_id = pc.category_id 
GROUP BY
   w.warehouse_id,
   warehouse_name,
   p.category_id,
   category_name 
HAVING
   MIN(standard_cost) < 200 
   OR MIN(standard_cost) > 500 
ORDER BY
   w.warehouse_id,
   warehouse_name,
   p.category_id,
   category_name;
   
   
-- Question 7
-- Display the total number of orders per month, sorted from January to December.

SELECT
    w.warehouse_id AS "Warehouse Id",
    w.warehouse_name AS "Warehouse Name",
    pc.category_id AS "Product Category Id",
    pc.category_name AS "Product Category Name",
    MIN(p.standard_cost) AS "Lowest Product Standard Cost"
FROM
    inventories i
JOIN
    warehouses w ON i.warehouse_id = w.warehouse_id
JOIN
    products p ON i.product_id = p.product_id
JOIN
    product_categories pc ON p.category_id = pc.category_id
GROUP BY
    w.warehouse_id, w.warehouse_name, pc.category_id, pc.category_name
HAVING
    MIN(p.standard_cost) < 200 OR MIN(p.standard_cost) > 500
ORDER BY
    "Warehouse Id", "Warehouse Name", "Product Category Id", "Product Category Name";



-- Question 8
-- Display product ID and product name for products with a list price higher than the highest product standard cost per warehouse outside the Americas regions. Sort the result by list price from highest value to the lowest.

SELECT TO_CHAR(order_date, 'Month') AS "month",
COUNT(*) AS "orders"
FROM orders
GROUP BY TO_CHAR(order_date, 'Month')
ORDER BY TO_DATE(TO_CHAR(order_date, 'Month'), 'Month');


-- Question 9
-- Write a SQL statement to display the most expensive and the cheapest product (list price). Display product ID, product name, and the list price.

SELECT
    p.product_id AS "Product ID",
    p.product_name AS "Product Name",
    TO_CHAR(p.list_price, '$999,999,999.99') AS "Price"
FROM
    products p
WHERE
    p.list_price > ANY(
        SELECT
            MAX(p2.standard_cost)
        FROM
            products p2
            JOIN inventories i ON p2.product_id = i.product_id
            JOIN warehouses w ON i.warehouse_id = w.warehouse_id
            JOIN locations l ON w.location_id = l.location_id
            JOIN countries c ON l.country_id = c.country_id
            JOIN regions r ON c.region_id = r.region_id
        WHERE
            LOWER(r.region_name) != 'americas'
        GROUP BY
            w.warehouse_id
    )
ORDER BY
    "Price" DESC;


-- Query 10: Customer Purchase Summary
-- Calculate statistics related to customer purchases and generate a comprehensive report.

-- Count of customers with total purchase amount exceeding the average
SELECT 'Number of customers with orders under fifty thousand dollars ' || 
  COUNT(CASE WHEN o.total_order_amount > p.avg_order_amount THEN 1 END) AS "Customer Report"
FROM
  (SELECT od.customer_id, COALESCE(SUM(oi.QUANTITY * oi.UNIT_PRICE), 0) AS total_order_amount
   FROM orders od
   LEFT JOIN order_items oi ON od.ORDER_ID = oi.ORDER_ID
   GROUP BY od.customer_id) o
CROSS JOIN
  (SELECT AVG(oi.QUANTITY * oi.UNIT_PRICE) AS avg_order_amount
   FROM order_items oi) p

UNION ALL

-- Count of customers with total purchase amount below the average
SELECT 'Number of customers with orders over one million dollars ' || 
  COUNT(CASE WHEN o.total_order_amount < p.avg_order_amount THEN 1 END) AS "Customer Report"
FROM
  (SELECT od.customer_id, COALESCE(SUM(oi.QUANTITY * oi.UNIT_PRICE), 0) AS total_order_amount
   FROM orders od
   LEFT JOIN order_items oi ON od.ORDER_ID = oi.ORDER_ID
   GROUP BY od.customer_id) o
CROSS JOIN
  (SELECT AVG(oi.QUANTITY * oi.UNIT_PRICE) AS avg_order_amount
   FROM order_items oi) p

UNION ALL

-- Count of customers with no orders
SELECT 'Number of customers without orders: ' || COUNT(CASE WHEN od.order_id IS NULL THEN 1 END) AS "Customer Report"
FROM customers c
LEFT JOIN orders od ON c.customer_id = od.customer_id
WHERE od.order_id IS NULL

UNION ALL

-- Total number of customers
SELECT '4 Total number of customers: ' || COUNT(DISTINCT c.customer_id) AS "Customer Report"
FROM customers c;
