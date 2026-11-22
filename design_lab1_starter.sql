/* ==========================================================================
   design_lab1_starter.sql
   CIS 4720 Database Management and SQL
   Design Lab 1, From a Spreadsheet to Tables

   WHAT THIS FILE IS
   The campus tutoring center keeps its records in a spreadsheet. This file
   loads that spreadsheet into a table called tutoring_sheet, exactly as the
   center keeps it, and has a numbered heading for every step of the lab.

   HOW TO RUN IT
   One statement at a time. Put the cursor on it and press Ctrl + E twice.

   LABELING AND COMMENTING IS REQUIRED
   Above every statement you write, put a short comment in your own words
   saying what it does. Some steps also ask you to answer a question in a
   comment. The comments are graded.
   ========================================================================== */


-- =================================================================
-- SETUP. Run these three first, one at a time, while you are still
-- connected to information_schema.
-- =================================================================

-- every schema on this server. tutoring_db will not be in the list yet.
show databases;

-- make yours. IF NOT EXISTS means it is safe to run twice.
create database if not exists tutoring_db;

-- switch into it, so everything below lands in the right place.
use tutoring_db;

SELECT DATABASE();

-- ======================================================================
-- THE SPREADSHEET. One row per tutoring session. Look at the students
-- column: every student who came is crammed into one cell.
-- ======================================================================

CREATE TABLE tutoring_sheet (
    session_id   INT,
    session_date DATE,
    room         VARCHAR(10),
    tutor_id     INT,
    tutor_name   VARCHAR(40),
    tutor_email  VARCHAR(60),
    course_code  VARCHAR(10),
    course_title VARCHAR(40),
    students     VARCHAR(200)
);
INSERT INTO tutoring_sheet VALUES (101, '2026-09-08', 'LIB 110', 501, 'Maya Chen', 'maya.chen@tutor.edu', 'CIS 2000', 'Information Systems', '1001 Ana Lopez (CIS), 1003 Chloe Nguyen (CIS)');
INSERT INTO tutoring_sheet VALUES (102, '2026-09-08', 'LIB 112', 502, 'Omar Haddad', 'omar.haddad@tutor.edu', 'ACC 2100', 'Financial Accounting', '1002 Ben Ortiz (Accounting)');
INSERT INTO tutoring_sheet VALUES (103, '2026-09-10', 'LIB 110', 501, 'Maya Chen', 'maya.chen@tutor.edu', 'MATH 1600', 'Statistics', '1001 Ana Lopez (CIS), 1004 Dev Patel (Biology), 1005 Elena Ruiz (Undeclared)');
INSERT INTO tutoring_sheet VALUES (104, '2026-09-15', 'LIB 112', 502, 'Omar Haddad', 'omar.haddad@tutor.edu', 'ACC 2100', 'Financial Accounting', '1002 Ben Ortiz (Accounting), 1005 Elena Ruiz (Undeclared)');
INSERT INTO tutoring_sheet VALUES (105, '2026-09-17', 'LIB 110', 503, 'Priya Shah', 'priya.shah@tutor.edu', 'CIS 2000', 'Information Systems', '1003 Chloe Nguyen (CIS), 1004 Dev Patel (Biology)');
INSERT INTO tutoring_sheet VALUES (106, '2026-09-22', 'LIB 114', 501, 'Maya Chen', 'maya.chen@tutor.edu', 'CIS 2000', 'Information Systems', '1001 Ana Lopez (CIS)');

-- CHECK. Six rows, sessions 101 to 106.
SELECT * FROM tutoring_sheet;


-- ######################################################################
-- YOUR DESIGN LAB 1 WORK STARTS BELOW THIS LINE
--
-- LABELING AND COMMENTING IS REQUIRED. It is worth a full point.
-- ######################################################################


-- =================================================================
-- STEP 3. Ask the spreadsheet two questions
--
-- Copy the queries from the handout. Answer the question in a comment.
-- =================================================================

