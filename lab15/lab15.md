# Data Import/Export and Backup
## COPY Command
```sql
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);

INSERT INTO employees (first_name, last_name, department, salary) VALUES
('K', 'Lee', 'Engineering', 90000),
('Fuma', 'Kim', 'Engineering', 85000),
('Nicholas', 'Park', 'Sales', 75000),
('EJ', 'Choi', 'Sales', 80000),
('Yuma', 'Tan', 'Marketing', 70000);
```
```sql
COPY employees TO '/tmp/employees.csv' WITH CSV HEADER;
```
```csv
employee_id,first_name,last_name,department,salary
1,K,Lee,Engineering,90000
2,Fuma,Kim,Engineering,85000
3,Nicholas,Park,Sales,75000
4,EJ,Choi,Sales,80000
5,Yuma,Tan,Marketing,70000
```
```sql
COPY employees TO '/tmp/employees_pipe.txt' 
WITH DELIMITER '|' NULL 'N/A' CSV HEADER;
```
```txt
employee_id|first_name|last_name|department|salary
1|K|Lee|Engineering|90000
2|Fuma|Kim|Engineering|85000
3|Nicholas|Park|Sales|75000
4|EJ|Choi|Sales|80000
5|Yuma|Tan|Marketing|70000
```
*CSV Import/Export*
```sql
DROP TABLE IF EXISTS new_employees;

CREATE TABLE new_employees (
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);
```
```csv
first_name,last_name,email
Alice,Lee,alice@example.com
Bob,Kim,bob@example.com
Charlie,Park,charlie@example.com
```
```sql
COPY new_employees(first_name, last_name, email) 
FROM '/tmp/new_employees.csv' WITH CSV HEADER;
```
```sql
SELECT * FROM new_employees ORDER BY first_name;
```
```csv
first_name,last_name,email
Alice,Lee,alice@example.com
Bob,Kim,bob@example.com
Charlie,Park,charlie@example.com
```
```sql
COPY (
    SELECT first_name, last_name, salary
    FROM employees
    WHERE department = 'Engineering'
) TO '/tmp/engineering_employees.csv' WITH CSV HEADER;
```
```csv
first_name,last_name,salary
K,Lee,90000
Fuma,Kim,85000
```
```sql
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
employee_id SERIAL PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
department VARCHAR(50),
salary INT
);

INSERT INTO employees (first_name, last_name, department, salary) VALUES
('K', 'Lee', 'Engineering', 90000),
('Fuma', 'Kim', 'Engineering', 85000),
('Nicholas', 'Park', 'Sales', 75000),
('EJ', 'Choi', 'Sales', 80000),
('Yuma', 'Tan', 'Marketing', 70000);
```
```sql
COPY employees TO '/tmp/employees.csv' WITH CSV HEADER;
```
```csv
employee_id,first_name,last_name,department,salary
1,K,Lee,Engineering,90000
2,Fuma,Kim,Engineering,85000
3,Nicholas,Park,Sales,75000
4,EJ,Choi,Sales,80000
5,Yuma,Tan,Marketing,70000
```
```sql
COPY employees TO '/tmp/employees_pipe.txt' 
WITH DELIMITER '|' NULL 'N/A' CSV HEADER;
```
```txt
employee_id|first_name|last_name|department|salary
1|K|Lee|Engineering|90000
2|Fuma|Kim|Engineering|85000
3|Nicholas|Park|Sales|75000
4|EJ|Choi|Sales|80000
5|Yuma|Tan|Marketing|70000
```
```sql
DROP TABLE IF EXISTS new_employees;

CREATE TABLE new_employees (
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100)
);
```
```csv
first_name,last_name,email
Alice,      Lee,    alice@example.com
Bob,        Kim,    bob@example.com
Charlie,    Park,   charlie@example.com
```
```sql
COPY new_employees(first_name, last_name, email) 
FROM '/tmp/new_employees.csv' WITH CSV HEADER;
```
```sql
SELECT * FROM new_employees ORDER BY first_name;
```
```csv
first_name,last_name,email
Alice,      Lee,    alice@example.com
Bob,        Kim,    bob@example.com
Charlie,    Park,   charlie@example.com
```
```sql
COPY (
    SELECT first_name, last_name, salary
    FROM employees
    WHERE department = 'Engineering'
) TO '/tmp/engineering_employees.csv' WITH CSV HEADER;
```
```csv
first_name,last_name,salary
K,          Lee,     90000
Fuma,       Kim,     85000
```
*pg_dump and pg_restore*
```pgsql
pg_dump -h localhost -U username -d database_name > backup.sql
pg_dump -h localhost -U username -d database_name -Fc > backup.dump
pg_dump -h localhost -U username -d database_name -t employees -t departments > tables_backup.sql
pg_dump -h localhost -U username -d database_name -Fc -v > backup.dump
pg_restore -h localhost -U username -d target_database backup.dump
createdb new_database
pg_restore -h localhost -U username -d new_database backup.dump
pg_restore -h localhost -U username -d database_name -t employees backup.dump
pg_restore -h localhost -U username -d database_name -j 4 backup.dump
```
*pg_dump*
```pgsql
pg_dump -h localhost -U username -d database_name -s > schema_only.sql
pg_dump -h localhost -U username -d database_name -a > data_only.sql
pg_dump -h localhost -U username -d database_name -T log_table -T temp_data > backup_without_logs.sql
```
*Full Database Backups*
```perl
pg_dumpall -h localhost -U postgres > full_cluster_backup.sql
pg_dump -h localhost -U username -d production_db -Fc --verbose > full_production_backup.dump
pg_dump -h localhost -U username -d database_name -Fc -O > backup_with_ownership.dump

#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backups/postgresql"
DB_NAME="production_db"

pg_dump -h localhost -U backup_user -d $DB_NAME -Fc > "$BACKUP_DIR/${DB_NAME}_${DATE}.dump"
find $BACKUP_DIR -name "${DB_NAME}_*.dump" -mtime +7 -delete
```
*Incremental Backups*
```sql
archive_mode = on
archive_command = 'cp %p /backup/wal/%f'
wal_level = replica;
```
*Base backup*
```sql
pg_basebackup -h localhost -U replication_user -D /backup/base -Ft -z -P
pg_basebackup -h localhost -U replication_user -D /backup/base -x -P
--Manual WAL switch
SELECT pg_switch_wal();
--Archive cleanup
pg_archivecleanup /backup/wal 000000010000000000000010
```
*PITR (Point-in-Time Recovery)*
```sql
wal_level = replica
archive_mode = on
archive_command = 'cp %p /backup/wal/%f'
restore_command = 'cp /backup/wal/%f %p';
```
*Perform PITR*
```sql
sudo systemctl stop postgresql
rm -rf /var/lib/postgresql/data/*
tar -xf /backup/base/base.tar -C /var/lib/postgresql/data/
cat > /var/lib/postgresql/data/recovery.signal << EOF
restore_command = 'cp /backup/wal/%f %p'
recovery_target_time = '2024-01-15 14:30:00'
EOF
sudo systemctl start postgresql
```
*Recovery targeting options*
```sql
recovery_target_time = '2024-01-15 14:30:00'
recovery_target_xid = '12345'
recovery_target_name = 'before_data_migration'
SELECT pg_create_restore_point('before_data_migration');
```
*Data Migration Strategies*
```sql
--Strategy 1: Dump & Restore
pg_dump -h source_host -U username -d source_db -Fc > migration.dump
pg_restore -h target_host -U username -d target_db migration.dump
--Strategy 2: Logical Replication
CREATE PUBLICATION migration_pub FOR ALL TABLES;
CREATE SUBSCRIPTION migration_sub 
CONNECTION 'host=source_host dbname=source_db user=replication_user' 
PUBLICATION migration_pub;
--Strategy 3: Physical Replication
wal_level = replica
max_wal_senders = 3
--Standby creation
pg_basebackup -h primary_host -D /var/lib/postgresql/standby -U replication_user -R -P
--Strategy 4: ETL Pipeline
CREATE TABLE staging_customers AS SELECT * FROM customers WHERE 1=0;
COPY (SELECT * FROM customers LIMIT 10000 OFFSET 0) TO '/tmp/customers_batch_1.csv' WITH CSV HEADER;
COPY staging_customers FROM '/tmp/customers_batch_1.csv' WITH CSV HEADER;
INSERT INTO target_customers SELECT * FROM staging_customers
ON CONFLICT (customer_id) DO UPDATE SET ...;
```
*Best practices*
```sql
SELECT COUNT(*) FROM source_table;
pg_dump -h source -U user -d db -t small_table | psql -h target -U user -d db;
SELECT pid, usename, application_name, client_addr, state FROM pg_stat_activity WHERE application_name = 'pg_dump';
SELECT COUNT(*) FROM target_table;
```
*Handling large tables*
```sql
CREATE TABLE large_table_2023 PARTITION OF large_table FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');
pg_dump -h source -U user -d db -t large_table_2023 | psql -h target -U user -d db;
```