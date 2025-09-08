## **Aggregate Functions**

*COUNT() - Counting Rows*

```sql
DROP TABLE employees;
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary INT,
    email VARCHAR(100)
);

INSERT INTO employees (name, department, salary, email) VALUES
('Jeon Jungkook', 'Sales', 60000, 'jungkook@sales.com'),
('Lee Dohyun', 'Engineering', 85000, 'dohyun@eng.com'),
('Park Bogum', 'Sales', 72000, NULL),  -- без email
('Nam Joo Hyuk', 'Engineering', 95000, 'joohyuk@eng.com'),
('Kim Taehyung', 'Marketing', 50000, 'taehyung@marketing.com'),
('Cha Eunwoo', 'Marketing', 55000, NULL), -- без email
('Song Kang', 'Sales', 68000, 'songkang@sales.com');

SELECT COUNT(*) AS total_employees 
FROM employees;
```
```csv
"total_employees"
7
```
```sql
SELECT COUNT(email) AS employees_with_email 
FROM employees;
```
```csv
"employees_with_email"
5
```
```sql
SELECT COUNT(DISTINCT department) AS unique_departments 
FROM employees;
```
```csv
"unique_departments"
3
```
*SUM() - Calculating Totals*
```sql
DROP TABLE employees;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary INT
);

DROP TABLE sales_data;

CREATE TABLE sales_data (
sale_id SERIAL PRIMARY KEY,
department VARCHAR(50),
sales_amount INT
);

INSERT INTO employees (name, department, salary) VALUES
('Jeon Jungkook', 'Sales', 60000),
('Lee Dohyun', 'Engineering', 85000),
('Park Bogum', 'Sales', 72000),
('Nam Joo Hyuk', 'Engineering', 95000),
('Kim Taehyung', 'Marketing', 50000),
('Cha Eunwoo', 'Marketing', 55000),
('Song Kang', 'Sales', 68000);

SELECT SUM(salary) AS total_salaries 
FROM employees;
```
```csv
"total_salaries"
485000
```
```sql
CREATE TABLE sales_data (
sale_id SERIAL PRIMARY KEY,
department VARCHAR(50),
sales_amount INT
);

INSERT INTO sales_data (department, sales_amount) VALUES
('Sales', 10000),
('Sales', 15000),
('Sales', 20000),
('Engineering', 5000),
('Engineering', 8000),
('Marketing', 12000),
('Marketing', 7000);

SELECT department, SUM(salary) AS total_salaries
FROM employees
GROUP BY department;
```
```csv
"department"	"total_sales"
"Marketing"	     19000
"Engineering"	 13000
"Sales"	         45000
```
*AVG() - Calculating Averages*

