# Advanced Querying
*Common Table Expressions (CTEs)*

```sql
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    total_amount DECIMAL(10,2)
);

CREATE TABLE merch (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50),
    price INT
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES merch(product_id),
    quantity INT
);

INSERT INTO customers (name) VALUES
('K'), ('Fuma'), ('Nicholas'), ('EJ');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-01-10', 150.00),
(1, '2023-12-20', 90.00),
(2, '2024-02-05', 200.00),
(3, '2023-11-15', 50.00);

INSERT INTO merch (product_name, price) VALUES
('T-Shirt', 30),
('Hoodie', 50),
('Cap', 20);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(3, 1, 1);

WITH participant_orders AS (
    SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.name
)
SELECT * FROM participant_orders WHERE total_spent > 100;

WITH product_sales AS (
    SELECT 
        m.product_id,
        m.product_name,
        SUM(oi.quantity * m.price) AS total_sales
    FROM merch m
    INNER JOIN order_items oi ON m.product_id = oi.product_id
    GROUP BY m.product_id, m.product_name
)
SELECT *
FROM product_sales
WHERE total_sales >= 50;
```
```csv
"product_id"	"product_name"	"total_sales"
2	            "Hoodie"	       50
1	            "T-Shirt"	       90
```
*Recursive Queries*

```sql
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    mentor_id INT REFERENCES employees(employee_id)
);

INSERT INTO employees (name, mentor_id) VALUES
('K', NULL),
('Fuma', 1),
('Nicholas', 1),
('EJ', 2),
('Yuma', 2),
('Jo', 3),
('Harua', 3),
('Taki', 4),
('Maki', 5);

WITH RECURSIVE org_chart AS (
    SELECT employee_id, name, mentor_id
    FROM employees
    WHERE mentor_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.name, e.mentor_id
    FROM employees e
    INNER JOIN org_chart oc ON e.mentor_id = oc.employee_id
)
SELECT * FROM org_chart;

CREATE TABLE warehouse_1 (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50),
    quantity INT
);

CREATE TABLE warehouse_2 (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50),
    quantity INT
);

INSERT INTO warehouse_1 (product_name, quantity) VALUES
('T-Shirt', 10),
('Hoodie', 0),
('Cap', 5);

INSERT INTO warehouse_2 (product_name, quantity) VALUES
('T-Shirt', 8),
('Hoodie', 0),
('Sneakers', 12);

SELECT product_name FROM warehouse_1
UNION
SELECT product_name FROM warehouse_2;
```
```csv
"product_name"
"Hoodie"
"T-Shirt"
"Cap"
"Sneakers"
```
```sql
SELECT product_id FROM warehouse_1 WHERE quantity = 0
INTERSECT
SELECT product_id FROM warehouse_2 WHERE quantity = 0;
```
```csv
"product_id"
2
```
*Window Functions & Partitioning*
```sql
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary INT
);

INSERT INTO employees (name, department, salary) VALUES
('K', 'Engineering', 90000),
('Fuma', 'Engineering', 90000),
('Nicholas', 'Engineering', 75000),
('EJ', 'Sales', 70000),
('Yuma', 'Sales', 70000),
('Jo', 'Marketing', 60000),
('Harua', 'Marketing', 62000),
('Taki', 'Sales', 72000),
('Maki', 'Engineering', 95000);

SELECT
    name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_rank
FROM employees;
```
```csv
"name"       "department"    "salary"   "dept_salary_rank"
"Maki"       "Engineering"   95000      1
"Fuma"       "Engineering"   90000      2
"K"          "Engineering"   90000      2
"Nicholas"   "Engineering"   75000      4
"Harua"      "Marketing"     62000      1
"Jo"         "Marketing"     60000      2
"Taki"       "Sales"         72000      1
"EJ"         "Sales"         70000      2
"Yuma"       "Sales"         70000      2
```
//-- присваивает одинаковый ранг сотрудникам с одинаковой зарплатой.

```sql
SELECT
    name,
    department,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_row_number
FROM employees;
```

```csv
"name"       "department"    "salary"   "dept_salary_row_number"
"Maki"       "Engineering"   95000      1
"Fuma"       "Engineering"   90000      2
"K"          "Engineering"   90000      3
"Nicholas"   "Engineering"   75000      4
"Harua"      "Marketing"     62000      1
"Jo"         "Marketing"     60000      2
"Taki"       "Sales"         72000      1
"EJ"         "Sales"         70000      2
"Yuma"       "Sales"         70000      3 
```
//-- без учёта одинаковых значений, уникальный номер.

*Pivot and Unpivot Operations*

```sql
SELECT
    name,
    department,
    salary,
    SUM(salary) OVER (PARTITION BY department) AS dept_total_salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM employees;
```

```csv
"name"       "department"    "salary"   "dept_total_salary"   "dept_avg_salary"
"K"          "Engineering"   90000      350000               87500.000000000000
"Fuma"       "Engineering"   90000      350000               87500.000000000000
"Nicholas"   "Engineering"   75000      350000               87500.000000000000
"Maki"       "Engineering"   95000      350000               87500.000000000000
"Jo"         "Marketing"     60000      122000               61000.000000000000
"Harua"      "Marketing"     62000      122000               61000.000000000000
"Yuma"       "Sales"         70000      212000               70666.666666666667
"Taki"       "Sales"         72000      212000               70666.666666666667
"EJ"         "Sales"         70000      212000               70666.666666666667
```

