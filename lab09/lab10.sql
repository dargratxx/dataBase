DROP TABLE students;

CREATE TABLE Students (
student_id SERIAL PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
birth_date DATE
);
--insert
INSERT INTO Students (first_name, last_name, birth_date) VALUES
('Darina', 'Burdyaeva', '2001-09-23'),
('Bakyt', 'Mamatov', '2003-01-15'),
('Gulzat', 'Sultanova', '2002-07-30');

--update

UPDATE Students
SET birth_date = '2006-09-03'
WHERE first_name = 'Darina' AND last_name = 'Burdyaeva';

--delete

DELETE FROM Students
WHERE first_name = 'Gulzat' AND last_name = 'Sultanova';

DELETE FROM Students
WHERE birth_date = '2002-01-01';

--bulk op

INSERT INTO Students (first_name, last_name, birth_date) VALUES
('Nursultan', 'Isakov', '2002-04-10'),
('Meerim', 'Bekova', '2003-06-12'),
('Tilek', 'Usubaliev', '2001-11-05');

UPDATE Students
SET last_name = 'Bekov'
WHERE last_name IN ('Uulu', 'Isakov');

DELETE FROM Students
WHERE student_id IN (2, 3, 5);

SELECT * FROM Students;