-- Count how many tutoring sessions Ana Lopez attended.
SELECT COUNT(*)
FROM tutoring_sheet
WHERE students LIKE '%Ana Lopez%';

-- Count the total number of rows in the tutoring spreadsheet.
SELECT COUNT(*)
FROM tutoring_sheet;

/*
COUNT cannot count each student because the students
column contains multiple names in one cell. SQL sees
each row as one record instead of counting each
student separately. This violates First Normal Form
because each cell should contain only one value.
*/


-- =================================================================
-- STEP 4. First normal form, one value per cell
--
-- Write the CREATE TABLE. Then run the DATA FOR STEP 4 block below it.
-- =================================================================

SELECT *
FROM tutoring_1nf;

SELECT DATABASE();
SHOW TABLES;

SELECT COUNT(*) AS total_visits
FROM tutoring_1nf;
SELECT * FROM tutoring_1nf;

-- Check that all 11 student visits were added.
SELECT COUNT(*) AS total_visits
FROM tutoring_1nf;

-- Create a new table where each student has their own row
-- for every tutoring session they attended.
CREATE TABLE tutoring_1nf (
    session_id INT NOT NULL,
    session_date DATE,
    room VARCHAR(10),
    tutor_id INT,
    tutor_name VARCHAR(40),
    tutor_email VARCHAR(60),
    course_code VARCHAR(10),
    course_title VARCHAR(40),
    student_id INT NOT NULL,
    student_name VARCHAR(40),
    student_major VARCHAR(30),
    rating INT,
    PRIMARY KEY (session_id, student_id)
);

-- Check that all 11 student visits were inserted.
SELECT COUNT(*) AS total_visits
FROM tutoring_1nf;

-- Count how many sessions each student attended.
SELECT
    student_name,
    COUNT(*) AS sessions
FROM tutoring_1nf
GROUP BY student_id, student_name
ORDER BY student_name;

-- ----------------------------------------------------------------------
-- DATA FOR STEP 4. Run these eleven INSERTs AFTER your CREATE TABLE for
-- tutoring_1nf. They only work if your columns are in the same order as
-- the table in the handout. One row per student per session.
-- ----------------------------------------------------------------------

INSERT INTO tutoring_1nf VALUES (101, '2026-09-08', 'LIB 110', 501, 'Maya Chen', 'maya.chen@tutor.edu', 'CIS 2000', 'Information Systems', 1001, 'Ana Lopez', 'CIS', 5);
INSERT INTO tutoring_1nf VALUES (101, '2026-09-08', 'LIB 110', 501, 'Maya Chen', 'maya.chen@tutor.edu', 'CIS 2000', 'Information Systems', 1003, 'Chloe Nguyen', 'CIS', 4);
INSERT INTO tutoring_1nf VALUES (102, '2026-09-08', 'LIB 112', 502, 'Omar Haddad', 'omar.haddad@tutor.edu', 'ACC 2100', 'Financial Accounting', 1002, 'Ben Ortiz', 'Accounting', 3);
INSERT INTO tutoring_1nf VALUES (103, '2026-09-10', 'LIB 110', 501, 'Maya Chen', 'maya.chen@tutor.edu', 'MATH 1600', 'Statistics', 1001, 'Ana Lopez', 'CIS', 4);
INSERT INTO tutoring_1nf VALUES (103, '2026-09-10', 'LIB 110', 501, 'Maya Chen', 'maya.chen@tutor.edu', 'MATH 1600', 'Statistics', 1004, 'Dev Patel', 'Biology', 5);
INSERT INTO tutoring_1nf VALUES (103, '2026-09-10', 'LIB 110', 501, 'Maya Chen', 'maya.chen@tutor.edu', 'MATH 1600', 'Statistics', 1005, 'Elena Ruiz', 'Undeclared', 2);
INSERT INTO tutoring_1nf VALUES (104, '2026-09-15', 'LIB 112', 502, 'Omar Haddad', 'omar.haddad@tutor.edu', 'ACC 2100', 'Financial Accounting', 1002, 'Ben Ortiz', 'Accounting', 4);
INSERT INTO tutoring_1nf VALUES (104, '2026-09-15', 'LIB 112', 502, 'Omar Haddad', 'omar.haddad@tutor.edu', 'ACC 2100', 'Financial Accounting', 1005, 'Elena Ruiz', 'Undeclared', 3);
INSERT INTO tutoring_1nf VALUES (105, '2026-09-17', 'LIB 110', 503, 'Priya Shah', 'priya.shah@tutor.edu', 'CIS 2000', 'Information Systems', 1003, 'Chloe Nguyen', 'CIS', 5);
INSERT INTO tutoring_1nf VALUES (105, '2026-09-17', 'LIB 110', 503, 'Priya Shah', 'priya.shah@tutor.edu', 'CIS 2000', 'Information Systems', 1004, 'Dev Patel', 'Biology', 4);
INSERT INTO tutoring_1nf VALUES (106, '2026-09-22', 'LIB 114', 501, 'Maya Chen', 'maya.chen@tutor.edu', 'CIS 2000', 'Information Systems', 1001, 'Ana Lopez', 'CIS', 5);



