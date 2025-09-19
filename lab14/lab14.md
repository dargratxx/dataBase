# Transactions and ACID Properties

```sql
DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    balance DECIMAL(10,2)
);

INSERT INTO accounts (name, balance) VALUES
('Account A', 1000.00),
('Account B', 500.00);

SELECT * FROM accounts;
```
``csv
1	"Account A"	1000.00
2	"Account B"	500.00
``
*COMMIT*
```sql
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT;
```
```csv
1	"Account A"	900.00
2	"Account B"	600.00
```
*ROLLBACK*
```sql
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
ROLLBACK; --изменения отменяются
```
```csv
1	"Account A"	900.00
2	"Account B"	600.00
```
```sql
BEGIN;
SELECT balance FROM accounts WHERE account_id = 1;
UPDATE accounts SET balance = balance - 500 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 500 WHERE account_id = 2;
COMMIT;
```
```csv
1	"Account A"	500.00
2	"Account B"	1000.00
```
## ACID properties in detail
*ATOMICITY*
```sql
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    total DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT,
    quantity INT
);

CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    stock INT
);

INSERT INTO inventory (product_id, product_name, stock) VALUES
(101, 'T-Shirt', 10),
(102, 'Hoodie', 5);

BEGIN;
INSERT INTO orders (customer_id, total) VALUES (1, 250.00);
-- допустим, мы вставляем заказ с order_id = 1
INSERT INTO order_items (order_id, product_id, quantity) VALUES (1, 101, 2);
-- если тут ошибка, то:
UPDATE inventory SET stock = stock - 2 WHERE product_id = 101;
ROLLBACK;
--после ROLLBACK никаких изменений в orders, order_items, inventory нет.
```
*CONSISTENCY*

```sql
ROLLBACK;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE inventory (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50),
    stock INT
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    total DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES inventory(product_id),
    quantity INT
);

INSERT INTO customers (name, email) VALUES
('Alice', 'alice@example.com');

INSERT INTO inventory (product_name, stock) VALUES
('T-Shirt', 10),
('Hoodie', 5);

BEGIN;
INSERT INTO orders (customer_id, total) VALUES (1, 250.00);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (LASTVAL(), 1, 2);
UPDATE inventory SET stock = stock - 2 WHERE product_id = 1;
COMMIT;

SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM inventory;
```

```csv
2	"Hoodie"	5
1	"T-Shirt"	8
```
```sql
BEGIN;
INSERT INTO customers (name, email) VALUES ('John Doe', 'john@email.com');
INSERT INTO orders (customer_id, total) VALUES (LASTVAL(), 100.00);
COMMIT;

SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM inventory;
```

```csv
1	"T-Shirt"	10
2	"Hoodie"	5
```

*ISOLATION*
--isolation гарантирует, что параллельные транзакции
 не мешают друг другу и данные остаются корректными.
```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE inventory
SET stock = stock - 1
WHERE product_id = 1;
COMMIT;
SELECT product_id, product_name, stock FROM inventory WHERE product_id = 1;
```
```csv
1	"T-Shirt"	9
```
*DURABILITY*
--после того как транзакция коммитнулась,
 изменения навсегда сохраняются в базе данных.
```sql
BEGIN;
UPDATE inventory 
SET stock = stock - 2 
WHERE product_id = 1;
COMMIT;
SELECT product_id, product_name, stock FROM inventory;
```
```csv
1	"T-Shirt"	8
```
*READ COMMITTED*
```sql
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    owner VARCHAR(50),
    balance INT
);

INSERT INTO accounts (owner, balance) VALUES
('Alice', 1000),
('Bob', 1500),
('Charlie', 2000);

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM accounts WHERE balance > 1000;
SELECT * FROM accounts WHERE balance > 1000;
COMMIT;
```
```csv
account_id	owner	balance
2	        Bob	    1500
3	        Charlie	2000
account_id	owner	balance
2	        Bob	    1500
3	        Charlie	2000
```
--READ COMMITTED не позволяет видеть незакоммиченные
изменения других транзакций

