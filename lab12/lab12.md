# Joining Tables
## Types of Joins
*1. INNER JOIN*
```sql
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO customers (name, email) VALUES
('K', 'k@example.com'),
('Fuma', 'fuma@example.com'),
('Nicholas', 'nicholas@example.com'),
('EJ', 'ej@example.com'),
('Yuma', 'yuma@example.com'),
('Jo', 'jo@example.com'),
('Harua', 'harua@example.com'),
('Taki', 'taki@example.com'),
('Maki', 'maki@example.com');

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    total_amount DECIMAL(10,2)
);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2023-07-01', 250.00),
(2, '2023-07-03', 450.00),
(1, '2023-07-10', 150.00),
(3, '2023-07-15', 300.00),
(5, '2023-08-01', 500.00),
(7, '2023-08-05', 200.00);

SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;
```
```csv
"name"	    "email"	                "order_date"    "total_amount"
"K"	         "k@example.com"	    "2023-07-01"	250.00
"Fuma"	     "fuma@example.com"	    "2023-07-03"	450.00
"K"	         "k@example.com"	    "2023-07-10"	150.00
"Nicholas"	 "nicholas@example.com"	"2023-07-15"	300.00
"Yuma"	     "yuma@example.com"	    "2023-08-01"	500.00
"Harua"	     "harua@example.com"	"2023-08-05"	200.00
```
*2. LEFT JOIN (LEFT OUTER JOIN)*
```sql
SELECT c.name, c.email, o.order_date, o.total_amount FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id;
```
```csv
"name"       "email"               "order_date"   "total_amount"
"K"          "k@example.com"       "2023-07-01"   250.00
"Fuma"       "fuma@example.com"    "2023-07-03"   450.00
"K"          "k@example.com"       "2023-07-10"   150.00
"Nicholas"   "nicholas@example.com" "2023-07-15"  300.00
"Yuma"       "yuma@example.com"    "2023-08-01"   500.00
"Harua"      "harua@example.com"   "2023-08-05"   200.00
"Taki"       "taki@example.com"                   
"Jo"         "jo@example.com"                      
"EJ"         "ej@example.com"                      
"Maki"       "maki@example.com"                    
```
*3. RIGHT JOIN (RIGHT OUTER JOIN)*
```sql
SELECT c.name, c.email, o.order_date, o.total_amount FROM customers c RIGHT JOIN orders o ON c.customer_id = o.customer_id;
```
```csv
"name"	    "email"	                "order_date"    "total_amount"
"K"	         "k@example.com"	    "2023-07-01"	250.00
"Fuma"	     "fuma@example.com"	    "2023-07-03"	450.00
"K"	         "k@example.com"	    "2023-07-10"	150.00
"Nicholas"	 "nicholas@example.com"	"2023-07-15"	300.00
"Yuma"	     "yuma@example.com"	    "2023-08-01"	500.00
"Harua"	     "harua@example.com"	"2023-08-05"	200.00
```
*4. FULL OUTER JOIN*
```sql
SELECT c.name AS participant_name, o.total_amount AS order_total
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;
```
```csv
"participant_name"   "order_total"
"K"                  250.00
"Fuma"               450.00
"K"                  150.00
"Nicholas"           300.00
"Yuma"               500.00
"Harua"              200.00
"Taki"               
"Jo"                 
"EJ"                 
"Maki"               
```
*5. CROSS JOIN*
```sql
DROP TABLE IF EXISTS merch;

CREATE TABLE merch (
    merch_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50),
    price INT
);

INSERT INTO merch (product_name, price) VALUES
('T-Shirt', 30),
('Hoodie', 50),
('Cap', 20);

SELECT
    c.name AS participant_name,
    m.product_name AS merch_item,
    m.price
FROM customers c
         CROSS JOIN merch m;
```
```csv
"participant_name"   "merch_item"   "price"
"K"                  "T-Shirt"      30
"Fuma"               "T-Shirt"      30
"Nicholas"           "T-Shirt"      30
"EJ"                 "T-Shirt"      30
"Yuma"               "T-Shirt"      30
"Jo"                 "T-Shirt"      30
"Harua"              "T-Shirt"      30
"Taki"               "T-Shirt"      30
"Maki"               "T-Shirt"      30
"K"                  "Hoodie"       50
"Fuma"               "Hoodie"       50
"Nicholas"           "Hoodie"       50
"EJ"                 "Hoodie"       50
"Yuma"               "Hoodie"       50
"Jo"                 "Hoodie"       50
"Harua"              "Hoodie"       50
"Taki"               "Hoodie"       50
"Maki"               "Hoodie"       50
"K"                  "Cap"          20
"Fuma"               "Cap"          20
"Nicholas"           "Cap"          20
"EJ"                 "Cap"          20
"Yuma"               "Cap"          20
"Jo"                 "Cap"          20
"Harua"              "Cap"          20
"Taki"               "Cap"          20
"Maki"               "Cap"          20
```
## Advanced Join Techniques
*Multiple Table Joins*
```sql
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS merch;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO customers (name, email) VALUES
('K', 'k@example.com'),
('Fuma', 'fuma@example.com'),
('Nicholas', 'nicholas@example.com'),
('EJ', 'ej@example.com');

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE
);

INSERT INTO orders (customer_id, order_date) VALUES
(1, '2023-07-01'),
(1, '2023-07-10'),
(2, '2023-07-03'),
(3, '2023-07-15');

CREATE TABLE merch (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50),
    price INT
);

INSERT INTO merch (product_name, price) VALUES
('T-Shirt', 30),
('Hoodie', 50),
('Cap', 20);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES merch(product_id),
    quantity INT
);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(3, 1, 1),
(4, 2, 2);

SELECT
    c.name AS participant_name,
    o.order_date,
    oi.quantity,
    m.product_name,
    m.price
FROM customers c
         INNER JOIN orders o ON c.customer_id = o.customer_id
         INNER JOIN order_items oi ON o.order_id = oi.order_id
         INNER JOIN merch m ON oi.product_id = m.product_id
ORDER BY c.name, o.order_date;
```
```csv
"participant_name"   "order_date"   "quantity"   "product_name"   "price"
"Fuma"               "2023-07-03"   1            "T-Shirt"        30
"K"                  "2023-07-01"   2            "T-Shirt"        30
"K"                  "2023-07-01"   1            "Cap"            20
"K"                  "2023-07-10"   1            "Hoodie"         50
"Nicholas"           "2023-07-15"   2            "Hoodie"         50
```
```sql
DROP TABLE IF EXISTS employees;

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

SELECT
    e1.name AS employee,
    e2.name AS mentor
FROM employees e1
         LEFT JOIN employees e2 ON e1.mentor_id = e2.employee_id
ORDER BY e1.name;
```
```csv
"employee"   "mentor"
"EJ"         "Fuma"
"Fuma"       "K"
"Harua"      "Nicholas"
"Jo"         "Nicholas"
"K"                     
"Maki"       "Yuma"
"Nicholas"   "K"
"Taki"       "EJ"
"Yuma"       "Fuma"
```
*Join with Conditions*
```sql
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO customers (name, email) VALUES
('K', 'k@example.com'),
('Fuma', 'fuma@example.com'),
('Nicholas', 'nicholas@example.com'),
('EJ', 'ej@example.com');

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE,
    total_amount DECIMAL(10,2)
);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-01-10', 150.00),
(1, '2023-12-20', 90.00),
(2, '2024-02-05', 200.00),
(3, '2023-11-15', 50.00);

SELECT c.name, o.order_date, o.total_amount
FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2024-01-01' AND o.total_amount > 100;
```
```csv
"name"    "order_date"   "total_amount"
"K"       "2024-01-10"   150.00
"Fuma"    "2024-02-05"   200.00
```
*Working with Different Relationship Types*
```sql
DROP TABLE IF EXISTS user_profiles;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50)
);

CREATE TABLE user_profiles (
    profile_id SERIAL PRIMARY KEY,
    user_id INT UNIQUE REFERENCES users(user_id),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20)
);

INSERT INTO users (username) VALUES
('Koga '), ('Fuma'), ('Nicholas'), ('EJ');

INSERT INTO user_profiles (user_id, first_name, last_name, phone) VALUES
(1, 'Koga', 'Yudai', '123-456'),
(2, 'Fuma', 'Murata', '234-567'),
(3, 'Nicholas', 'Wang', '345-678');

SELECT u.username, up.first_name, up.last_name, up.phone
FROM users u
LEFT JOIN user_profiles up ON u.user_id = up.user_id;
```
```csv
"username"    "first_name"   "last_name"   "phone"
"Koga "       "Koga"         "Yudai"       "123-456"
"Fuma"        "Fuma"         "Murata"      "234-567"
"Nicholas"    "Nicholas"     "Wang"        "345-678"
"EJ"           [null]        [null]         [null]                 
```
*Performance Considerations*
```sql
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS merch;
DROP TABLE IF EXISTS customers;

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

CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

SELECT c.name, o.order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

SELECT c.name, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

SELECT c.name AS participant_name, m.product_name, m.price
FROM customers c
CROSS JOIN merch m;
```
*Common Pitfalls and How to Avoid Them*
```sql
INSERT INTO customers (name) VALUES
('K'), ('Fuma'), ('Nicholas'), ('EJ');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-01-10', 150.00),
(1, '2023-12-20', 90.00),
(2, '2024-02-05', 200.00);

INSERT INTO merch (product_name, price) VALUES
('T-Shirt', 30),
('Hoodie', 50),
('Cap', 20);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(3, 1, 1);

SELECT c.name, o.order_date
FROM customers c, orders o; --неправильный способ
```
```sql
SELECT c.name, o.order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;
```
```csv
"name"	"order_date"
"K"	    "2024-01-10"
"K"	    "2023-12-20"
"Fuma"	"2024-02-05"
```
```sql
SELECT c.name FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL; --без заказов
```
```csv
"name"
"EJ"
"Nicholas"
```
```sql
SELECT c.name AS participant_name, m.product_name, oi.quantity
FROM customers c INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN merch m ON oi.product_id = m.product_id;
```
```csv 
"participant_name"   "product_name"   "quantity"
"K"                  "T-Shirt"        2
"K"                  "Cap"            1
"K"                  "Hoodie"         1
"Fuma"               "T-Shirt"        1
```