-- *************************
-- Name: Aydin Ghorbani
-- ID: 124170226
-- Purpose: Lab 03 DBS311
-- *************************

-- Task 1: Display the last name and hire date of employees hired before employee with ID 107, sorted by hire date.
SELECT last_name, hire_date
FROM employees
WHERE hire_date < (SELECT hire_date FROM employees WHERE employee_id = 107)
ORDER BY hire_date;

-- Task 2: Display customer name and credit limit for customers with the lowest credit limit, sorted by customer name.
SELECT customer_name, credit_limit
FROM customers
WHERE credit_limit = (SELECT MIN(credit_limit) FROM customers)
ORDER BY customer_name;

-- Task 3: Display product ID, product name, and list price of the highest-paid product(s) in each category, sorted by category ID.
SELECT product_id, product_name, list_price
FROM products
WHERE (category_id, list_price) IN (SELECT category_id, MAX(list_price) FROM products GROUP BY category_id)
ORDER BY category_id;

-- Task 4: Display the category name of the most expensive product(s).
SELECT category_name
FROM categories AS c
WHERE category_id = (SELECT category_id FROM c WHERE list_price = (SELECT MAX(list_price) FROM products));

-- Task 5: Display product name and list price for products in category 1 with a list price less than the lowest list price in ANY category, sorted by list price and product name.
SELECT product_name, list_price
FROM products AS p
WHERE category_id = 1
AND list_price < (SELECT MIN(list_price) FROM p)
ORDER BY list_price, product_name;

-- Task 6: Display product ID, product name, and category ID for products of the category(s) that the lowest price product belongs to.
SELECT product_id, product_name, category_id
FROM products AS p
WHERE category_id = (SELECT category_id FROM p WHERE list_price = (SELECT MIN(list_price) FROM p));
