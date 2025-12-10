CREATE TABLE ClassGroup (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20)
);

CREATE TABLE Student (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    date_of_birth DATE,
    address VARCHAR(255),
    class_group_id INTEGER REFERENCES ClassGroup(id),
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(25)
);

CREATE TABLE Teacher (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(25)
);

CREATE TABLE Subject (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    teacher_id INTEGER REFERENCES Teacher(id)
);

CREATE TABLE Classroom (
    id SERIAL PRIMARY KEY,
    room_number VARCHAR(20)
);

CREATE TABLE Schedule (
    id SERIAL PRIMARY KEY,
    subject_id INTEGER REFERENCES Subject(id),
    teacher_id INTEGER REFERENCES Teacher(id),
    class_group_id INTEGER REFERENCES ClassGroup(id),
    classroom_id INTEGER REFERENCES Classroom(id),
    start_time TIMESTAMP,
    end_time TIMESTAMP
);

CREATE TABLE Grade (
    id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES Student(id),
    subject_id INTEGER REFERENCES Subject(id),
    teacher_id INTEGER REFERENCES Teacher(id),
    grade_value VARCHAR(5),
    date_given DATE
);

INSERT INTO ClassGroup (id, name) VALUES
    (1, '10A'),
    (2, '10B'),
    (3, '11A'),
    (4, '11B');

INSERT INTO Student (id, name, date_of_birth, address, class_group_id, email, phone) VALUES
    (1, 'Jeon Jungkook', '2005-09-01', 'Seoul, Mapo-gu', 1, 'jungkook@gmail.com', '+820105551122'),
    (2, 'Park Jimin', '2005-10-13', 'Busan, Haeundae', 1, 'jimin@gmail.com', '+820107771122'),
    (3, 'Kim Taehyung', '2005-12-30', 'Daegu, Jung-gu', 1, 'taehyung@gmail.com', '+820109991122'),
    (4, 'Kim Namjoon', '2004-09-12', 'Ilsan, Goyang', 1, 'namjoon@gmail.com', '+820108881122'),
    (5, 'Jung Hoseok', '2004-02-18', 'Gwangju, Buk-gu', 1, 'hoseok@gmail.com', '+820106661122'),
    (6, 'Kim Seokjin', '2004-12-04', 'Gwacheon-si', 2, 'seokjin@gmail.com', '+820105551133'),
    (7, 'Min Yoongi', '2004-03-09', 'Daegu, Buk-gu', 2, 'yoongi@gmail.com', '+820101231122'),
    (8, 'Bang Sihyuk', '1972-08-09', 'Seoul, Gangnam-gu', 3, 'bangpd@gmail.com', '+820100001122'),
    (9, 'Lee Minho', '2004-05-11', 'Seoul, Mapo-gu', 3, 'lee.minho@gmail.com', '+820109991144'),
    (10, 'Choi Soobin', '2005-12-05', 'Seoul, Yongsan', 3, 'soobin@gmail.com', '+820109991155'),
    (11, 'Han Jisung', '2004-09-14', 'Incheon', 3, 'jisung@gmail.com', '+820101100033'),
    (12, 'Hyunjin Hwang', '2004-03-20', 'Seoul, Gangdong-gu', 4, 'hyunjin@gmail.com', '+820109441122');

INSERT INTO Teacher (id, name, email, phone) VALUES
    (1, 'Max Verstappen', 'darina@example.com', '+996700111222'),
    (2, 'Park Jihoon', 'jihoon@example.com', '+820107777777'),
    (3, 'Naoya Zenin', 'zenin@example.com', '+81355667788'),
    (4, 'Gojo Satoru', 'gojo@example.com', '+81311223344');


INSERT INTO Subject (id, title, teacher_id) VALUES
    (1, 'Mathematics', 1),
    (2, 'Physics', 2),
    (3, 'History', 3),
    (4, 'English', 4);

INSERT INTO Classroom (id, room_number) VALUES
    (1, 'G30'),
    (2, 'C01'),
    (3, '222'),
    (4, '309');

INSERT INTO Schedule (
id, subject_id, teacher_id, class_group_id, classroom_id, start_time, end_time
) VALUES
    (1, 1, 1, 1, 1, '2025-02-10 08:00', '2025-02-10 08:45'),
    (2, 2, 2, 1, 2, '2025-02-10 09:00', '2025-02-10 09:45'),
    (3, 3, 3, 2, 3, '2025-02-10 10:00', '2025-02-10 10:45'),
    (4, 4, 4, 2, 4, '2025-02-10 11:00', '2025-02-10 11:45'),
    (5, 1, 1, 3, 1, '2025-02-11 08:00', '2025-02-11 08:45'),
    (6, 2, 2, 4, 2, '2025-02-11 09:00', '2025-02-11 09:45');

INSERT INTO Grade (
id, student_id, subject_id, teacher_id, grade_value, date_given
) VALUES
    (1, 1, 1, 1, 'A', '2025-02-01'),
    (2, 2, 1, 1, 'B', '2025-02-01'),
    (3, 3, 2, 2, 'A', '2025-02-02'),
    (4, 4, 3, 3, 'C', '2025-02-02'),
    (5, 5, 4, 4, 'B', '2025-02-03'),
    (6, 6, 1, 1, 'A', '2025-02-03'),
    (7, 7, 2, 2, 'A', '2025-02-04'),
    (8, 8, 3, 3, 'B', '2025-02-04');