-- =================================================================
-- STEP 5. Make a copy to break
-- =================================================================

-- Make a copy of the 1NF table so we can test
-- database problems without changing the original.
CREATE TABLE anomaly_copy AS
SELECT *
FROM tutoring_1nf;

-- Count the records copied into anomaly_copy.
SELECT COUNT(*) AS total_rows
FROM anomaly_copy;

-- =================================================================
-- STEP 6. The update problem
--
-- Copy the UPDATE from the handout. Answer the question in a comment.
-- =================================================================


-- Change Maya Chen's email for session 101 only.
UPDATE anomaly_copy
SET tutor_email = 'maya.chen@campus.edu'
WHERE session_id = 101;
-- Check whether Maya now has different email addresses.
SELECT DISTINCT tutor_id, tutor_name, tutor_email
FROM anomaly_copy
WHERE tutor_id = 501;
/*
The new email is supposed to be correct, but the table
still shows Maya with two different email addresses.
Someone looking at the database would not know which
one is current because the information is inconsistent.
This happens because the same information is stored
in multiple records.
*/


-- =================================================================
-- STEP 7. The insert problem
--
-- Write the INSERT. Copy the error into a comment.
-- =================================================================


-- Try adding a new course without a tutoring session.
INSERT INTO anomaly_copy (course_code, course_title)
VALUES ('CIS 4720', 'Database Management');
/*
Step 7 - Insert Anomaly

Error: Field 'session_id' doesn't have a default value.

The database cannot store a new course by itself
because the original table requires session information.
This is an insert anomaly because a course should be
able to exist even if nobody has attended a tutoring
session for it yet.
*/


-- =================================================================
-- STEP 8. The delete problem
--
-- Write the DELETE and the check. Answer the question in a comment.
-- =================================================================


-- Delete all records for tutoring session 103.
DELETE FROM anomaly_copy
WHERE session_id = 103;
-- Check which courses are still recorded after the deletion.
SELECT DISTINCT course_code, course_title
FROM anomaly_copy;
/*
Step 8 - Delete Anomaly

I only wanted to delete tutoring session 103 because
it was entered incorrectly. However, deleting those
records also removed the only information about
MATH 1600. This shows how deleting one type of
information can accidentally remove something else
when everything is stored in the same table.
*/
SELECT COUNT(*) AS total_rows
FROM anomaly_copy;


-- =================================================================
-- STEP 9. Find the dependencies, and design third normal form
--
-- Answer in comments. Use the template in the handout.
-- =================================================================