```sql
SELECT
    name,
    department,
    salary,
    LAG(salary, 1) OVER (PARTITION BY department ORDER BY salary) AS previous_salary,
    LEAD(salary, 1) OVER (PARTITION BY department ORDER BY salary) AS next_salary
FROM employees;
```

```csv
"name"       "department"    "salary"   "previous_salary"   "next_salary"
"Nicholas"   "Engineering"   75000      ""                 90000
"K"          "Engineering"   90000      75000              90000
"Fuma"       "Engineering"   90000      90000              95000
"Maki"       "Engineering"   95000      90000              ""
"Jo"         "Marketing"     60000      ""                 62000
"Harua"      "Marketing"     62000      60000              ""
"Yuma"       "Sales"         70000      ""                 70000
"EJ"         "Sales"         70000      70000              72000
"Taki"       "Sales"         72000      70000              ""
```

*Pivot and Unpivot Operations*

```sql
DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
    product_name VARCHAR(50),
    year INT,
    sales_amount INT
);

INSERT INTO sales (product_name, year, sales_amount) VALUES
('T-Shirt', 2022, 100),
('T-Shirt', 2023, 150),
('T-Shirt', 2024, 200),
('Hoodie', 2022, 80),
('Hoodie', 2023, 120),
('Hoodie', 2024, 140),
('Cap', 2022, 50),
('Cap', 2023, 70),
('Cap', 2024, 90);

SELECT
    product_name,
    SUM(CASE WHEN year = 2022 THEN sales_amount ELSE 0 END) AS year_2022,
    SUM(CASE WHEN year = 2023 THEN sales_amount ELSE 0 END) AS year_2023,
    SUM(CASE WHEN year = 2024 THEN sales_amount ELSE 0 END) AS year_2024
FROM sales
GROUP BY product_name;
```
```csv
"product_name"   "year_2022"   "year_2023"   "year_2024"
"Hoodie"         80            120           140
"T-Shirt"        100           150           200
"Cap"            50            70            90
```
```sql
SELECT product_name, '2022' AS year, SUM(CASE WHEN year = 2022 THEN sales_amount ELSE 0 END) AS sales_amount FROM sales GROUP BY product_name
UNION ALL
SELECT product_name, '2023' AS year, SUM(CASE WHEN year = 2023 THEN sales_amount ELSE 0 END) AS sales_amount FROM sales GROUP BY product_name
UNION ALL
SELECT product_name, '2024' AS year, SUM(CASE WHEN year = 2024 THEN sales_amount ELSE 0 END) AS sales_amount FROM sales GROUP BY product_name
ORDER BY product_name, year;
```
```csv
"product_name"	"year"	"sales_amount"
"Cap"	        "2022"	50
"Cap"	        "2023"	70
"Cap"	        "2024"	90
"Hoodie"	    "2022"	80
"Hoodie"	    "2023"	120
"Hoodie"	    "2024"	140
"T-Shirt"	    "2022"	100
"T-Shirt"	    "2023"	150
"T-Shirt"	    "2024"	200
```
*Complex Filtering and Sorting*

```sql
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary INT,
    tenure INT
);

INSERT INTO employees (name, department, salary, tenure) VALUES
('K', 'Engineering', 90000, 6),
('Fuma', 'Engineering', 85000, 4),
('Nicholas', 'Engineering', 75000, 2),
('EJ', 'Sales', 70000, 7),
('Yuma', 'Sales', 65000, 3),
('Jo', 'Marketing', 60000, 5),
('Harua', 'Marketing', 62000, 6),
('Taki', 'Sales', 72000, 8),
('Maki', 'Engineering', 95000, 10);

SELECT
    employee_id,
    name,
    department,
    salary,
    SUM(salary) OVER (PARTITION BY department) AS total_dept_salary,
    AVG(salary) FILTER (WHERE tenure > 5) OVER () AS avg_salary_senior
FROM employees;
```
```csv
"employee_id"   "name"       "department"    "salary"   "total_dept_salary"   "avg_salary_senior"
1               "K"          "Engineering"   90000      345000               77800.000000000000
2               "Fuma"       "Engineering"   85000      345000               77800.000000000000
3               "Nicholas"   "Engineering"   75000      345000               77800.000000000000
9               "Maki"       "Engineering"   95000      345000               77800.000000000000
6               "Jo"         "Marketing"     60000      122000               77800.000000000000
7               "Harua"      "Marketing"     62000      122000               77800.000000000000
5               "Yuma"       "Sales"         65000      207000               77800.000000000000
8               "Taki"       "Sales"         72000      207000               77800.000000000000
4               "EJ"         "Sales"         70000      207000               77800.000000000000

```

```sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50),
    status VARCHAR(20)
);

INSERT INTO orders (product_name, status) VALUES
('T-Shirt', 'High Priority'),
('Hoodie', 'Medium Priority'),
('Cap', 'Low Priority'),
('Sneakers', 'Medium Priority');

SELECT product_name, status
FROM orders
ORDER BY
    CASE status
        WHEN 'High Priority' THEN 1
        WHEN 'Medium Priority' THEN 2
        WHEN 'Low Priority' THEN 3
        ELSE 4
    END;
```

```csv
"product_name"	"status"
"T-Shirt"	    "High Priority"
"Hoodie"	    "Medium Priority"
"Sneakers"	    "Medium Priority"
"Cap"	        "Low Priority"
```






