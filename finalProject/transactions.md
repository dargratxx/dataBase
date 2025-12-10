```sql
BEGIN;
-- generate next student
WITH next_id AS (
    SELECT COALESCE(MAX(id), 0) + 1 AS new_id
    FROM Student
),
     insert_student AS (
INSERT INTO Student (
    id,
    name,
    date_of_birth,
    address,
    class_group_id,
    email,
    phone
)
SELECT
    new_id,
    'Ban BoBin',
    '2005-01-01',
    'His Address 123',
    1,
    'test_bobin@example.com',
    '+996700000000'
FROM next_id
         RETURNING id
)
INSERT INTO Grade (
    id,
    student_id,
    subject_id,
    teacher_id,
    grade_value,
    date_given
)
SELECT
    (SELECT COALESCE(MAX(id), 0) + 1 FROM Grade),
    id,
    3,      -- subject_id
    2,      -- teacher_id
    'B',
    CURRENT_DATE
FROM insert_student;

COMMIT;

SELECT * FROM Student ORDER BY id DESC LIMIT 5;
SELECT * FROM Grade ORDER BY id DESC LIMIT 5;
```
```csv
"id"	"student_id"	"subject_id"	"teacher_id"	"grade_value"	"date_given"
10	    14	            3	            2	            "B"	            "2025-12-11"
9	    13	            1	            1	            "A"	            "2025-12-11"
8	    8	            3	            3	            "B"	            "2025-02-04"
7	    7	            2	            2	            "A"	            "2025-02-04"
6	    6	            1	            1	            "A"	            "2025-02-03"
```
