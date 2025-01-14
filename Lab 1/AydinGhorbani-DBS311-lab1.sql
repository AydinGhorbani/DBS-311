-- *************************
-- Name: Aydin Ghorbani
-- ID: 124170226
-- Date: 9/28
-- Purpose: Lab 01 DBS311
-- *************************

-- Question 1 – Display tomorrow's date
-- Q1: Write a query to display tomorrow's date in the following format: 
-- January 10th of year 2019 the result will depend on the day when you RUN/EXECUTE this query. 
-- Label the column “Tomorrow”.
-- Advanced Option: Define an SQL variable called “tomorrow”, assign it a value of tomorrow’s date, use it in an SQL statement.

SELECT TO_CHAR(SYSDATE + 1, 'Month DDth "of year" YYYY') AS Tomorrow
FROM dual;

-- Question 2 – Calculate new list prices
-- Q2: For each product in category 2, 3, and 5, show product ID, product name, list price, and the new list price increased by 2%. Display a new list price as a whole number.
-- In your result, add a calculated column to show the difference of old and new list prices.

SELECT 
    product_id,
    product_name,
    list_price,
    ROUND(list_price * 1.02) AS new_list_price,
    ROUND(list_price * 1.02 - list_price) AS price_difference
FROM products
WHERE category_id IN (2, 3, 5);

-- Question 3 – Display employee information
-- Q3: For employees whose manager ID is 2, write a query that displays the employee’s Full Name and Job Title in the following format: SUMMER, PAYNE is Public Accountant.

SELECT 
    CONCAT(last_name, ', ', first_name) AS Full_Name,
    job_title
FROM employees
WHERE manager_id = 2;

-- Question 4 – Calculate years worked
-- Q4: For each employee hired before October 2016, display the employee’s last name, hire date and calculate the number of YEARS between TODAY and the date the employee was hired.
-- Label the column Years worked. Order your results by the number of years employed. Round the number of years employed up to the closest whole number.

SELECT 
    last_name,
    hire_date,
    CEIL(MONTHS_BETWEEN(SYSDATE, hire_date) / 12) AS Years_Worked
FROM employees
WHERE hire_date < TO_DATE('2016-10-01', 'YYYY-MM-DD')
ORDER BY Years_Worked;

-- Question 5 – Calculate review date
-- Q5: Display each employee’s last name, hire date, and the review date, which is the first Tuesday after a year of service, but only for those hired after 2016.
-- Label the column REVIEW DAY. Format the dates to appear in the format like: TUESDAY, August the Thirty-First of year 2016. Sort by review date.

SELECT 
    last_name,
    hire_date,
    TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 12), 'TUESDAY'), 'FMDAY, MONTH "the "DDth "of year" YYYY') AS REVIEW_DAY
FROM employees
WHERE hire_date >= TO_DATE('2016-01-01', 'YYYY-MM-DD')
ORDER BY REVIEW_DAY;

-- Question 6 – Display warehouse information
-- Q6: for all warehouses, display warehouse id, warehouse name, city, and state. For warehouses with the null value for the state column, display unknown.

SELECT 
    warehouse_id,
    warehouse_name,
    city,
    NVL(state, 'unknown') AS state
FROM warehouses;
