-- ***********************
-- Name: Aydin Ghorbani
-- ID: 124170226
-- Date: 02/02/23
-- Purpose: Lab 5 DBS311
-- ***********************
---- Question 1
CREATE OR REPLACE PROCEDURE check_even_odd(num IN NUMBER) AS
BEGIN
  IF MOD(num, 2) = 0 THEN
    DBMS_OUTPUT.PUT_LINE('The number is even.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('The number is odd.');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error!');
END check_even_odd;

---- Question 2
CREATE OR REPLACE PROCEDURE find_employee(p_employee_id IN NUMBER) AS
  v_first_name employees.first_name%TYPE;
  v_last_name employees.last_name%TYPE;
  v_email employees.email%TYPE;
  v_phone employees.phone%TYPE;
  v_hire_date employees.hire_date%TYPE;
  v_job_title employees.job_title%TYPE;

BEGIN
  SELECT first_name, last_name, email, phone, hire_date, job_title
  INTO v_first_name, v_last_name, v_email, v_phone, v_hire_date, v_job_title
  FROM employees
  WHERE employee_id = p_employee_id;

  DBMS_OUTPUT.PUT_LINE('First name: ' || v_first_name);
  DBMS_OUTPUT.PUT_LINE('Last name: ' || v_last_name);
  DBMS_OUTPUT.PUT_LINE('Email: ' || v_email);
  DBMS_OUTPUT.PUT_LINE('Phone: ' || v_phone);
  DBMS_OUTPUT.PUT_LINE('Hire date: ' || TO_CHAR(v_hire_date, 'DD-MON-YY'));
  DBMS_OUTPUT.PUT_LINE('Job title: ' || v_job_title);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Employee not found.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;


-- Question 3 

CREATE OR REPLACE PROCEDURE update_price_by_cat(p_category_id IN NUMBER, p_amount IN NUMBER) AS
    rows_updated NUMBER;
BEGIN
    UPDATE products
    SET list_price = list_price + p_amount
    WHERE category_id = p_category_id
    AND list_price > 0;

    rows_updated := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Number of rows updated: ' || rows_updated);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error!');
END update_price_by_cat;

-- Question 4

CREATE OR REPLACE PROCEDURE update_price_under_avg AS
    v_avg_price NUMBER(9,2);
    rows_updated NUMBER;
BEGIN
    SELECT AVG(list_price) INTO v_avg_price FROM products;

    UPDATE products
    SET list_price = CASE
        WHEN v_avg_price <= 1000 THEN list_price * 1.02
        ELSE list_price * 1.01
    END
    WHERE list_price < v_avg_price;

    rows_updated := SQL%ROWCOUNT;
    DBMS_OUTPUT.PUT_LINE('Number of rows updated: ' || rows_updated);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error!');
END update_price_under_avg;

-- Question 5 

CREATE OR REPLACE PROCEDURE product_price_report AS
    v_avg_price NUMBER(9,2);
    v_min_price NUMBER(9,2);
    v_max_price NUMBER(9,2);
    cheap_count NUMBER;
    fair_count NUMBER;
    exp_count NUMBER;
BEGIN
    SELECT AVG(list_price), MIN(list_price), MAX(list_price)
    INTO v_avg_price, v_min_price, v_max_price
    FROM products;

    SELECT COUNT(*) INTO cheap_count
    FROM products
    WHERE list_price < (v_avg_price - v_min_price) / 2;

    SELECT COUNT(*) INTO exp_count
    FROM products
    WHERE list_price > (v_max_price - v_avg_price) / 2;

    SELECT COUNT(*) INTO fair_count
    FROM products
    WHERE list_price >= (v_avg_price - v_min_price) / 2
    AND list_price <= (v_max_price - v_avg_price) / 2;

    DBMS_OUTPUT.PUT_LINE('Cheap: ' || cheap_count);
    DBMS_OUTPUT.PUT_LINE('Fair: ' || fair_count);
    DBMS_OUTPUT.PUT_LINE('Expensive: ' || exp_count);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error!');
END product_price_report;