/*
STEP 9: FUNCTIONAL DEPENDENCIES

The original table uses a composite primary key
(session_id, student_id).

Column              Determined By        Dependency
------------------------------------------------------------
session_date        session_id           Partial
room                session_id           Partial
tutor_id            session_id           Partial
tutor_name          tutor_id             Transitive
tutor_email         tutor_id             Transitive
course_code         session_id           Partial
course_title        course_code          Transitive
student_name        student_id           Partial
student_major       student_id           Partial
rating              session_id and       Full
                    student_id

The partial dependencies happen because some columns
only depend on one part of the composite key.

The transitive dependencies happen because tutor_name,
tutor_email, and course_title depend on other non-key
columns instead of directly on the primary key.

The rating has a full dependency because it belongs
to a specific student attending a specific session.
*/


/*
STEP 9: THIRD NORMAL FORM DESIGN

The session table still violates 3NF because tutor_name
and tutor_email depend on tutor_id, while course_title
depends on course_code.

To fix this, I would separate tutor information into
a tutor table and course information into a course table.

The final design will have five tables:

1. student
   PK: student_id
   Columns: student_name, student_major

2. tutor
   PK: tutor_id
   Columns: tutor_name, tutor_email

3. course
   PK: course_code
   Columns: course_title

4. session
   PK: session_id
   FK: tutor_id references tutor(tutor_id)
   FK: course_code references course(course_code)
   Columns: session_date, room

5. attendance
   PK: (session_id, student_id)
   FK: session_id references session(session_id)
   FK: student_id references student(student_id)
   Columns: rating

This design removes repeated information by keeping
student, tutor, and course details in their own tables.

The attendance table connects students with sessions.
*/


-- =================================================================
-- STEP 10. Build the five tables
--
-- Order matters: a table that is pointed at must exist first.
-- =================================================================


/* STEP 10: BUILD THE FIVE TABLES */

-- Create the student table to store each student's information.
CREATE TABLE student (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(40) NOT NULL,
    student_major VARCHAR(30)
);

-- Create the tutor table to store tutor information separately.
CREATE TABLE tutor (
    tutor_id INT PRIMARY KEY,
    tutor_name VARCHAR(40) NOT NULL,
    tutor_email VARCHAR(60) UNIQUE
);

-- Create the course table to store each course only once.
CREATE TABLE course (
    course_code VARCHAR(10) PRIMARY KEY,
    course_title VARCHAR(40) NOT NULL
);

-- Create the session table and connect it to tutors and courses.
CREATE TABLE session (
    session_id INT PRIMARY KEY,
    session_date DATE NOT NULL,
    room VARCHAR(10),
    tutor_id INT NOT NULL,
    course_code VARCHAR(10) NOT NULL,
    FOREIGN KEY (tutor_id) REFERENCES tutor(tutor_id),
    FOREIGN KEY (course_code) REFERENCES course(course_code)
);