*READ UNCOMMITTED*
```sql
CREATE TABLE accounts (
account_id SERIAL PRIMARY KEY,
owner VARCHAR(50),
balance INT
);

INSERT INTO accounts (owner, balance) VALUES
('Alice', 1000),
('Bob', 500);


BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
UPDATE accounts SET balance = balance - 200 WHERE account_id = 1;
COMMIT;
SELECT * FROM accounts ORDER BY account_id;
```
```csv
account_id	owner	balance
1	        Alice	    800
2	        Bob	        500
```
--READ UNCOMMITTED позволяет потенциально видеть
изменения других транзакций, но postgresql не
показывает грязные данные, так что результат
будет как при READ COMMITTED

*REPEATABLE READ*

```sql
DROP TABLE IF EXISTS accounts;

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    owner VARCHAR(50),
    balance DECIMAL(10,2)
);

INSERT INTO accounts (owner, balance) VALUES
('Alice', 1000.00),
('Bob', 1500.00),
('Charlie', 2000.00);

SELECT * FROM accounts ORDER BY account_id;
```
```csv
account_id	owner	    balance
1	        Alice	    1000.00
2	        Bob	        1500.00
3	        Charlie	    2000.00
```
```sql
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM accounts WHERE balance > 1000;
COMMIT;
```
```csv
account_id	owner	balance
2	        Bob	    1500.00
3	        Charlie	2000.00
```
```sql
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM accounts ORDER BY account_id;
```
```csv
account_id	owner	    balance
1	        Alice	    1000.00
2	        Bob	        1500.00
3	        Charlie	    2000.00
```
```sql
UPDATE accounts SET balance = balance * 1.05;
```
```csv
account_id	owner	    balance
1	        Alice	    1050.00
2	        Bob	        1575.00
3	        Charlie	    2100.00
```
*Savepoints*

```sql
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS orders CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    total DECIMAL(10,2)
);
BEGIN;

INSERT INTO customers (name, email) VALUES ('Alice', 'alice@email.com');

SAVEPOINT after_customer_insert;

INSERT INTO orders (customer_id, total) VALUES (1, 500.00);

ROLLBACK TO SAVEPOINT after_customer_insert;

INSERT INTO orders (customer_id, total) VALUES (1, 300.00);

COMMIT;
SELECT * FROM customers ORDER BY customer_id;
```

```csv
"customer_id"	"name"	"email"
1	            "Alice"	"alice@email.com"
```
*Multiple Savepoints*

```sql
DROP TABLE IF EXISTS products CASCADE;

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2)
);

BEGIN;
INSERT INTO products (name, price) VALUES ('Laptop', 999.99);
SAVEPOINT sp1;
INSERT INTO products (name, price) VALUES ('Mouse', 25.99);
SAVEPOINT sp2;
INSERT INTO products (name, price) VALUES ('Invalid Product', -50.00);
ROLLBACK TO SAVEPOINT sp2;
INSERT INTO products (name, price) VALUES ('Keyboard', 79.99);
COMMIT;
SELECT * FROM products ORDER BY product_id;
```
```csv
"product_id"	"name"	    "price"
1	            "Laptop"	999.99
2	            "Mouse"	    25.99
4	            "Keyboard"	79.99
```
*Releasing*

```sql
DROP TABLE IF EXISTS logs CASCADE;

CREATE TABLE logs (
    log_id SERIAL PRIMARY KEY,
    message VARCHAR(200)
);

BEGIN;
INSERT INTO logs (message) VALUES ('Starting process');
SAVEPOINT process_start;
INSERT INTO logs (message) VALUES ('Process completed');
RELEASE SAVEPOINT process_start;
COMMIT;

SELECT * FROM logs ORDER BY log_id;
```
```csv
"log_id"	"message"
1	        "Starting process"
2	        "Process completed"
```
*Transaction Best Practices*

