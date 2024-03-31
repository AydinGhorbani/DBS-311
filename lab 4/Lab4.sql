-- ***********************
-- Name: Aydin Ghorbani
-- ID: 124170226
-- Date: 10/19/23
-- Purpose: Lab 4 DBS311
-- ***********************

-- Q1
SELECT city 
FROM locations
MINUS
SELECT city 
FROM warehouses w JOIN locations l
ON w.location_id = l.location_id;

-- Q2
SELECT p.category_id, pc.category_name, COUNT(*) AS product_count
FROM product_categories pc
JOIN products p ON pc.category_id = p.category_id
WHERE p.category_id IN (1, 2, 5)
GROUP BY p.category_id, pc.category_name
ORDER BY p.category_id;

--Q3
SELECT product_id
FROM products
WHERE product_id IN (
    SELECT product_id
    FROM order_items
    WHERE quantity > 5
);

-- Q4
SELECT warehouse_name, state
FROM warehouses w JOIN locations l
ON w.location_id = l.location_id
UNION
SELECT warehouse_name, state
FROM warehouses w RIGHT JOIN locations l
ON w.location_id = l.location_id;