```sql
DROP TABLE employees;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary INT,
    age INT
);

INSERT INTO employees (name, department, salary, age) VALUES
('Jeon Jungkook', 'Sales', 60000, 26),
('Lee Dohyun', 'Engineering', 85000, 29),
('Park Bogum', 'Sales', 72000, 31),
('Nam Joo Hyuk', 'Engineering', 95000, 30),
('Kim Taehyung', 'Marketing', 50000, 27),
('Cha Eunwoo', 'Marketing', 55000, 26),
('Song Kang', 'Sales', 68000, 28);

SELECT AVG(salary) AS average_salary 
FROM employees;
```
```csv
"average_salary"
69285.714285714286
```
```sql
SELECT department, AVG(age) AS avg_age
FROM employees
GROUP BY department;
```
```csv
"department"	"avg_age"
"Marketing"	     26.5000000000000000
"Engineering"	 29.5000000000000000
"Sales"	         28.3333333333333333
```
*MAX() and MIN() - Finding Extremes*
```sql
DROP TABLE employees;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary INT,
    hire_date DATE
);

INSERT INTO employees (name, department, salary, hire_date) VALUES
('Jeon Jungkook', 'Sales', 60000, '2021-05-10'),
('Lee Dohyun', 'Engineering', 85000, '2020-03-15'),
('Park Bogum', 'Sales', 72000, '2022-07-01'),
('Nam Joo Hyuk', 'Engineering', 95000, '2023-01-20'),
('Kim Taehyung', 'Marketing', 50000, '2021-09-12'),
('Cha Eunwoo', 'Marketing', 55000, '2022-11-05'),
('Song Kang', 'Sales', 68000, '2023-03-25');

SELECT 
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM employees;
```
```csv
"highest_salary"	"lowest_salary"
95000	             50000
```
```sql
SELECT department, MAX(hire_date) AS latest_hire
FROM employees
GROUP BY department;
```
```csv
"department"	"latest_hire"
"Marketing"	     "2022-11-05"
"Engineering"	 "2023-01-20"
"Sales"	         "2023-03-25"
```
### Advanced Aggregate Functions
*STRING_AGG() - Concatenating Strings*
```sql
DROP TABLE employees;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    department VARCHAR(50)
);

INSERT INTO employees (first_name, department) VALUES
('Jungkook', 'Sales'),
('Bogum', 'Sales'),
('Song Kang', 'Sales'),
('Dohyun', 'Engineering'),
('Joo Hyuk', 'Engineering'),
('Taehyung', 'Marketing'),
('Eunwoo', 'Marketing');

SELECT department, STRING_AGG(first_name, ', ') AS employee_names
FROM employees
GROUP BY department;
```
```csv
"department"	"employee_names"
"Marketing"	    "Taehyung, Eunwoo"
"Engineering"	"Dohyun, Joo Hyuk"
"Sales"	        "Jungkook, Bogum, Song Kang"
```
```sql
DROP TABLE IF EXISTS employee_skills;

CREATE TABLE employee_skills (
    skill_id SERIAL PRIMARY KEY,
    employee_id INT,
    skill_name VARCHAR(50)
);

INSERT INTO employee_skills (employee_id, skill_name) VALUES
(1, 'Communication'),
(1, 'Sales Strategy'),
(2, 'Negotiation'),
(3, 'Customer Support'),
(4, 'JS'),
(4, 'Python'),
(5, 'C++'),
(5, 'Project Management'),
(6, 'Marketing Strategy'),
(6, 'Design'),
(7, 'Public Speaking');

SELECT employee_id, STRING_AGG(skill_name, ', ' ORDER BY skill_name) AS skills
FROM employee_skills
GROUP BY employee_id;
```
```csv
"employee_id"	"skills"
1	"Communication, Sales Strategy"
2	"Negotiation"
3	"Customer Support"
4	"JS, Python"
5	"C++, Project Management"
6	"Design, Marketing Strategy"
7	"Public Speaking"
```
*ARRAY_AGG() - Creating Arrays*
```sql
DROP TABLE employees;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary INT
);

INSERT INTO employees (first_name, last_name, department, salary) VALUES
('Jeon', 'Jungkook', 'Sales', 60000),
('Park', 'Bogum', 'Sales', 72000),
('Song', 'Kang', 'Sales', 68000),
('Lee', 'Dohyun', 'Engineering', 85000),
('Nam', 'Joo Hyuk', 'Engineering', 95000),
('Kim', 'Taehyung', 'Marketing', 50000),
('Cha', 'Eunwoo', 'Marketing', 55000);

SELECT department, ARRAY_AGG(salary) AS salary_array
FROM employees
GROUP BY department;
```
```csv
"department"	"salary_array"
"Marketing"	    {50000,55000}
"Engineering"	{85000,95000}
"Sales"	        {60000,72000,68000}
```
```sql
SELECT department, ARRAY_AGG(first_name ORDER BY last_name) AS employees
FROM employees
GROUP BY department;
```
```csv
"department"	"employees"
"Engineering"	"{Lee,Nam}"
"Marketing"	    "{Cha,Kim}"
"Sales"	        "{Park,Jeon,Song}"
```
### Statistical Aggregate Functions
```sql
DROP TABLE employees;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary INT,
    experience_years INT
);

INSERT INTO employees (name, department, salary, experience_years) VALUES
('Jeon Jungkook', 'Sales', 60000, 2),
('Park Bogum', 'Sales', 72000, 4),
('Song Kang', 'Sales', 68000, 3),
('Lee Dohyun', 'Engineering', 85000, 5),
('Nam Joo Hyuk', 'Engineering', 95000, 7),
('Kim Taehyung', 'Marketing', 50000, 1),
('Cha Eunwoo', 'Marketing', 55000, 2);

SELECT 
    department,
    STDDEV(salary) AS salary_std_dev,
    VARIANCE(salary) AS salary_variance
FROM employees
GROUP BY department;
```
```csv
"department"	"salary_std_dev"	"salary_variance"
"Marketing"	     3535.533905932738	 12500000.000000000000
"Engineering"	 7071.067811865475	 50000000.000000000000
"Sales"	         6110.100926607787	 37333333.333333333333
```
```sql
SELECT CORR(experience_years, salary) AS experience_salary_correlation
FROM employees;
```
```csv
"experience_salary_correlation"
0.9881605374578738
```
## Working with GROUP BY
*Basic GROUP BY*
```sql
DROP TABLE products;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price INT
);

INSERT INTO products (product_name, category, price) VALUES
('Notebook', 'Stationery', 25),
('Pen', 'Stationery', 5),
('Eraser', 'Stationery', 3),
('Mouse', 'Electronics', 30),
('Keyboard', 'Electronics', 45),
('Monitor', 'Electronics', 150),
('Desk Lamp', 'Furniture', 60),
('Chair', 'Furniture', 120),
('Table', 'Furniture', 200);

SELECT
    category,
    COUNT(*) AS number_of_products,
    SUM(price) AS total_value,
    AVG(price) AS average_price
FROM products
GROUP BY category;
```
```csv
"category"	  "number_of_products"	"total_value"	"average_price"
"Furniture"	   3	                 380	         126.6666666666666667
"Electronics"  3	                 225	         75.0000000000000000
"Stationery"   3	                 33	             11.0000000000000000
```
*Multiple Column Grouping*
```sql
DROP TABLE sales;

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE,
    amount INT
);

INSERT INTO sales (sale_date, amount) VALUES
('2023-01-10', 500),
('2023-02-15', 700),
('2023-03-20', 300),
('2023-04-05', 450),
('2023-05-18', 600),
('2023-06-25', 800),
('2023-07-10', 750),
('2023-08-14', 900),
('2023-09-22', 400),
('2023-10-05', 650),
('2023-11-12', 850),
('2023-12-20', 1000),
('2024-01-15', 550),
('2024-02-20', 620),
('2024-03-18', 480);

SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(QUARTER FROM sale_date) AS quarter,
    COUNT(*) AS total_sales,
    SUM(amount) AS total_revenue
FROM sales
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(QUARTER FROM sale_date)
ORDER BY year, quarter;
```
```csv
"year"	"quarter"	"total_sales"	"total_revenue"
2023	 1	         3	             1500
2023	 2	         3	             1850
2023	 3	         3	             2050
2023	 4	         3	             2500
2024	 1	         3	             1650
```
## GROUP BY with Expressions
```sql
DROP TABLE employees;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    age INT,
    salary INT
);

INSERT INTO employees (name, department, age, salary) VALUES
('Jeon Jungkook', 'Sales', 26, 60000),
('Park Bogum', 'Sales', 31, 72000),
('Song Kang', 'Sales', 28, 68000),
('Lee Dohyun', 'Engineering', 45, 85000),
('Nam Joo Hyuk', 'Engineering', 52, 95000),
('Kim Taehyung', 'Marketing', 27, 50000),
('Cha Eunwoo', 'Marketing', 38, 55000);

SELECT 
    CASE 
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM employees
GROUP BY 
    CASE 
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END;
```
```csv
"age_group"	"employee_count"	"avg_salary"
"Under 30"	 3	                 59333.333333333333
"Over 50"	 1	                 95000.000000000000
"30-50"	     3	                 70666.666666666667
```
*HAVING Clause - Filtering Groups*
```sql
DROP TABLE employees;

CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50)
);

INSERT INTO employees (name, department) VALUES
('Jeon Jungkook', 'Sales'),
('Park Bogum', 'Sales'),
('Song Kang', 'Sales'),
('Jimin', 'Sales'),
('Lee Sangwon', 'Sales'),
('J-Hope', 'Sales'),
('RM', 'Engineering'),
('Suga', 'Engineering'),
('Jin', 'Engineering'),
('Lee Dohyun', 'Engineering'),
('Nam Joo Hyuk', 'Engineering'),
('Kim Taehyung', 'Marketing');

SELECT 
    department,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 5;
```
```csv
"department"	"employee_count"
"Sales"	         6
```
```sql
DROP TABLE IF EXISTS product_reviews;

CREATE TABLE product_reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT,
    rating INT
);

INSERT INTO product_reviews (product_id, rating) VALUES
(1, 5), (1, 4), (1, 5), (1, 4), (1, 5), (1, 5), (1, 4), (1, 5), (1, 5), (1, 4),
(2, 3), (2, 4), (2, 4), (2, 5), (2, 4), (2, 4), (2, 3), (2, 4), (2, 4), (2, 4),
(3, 5), (3, 5), (3, 5), (3, 4);

SELECT
    product_id,
    AVG(rating) AS avg_rating,
    COUNT(*) AS review_count
FROM product_reviews
GROUP BY product_id
HAVING AVG(rating) > 4.0 AND COUNT(*) >= 10;
```
```csv
"product_id"  "avg_rating"         "review_count"
1	          4.6000000000000000   10
```
## Window Functions vs Aggregate Functions

