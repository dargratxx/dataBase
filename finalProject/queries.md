*basic*
```sql
-- 1. All students
SELECT * FROM Student;
```
```csv
"id"  "name"           "date_of_birth"  "address"             "class_group_id"  "email"                 "phone"
1     "Jeon Jungkook"  "2005-09-01"     "Seoul, Mapo-gu"      1                  "jungkook@gmail.com"    "+820105551122"
2     "Park Jimin"     "2005-10-13"     "Busan, Haeundae"     1                  "jimin@gmail.com"       "+820107771122"
3     "Kim Taehyung"   "2005-12-30"     "Daegu, Jung-gu"      1                  "taehyung@gmail.com"    "+820109991122"
4     "Kim Namjoon"    "2004-09-12"     "Ilsan, Goyang"       1                  "namjoon@gmail.com"     "+820108881122"
5     "Jung Hoseok"    "2004-02-18"     "Gwangju, Buk-gu"     1                  "hoseok@gmail.com"      "+820106661122"
6     "Kim Seokjin"    "2004-12-04"     "Gwacheon-si"         2                  "seokjin@gmail.com"     "+820105551133"
7     "Min Yoongi"     "2004-03-09"     "Daegu, Buk-gu"       2                  "yoongi@gmail.com"      "+820101231122"
8     "Bang Sihyuk"    "1972-08-09"     "Seoul, Gangnam-gu"   3                  "bangpd@gmail.com"      "+820100001122"
9     "Lee Minho"      "2004-05-11"     "Seoul, Mapo-gu"      3                  "lee.minho@gmail.com"   "+820109991144"
10    "Choi Soobin"    "2005-12-05"     "Seoul, Yongsan"      3                  "soobin@gmail.com"       "+820109991155"
11    "Han Jisung"     "2004-09-14"     "Incheon"             3                  "jisung@gmail.com"       "+820101100033"
12    "Hyunjin Hwang"  "2004-03-20"     "Seoul, Gangdong-gu"  4                  "hyunjin@gmail.com"      "+820109441122"
```
```sql
-- 2. students from one class group
SELECT * FROM Student
WHERE class_group_id = 1;
```
```csv
"id"  "name"           "date_of_birth"  "address"           "class_group_id"  "email"               "phone"
1     "Jeon Jungkook"  "2005-09-01"     "Seoul, Mapo-gu"    1                 "jungkook@gmail.com"  "+820105551122"
2     "Park Jimin"     "2005-10-13"     "Busan, Haeundae"   1                 "jimin@gmail.com"     "+820107771122"
3     "Kim Taehyung"   "2005-12-30"     "Daegu, Jung-gu"    1                 "taehyung@gmail.com"  "+820109991122"
4     "Kim Namjoon"    "2004-09-12"     "Ilsan, Goyang"     1                 "namjoon@gmail.com"   "+820108881122"
5     "Jung Hoseok"    "2004-02-18"     "Gwangju, Buk-gu"   1                 "hoseok@gmail.com"    "+820106661122"
```
```sql
-- 3. names of all teachers and their mobile phone
SELECT
    name,
    phone
FROM Teacher;
```
```csv
"name"           "phone"
"Max Verstappen" "+996700111222"
"Park Jihoon"    "+820107777777"
"Naoya Zenin"    "+81355667788"
"Gojo Satoru"    "+81311223344"
```
```sql
-- 4. student names with their class group
SELECT
    s.name AS student_name,
    cg.name AS class_group
FROM Student s
JOIN ClassGroup cg ON cg.id = s.class_group_id;
```
```csv
"student_name"	"class_group"
"Jung Hoseok"	"10A"
"Kim Namjoon"	"10A"
"Kim Taehyung"	"10A"
"Park Jimin"	"10A"
"Jeon Jungkook"	"10A"
"Min Yoongi"	"10B"
"Kim Seokjin"	"10B"
"Han Jisung"	"11A"
"Choi Soobin"	"11A"
"Lee Minho"	    "11A"
"Bang Sihyuk"	"11A"
"Hyunjin Hwang"	"11B"
```
*advanced*
```sql
-- full schedule with subject, teacher, class group and classroom names
SELECT
    sch.id,
    sub.title AS subject,
    t.name AS teacher,
    cg.name AS class_group,
    cr.room_number AS classroom,
    sch.start_time,
    sch.end_time
FROM Schedule sch
         JOIN Subject sub ON sub.id = sch.subject_id
         JOIN Teacher t ON t.id = sch.teacher_id
         JOIN ClassGroup cg ON cg.id = sch.class_group_id
         JOIN Classroom cr ON cr.id = sch.classroom_id
ORDER BY sch.start_time;
```
```csv
"id"  "subject"      "teacher"          "class_group"  "classroom"  "start_time"              "end_time"
1     "Mathematics"  "Max Verstappen"   "10A"          "G30"        "2025-02-10 08:00:00"     "2025-02-10 08:45:00"
2     "Physics"      "Park Jihoon"      "10A"          "C01"        "2025-02-10 09:00:00"     "2025-02-10 09:45:00"
3     "History"      "Naoya Zenin"      "10B"          "222"        "2025-02-10 10:00:00"     "2025-02-10 10:45:00"
4     "English"      "Gojo Satoru"      "10B"          "309"        "2025-02-10 11:00:00"     "2025-02-10 11:45:00"
5     "Mathematics"  "Max Verstappen"   "11A"          "G30"        "2025-02-11 08:00:00"     "2025-02-11 08:45:00"
6     "Physics"      "Park Jihoon"      "11B"          "C01"        "2025-02-11 09:00:00"     "2025-02-11 09:45:00"
```
```sql
-- average grade per subject
SELECT
    sub.title AS subject,
    ROUND(
            AVG(
                    CASE
                        WHEN grade_value = 'A' THEN 5
                        WHEN grade_value = 'B' THEN 4
                        WHEN grade_value = 'C' THEN 3
                        WHEN grade_value = 'D' THEN 2
                        ELSE 1
                        END
            )
        , 1) AS avg_grade_numeric
FROM Grade g
         JOIN Subject sub ON sub.id = g.subject_id
GROUP BY sub.title
ORDER BY avg_grade_numeric DESC;
```
```csv
"subject"      "avg_grade_numeric"
"Physics"      5.0
"Mathematics"  4.7
"English"      4.0
"History"      3.5
```
```sql
-- count students in each class group
SELECT
    cg.name AS class_group,
    COUNT(s.id) AS student_count
FROM ClassGroup cg
         LEFT JOIN Student s ON s.class_group_id = cg.id
GROUP BY cg.name
ORDER BY student_count DESC;
```
```csv
"class_group"	"student_count"
"10A"	        5
"11A"	        4
"10B"	        2
"11B"	        1
```
```sql
-- grades with student + subject + teacher names
SELECT
    g.id,
    s.name AS student,
    sub.title AS subject,
    t.name AS teacher,
    g.grade_value,
    g.date_given
FROM Grade g
         JOIN Student s ON s.id = g.student_id
         JOIN Subject sub ON sub.id = g.subject_id
         JOIN Teacher t ON t.id = g.teacher_id
ORDER BY g.date_given DESC;
```
```csv
"id"  "student"        "subject"      "teacher"          "grade_value"  "date_given"
7     "Min Yoongi"     "Physics"      "Park Jihoon"      "A"            "2025-02-04"
8     "Bang Sihyuk"    "History"      "Naoya Zenin"      "B"            "2025-02-04"
5     "Jung Hoseok"    "English"      "Gojo Satoru"      "B"            "2025-02-03"
6     "Kim Seokjin"    "Mathematics"  "Max Verstappen"   "A"            "2025-02-03"
3     "Kim Taehyung"   "Physics"      "Park Jihoon"      "A"            "2025-02-02"
4     "Kim Namjoon"    "History"      "Naoya Zenin"      "C"            "2025-02-02"
1     "Jeon Jungkook"  "Mathematics"  "Max Verstappen"   "A"            "2025-02-01"
2     "Park Jimin"     "Mathematics"  "Max Verstappen"   "B"            "2025-02-01"
```