```sql
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;

CREATE TABLE inventory (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(50),
    stock INT
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT REFERENCES inventory(product_id),
    quantity INT
);

INSERT INTO inventory (product_name, stock) VALUES
('T-Shirt', 10),
('Hoodie', 5);
BEGIN;
UPDATE inventory SET stock = stock - 1 WHERE product_id = 1;
INSERT INTO order_items (order_id, product_id, quantity) VALUES (1, 1, 1);
COMMIT;
SELECT * FROM inventory ORDER BY product_id;
```
```csv
product_id	product_name	stock
1	        T-Shirt	        9
2	        Hoodie	        5
```
*Handling errors*
```sql
DROP TABLE IF EXISTS accounts CASCADE;

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    owner VARCHAR(50),
    balance DECIMAL(10,2)
);

INSERT INTO accounts (owner, balance) VALUES
('Alice', 50),
('Bob', 150);
BEGIN;
DO $$
DECLARE
insufficient_funds EXCEPTION;
    current_balance DECIMAL;
BEGIN
SELECT balance INTO current_balance FROM accounts WHERE account_id = 1;

IF current_balance < 100 THEN
        RAISE insufficient_funds;
END IF;

UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

EXCEPTION
    WHEN insufficient_funds THEN
        RAISE NOTICE 'Transaction failed: Insufficient funds';
ROLLBACK;
END $$;
SELECT * FROM accounts ORDER BY account_id;
```
```csv
account_id	owner	balance
1	        Alice	50.00
2	        Bob	    150.00
```
*appropriate isolation levels*
```sql
-- для финансовых операций используйте высокую степень изоляции SERIALIZABLE
DROP TABLE IF EXISTS accounts CASCADE;

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    owner VARCHAR(50),
    balance DECIMAL(10,2)
);

INSERT INTO accounts (owner, balance) VALUES
('Alice', 1000.00),
('Bob', 1500.00);
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE accounts SET balance = balance - 200 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 200 WHERE account_id = 2;
COMMIT;
SELECT * FROM accounts ORDER BY account_id;
```
```csv
account_id	owner	balance
1	        Alice	800.00
2	        Bob	    1700.00
```
```sql
--READ COMMITTED для отчетности
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM accounts WHERE balance > 1000;
COMMIT;
```
```csv
account_id	owner	balance
2	        Bob	    1700.00
```
*savepoints for complex operations*
```sql
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO customers (name, email) VALUES ('Alice', 'alice@example.com');

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    total DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT,
    quantity INT
);
BEGIN;
INSERT INTO orders (customer_id, total) VALUES (1, 1000.00);
SAVEPOINT before_items;
INSERT INTO order_items (order_id, product_id, quantity)
VALUES (currval('orders_order_id_seq'), 101, 2);
INSERT INTO order_items (order_id, product_id, quantity)
VALUES (currval('orders_order_id_seq'), 102, 1);
COMMIT;
SELECT * FROM orders;
```
```csv
order_id	customer_id	total
1	        1	        1000.00
```
*Monitor transaction locks and deadlocks*
```sql
SELECT 
    blocked_locks.pid AS blocked_pid,
    blocked_activity.usename AS blocked_user,
    blocking_locks.pid AS blocking_pid,
    blocking_activity.usename AS blocking_user,
    blocked_activity.query AS blocked_statement
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity 
    ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks 
    ON blocking_locks.locktype = blocked_locks.locktype
WHERE NOT blocked_locks.granted;
```
```csv
blocked_pid	blocked_user	blocking_pid	blocking_user	blocked_statement
12345	    alice	    12344	    bob	        UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
12346	    charlie	    12344	    bob	        DELETE FROM orders WHERE order_id = 10;
```
*multiple operations*

```sql
DROP TABLE IF EXISTS audit_log CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS user_preferences CASCADE;

CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    action VARCHAR(50),
    timestamp TIMESTAMP
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE user_preferences (
    pref_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    theme VARCHAR(50)
);
BEGIN;
INSERT INTO audit_log (action, timestamp) VALUES ('user_creation', NOW());
INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com');
INSERT INTO user_preferences (user_id, theme) VALUES (currval('users_user_id_seq'), 'dark');
COMMIT;
SELECT * FROM audit_log;
```
```csv
log_id	action	        timestamp
1	    user_creation	2025-09-19 12:00:00
```