-- Create the attendance bridge table to connect students and sessions.
CREATE TABLE attendance (
    session_id INT NOT NULL,
    student_id INT NOT NULL,
    rating INT,
    PRIMARY KEY (session_id, student_id),
    FOREIGN KEY (session_id) REFERENCES session(session_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

-- Check that all five normalized tables were created.
SHOW TABLES;
-- Verify the primary and foreign keys in the attendance table.
SHOW CREATE TABLE attendance;


-- =================================================================
-- STEP 11. Load the five tables from tutoring_1nf
-- =================================================================

-- Check how many student visits are in the original table.
SELECT COUNT(*) AS total_visits
FROM tutoring_1nf;


/* STEP 11: LOAD THE FIVE TABLES */

-- Copy each student into the student table without duplicates.
INSERT INTO student (student_id, student_name, student_major)
SELECT DISTINCT student_id, student_name, student_major
FROM tutoring_1nf;

-- Copy each tutor into the tutor table without duplicates.
INSERT INTO tutor (tutor_id, tutor_name, tutor_email)
SELECT DISTINCT tutor_id, tutor_name, tutor_email
FROM tutoring_1nf;

-- Copy each course into the course table without duplicates.
INSERT INTO course (course_code, course_title)
SELECT DISTINCT course_code, course_title
FROM tutoring_1nf;

-- Copy each tutoring session into the session table.
INSERT INTO session
(session_id, session_date, room, tutor_id, course_code)
SELECT DISTINCT
    session_id, session_date, room, tutor_id, course_code
FROM tutoring_1nf;

-- Copy each attendance record and its rating.
INSERT INTO attendance (session_id, student_id, rating)
SELECT session_id, student_id, rating
FROM tutoring_1nf;

-- Check how many records were loaded into each table.
SELECT 'student' AS table_name, COUNT(*) AS total FROM student
UNION ALL
SELECT 'tutor', COUNT(*) FROM tutor
UNION ALL
SELECT 'course', COUNT(*) FROM course
UNION ALL
SELECT 'session', COUNT(*) FROM session
UNION ALL
SELECT 'attendance', COUNT(*) FROM attendance;



-- =================================================================
-- STEP 12. Put the spreadsheet back together
--
-- Copy the view and the check from the handout.
-- =================================================================


/* STEP 12: REBUILD THE SPREADSHEET */

-- Create a view that combines all five normalized tables.
CREATE VIEW tutoring_rebuilt AS
SELECT
    se.session_id,
    se.session_date,
    se.room,
    t.tutor_id,
    t.tutor_name,
    t.tutor_email,
    c.course_code,
    c.course_title,
    st.student_id,
    st.student_name,
    st.student_major,
    a.rating
FROM attendance a
JOIN session se ON a.session_id = se.session_id
JOIN tutor t ON se.tutor_id = t.tutor_id
JOIN course c ON se.course_code = c.course_code
JOIN student st ON a.student_id = st.student_id;


-- Display the original tutoring information using the new view.
SELECT *
FROM tutoring_rebuilt;


-- Compare the original rows with the rebuilt view.
-- All 11 records should match.
SELECT COUNT(*) AS matching_rows
FROM tutoring_1nf o
JOIN tutoring_rebuilt r
    ON o.session_id = r.session_id
    AND o.student_id = r.student_id
WHERE o.session_date = r.session_date
    AND o.room = r.room
    AND o.tutor_email = r.tutor_email
    AND o.course_title = r.course_title
    AND o.student_name = r.student_name
    AND o.student_major = r.student_major
    AND o.rating = r.rating;




-- =================================================================
-- STEP 13. Show the three problems are gone
-- =================================================================


-- Update Maya Chen's email in the tutor table.
UPDATE tutor
SET tutor_email = 'maya.chen@campus.edu'
WHERE tutor_id = 501;

-- Check that Maya's sessions all show the same email.
SELECT DISTINCT tutor_email
FROM tutoring_rebuilt
WHERE tutor_id = 501;


-- Try deleting session 103 while attendance records still reference it.
DELETE FROM session
WHERE session_id = 103;


-- Verify that MATH 1600 still exists independently.
SELECT *
FROM course
WHERE course_code = 'MATH 1600';


/*
STEP 13: EXPLANATIONS

Update Anomaly:
Maya's email is now stored in one place, so changing
it in the tutor table updates the information shown
for all her tutoring sessions.

Insert Anomaly:
New courses can now be added directly into the course
table without needing a tutoring session or student
to already exist.

Delete Anomaly:
The foreign key prevents session 103 from being deleted
while attendance records still reference it. Course
information is also stored separately, so deleting a
session would not remove the course itself.
*/



-- =================================================================
-- STEP 14 and 15. Push to GitHub and submit the URL
--
-- Nothing to write here. Follow the handout.
-- =================================================================

-- your comment goes here
-- your statements go here