```sql
DROP TABLE employees;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    salary INT
);

INSERT INTO employees (first_name, department, salary) VALUES
('Jungkook', 'Sales', 60000),
('Bogum', 'Sales', 72000),
('Song Kang', 'Sales', 68000),
('Dohyun', 'Engineering', 85000),
('Joo Hyuk', 'Engineering', 95000),
('Taehyung', 'Marketing', 50000),
('Eunwoo', 'Marketing', 55000);

SELECT department, AVG(salary) AS dept_avg_salary
FROM employees
GROUP BY department;
```
```csv
"Marketing"	52500.000000000000
"Engineering"	90000.000000000000
"Sales"	66666.666666666667
```
```sql
SELECT 
    employee_id,
    first_name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM employees;
```
```csv
4	"Dohyun"	"Engineering"	85000	90000.000000000000
5	"Joo Hyuk"	"Engineering"	95000	90000.000000000000
7	"Eunwoo"	"Marketing"	    55000	52500.000000000000
6	"Taehyung"	"Marketing"	    50000	52500.000000000000
3	"Song Kang"	"Sales"	        68000	66666.666666666667
1	"Jungkook"	"Sales"	        60000	66666.666666666667
2	"Bogum"	    "Sales"	        72000	66666.666666666667
```
*Handling NULL Values*
```sql
DROP TABLE employees;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    bonus INT
);

INSERT INTO employees (name, email, bonus) VALUES
('Jeon Jungkook', 'jungkook@example.com', 5000),
('Park Bogum', NULL, 7000),
('Song Kang', 'songkang@example.com', NULL),
('Lee Dohyun', 'dohyun@example.com', 8000),
('Nam Joo Hyuk', NULL, NULL),
('Kim Taehyung', 'taehyung@example.com', 3000),
('Cha Eunwoo', NULL, 4000);

SELECT 
    COUNT(*) AS total_rows,
    COUNT(email) AS non_null_emails,
    COUNT(*) - COUNT(email) AS null_emails
FROM employees;
```
```csv
"total_rows"  "non_null_emails" "null_emails"
7	            4	                3
```
```sql
SELECT 
    SUM(bonus) AS total_bonus,        -- NULLs ignored
    AVG(bonus) AS avg_bonus,          -- NULLs ignored
    COUNT(bonus) AS employees_with_bonus
FROM employees;
```
```csv
"total_bonus"  "avg_bonus"              "employees_with_bonus"
27000	       5400.0000000000000000	5
```
## Common Patterns and Best Practices
*1. Combining Multiple Aggregations*
```sql
DROP TABLE employees;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary INT,
    hire_date DATE
);

INSERT INTO employees (name, department, salary, hire_date) VALUES
('Jeon Jungkook', 'Sales', 60000, '2022-05-10'),
('Park Bogum', 'Sales', 72000, '2023-02-15'),
('Song Kang', 'Sales', 68000, '2021-11-20'),
('Lee Dohyun', 'Engineering', 85000, '2020-03-15'),
('Nam Joo Hyuk', 'Engineering', 95000, '2023-01-20'),
('Kim Taehyung', 'Marketing', 50000, '2021-09-12'),
('Cha Eunwoo', 'Marketing', 55000, '2022-11-05'),
('Park Jimin', 'Sales', 58000, '2023-04-01'),
('Lee Sangwon', 'Engineering', 90000, '2022-07-30');

SELECT
    department,
    COUNT(*) AS employee_count,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    AVG(salary) AS avg_salary,
    STDDEV(salary) AS salary_std_dev
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;
```
```csv
"Engineering"	3	85000	95000	90000.000000000000	5000.000000000000
"Sales"	        4	58000	72000	64500.000000000000	6608.075867199670
"Marketing"	    2	50000	55000	52500.000000000000	3535.533905932738
```
*2. Conditional Aggregation*
```sql
SELECT 
    department,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN salary > 50000 THEN 1 END) AS high_earners,
    COUNT(CASE WHEN hire_date > '2023-01-01' THEN 1 END) AS recent_hires
FROM employees
GROUP BY department;
```
```csv
"department"   "total_employees"   "high_earners"  "recents_hires"
"Marketing"	    2	               1	           0
"Engineering"	3	               3	           1
"Sales"	        4	               4	           2
```
*3. Percentage Calculations*
```sql
SELECT 
    department,
    COUNT(*) AS dept_count,
    COUNT(*)::FLOAT / (SELECT COUNT(*) FROM employees) * 100 AS percentage
FROM employees
GROUP BY department
ORDER BY percentage DESC;
```
```csv
"department"    "dept_count"    "percentage"
"Sales"	        4	            44.44444444444444
"Engineering"	3	            33.33333333333333
"Marketing"	    2	            22.22222222222222
```