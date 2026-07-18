# Library Management System using SQL Project --P2

## Project Overview

**Project Title**: Library Management System
**Level**: Intermediate
**Database**: `library_db`

This project demonstrates the implementation of a Library Management System using SQL. It includes creating and managing tables, performing CRUD operations, and executing advanced SQL queries. The goal is to showcase skills in database design, manipulation, and querying.

**Objectives**
Set up the Library Management System Database: Create and populate the database with tables for branches, employees, members, books, issued status, and return status.
CRUD Operations: Perform Create, Read, Update, and Delete operations on the data.
CTAS (Create Table As Select): Utilize CTAS to create new tables based on query results.
Advanced SQL Queries: Develop complex queries to analyze and retrieve specific data.

## Project Structure
**1. DataBase Setup**
<img width="893" height="785" alt="image" src="https://github.com/user-attachments/assets/a437ac29-2a0d-40cf-b794-6c678e0e1c76" />

**Database Creation**: Created a database named library_db.
**Table Creation**: Created tables for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships.

```sql
CREATE DATABASE library_db;

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);


-- Create table "Employee"
DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


-- Create table "Members"
DROP TABLE IF EXISTS members;
CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);



-- Create table "Books"
DROP TABLE IF EXISTS books;
CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);



-- Create table "IssueStatus"
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);



-- Create table "ReturnStatus"
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);
```

### 2. CRUD Operations
**Create**: Inserted sample records into the books table.
**Read**: Retrieved and displayed data from various tables.
**Update**: Updated records in the employees table.
**Delete**: Removed records from the members table as needed.

**Task 1. Create a New Book Record** -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
```sql
INSERT INTO books (isbn,book_title,category,rental_price,status,author,publisher) VALUES
	(
		'978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'
    );
```

**Task 2: Update an Existing Member's Address**
```sql
UPDATE members SET member_address = '125 Oak st' WHERE member_id = 'C101';
```
**Task 3: Delete a Record from the Issued Status Table**
```sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
```

**Task 4: Retrieve All Books Issued by a Specific Employee**
```sql
SELECT *
FROM issued_status
WHERE issued_emp_id = 'E101';
```

**Task 5: List Members Who Have Issued More Than One Book**
```sql
SELECT
    issued_emp_id,
    COUNT(issued_book_name) AS cnt
FROM issued_status
GROUP BY issued_emp_id
HAVING cnt > 1;
```
### 3. CTAS (Create Table As Select)

**Task 6: Create a Summary Table Using CTAS (Books and Total Issued Count)**
```sql
CREATE TABLE books_cnt AS
SELECT
    b.isbn,
    b.book_title,
    COUNT(ist.issued_id) AS total_issued_count
FROM books AS b
JOIN issued_status AS ist
ON b.isbn = ist.issued_book_isbn
GROUP BY b.isbn, b.book_title;
```
### 3. CTAS (Create Table As Select)
The following SQL queries were used to address specific questions:

**Task 7: Retrieve All Books in a Specific Category**
```sql
SELECT *
FROM books
WHERE category = 'Children';
```

**Task 8: Find Total Rental Income by Category**
```sql
SELECT
    b.category,
    SUM(b.rental_price) AS total_rental_income
FROM books AS b
JOIN issued_status AS ist
ON b.isbn = ist.issued_book_isbn
GROUP BY b.category;
```

**Task 9: List Members Who Registered in the Last 180 Days**
```sql
SELECT *
FROM members
WHERE reg_date >= CURRENT_DATE() - INTERVAL 180 DAY;
```

**Task 10: List Employees with Their Branch Manager's Name and Branch Details**
```sql
SELECT
    e.*,
    b.manager_id,
    e2.emp_name AS manager_name
FROM employees AS e
JOIN branch AS b
ON e.branch_id = b.branch_id
JOIN employees AS e2
ON b.manager_id = e2.emp_id;
```

**Task 11: Create a Table of Books with Rental Price Above a Certain Threshold**
```sql
CREATE TABLE price_above_6 AS
SELECT *
FROM books
WHERE rental_price >= 6;
```

**Task 12: Retrieve the List of Books Not Yet Returned**
```sql
SELECT ist.*
FROM issued_status AS ist
LEFT JOIN return_status AS rs
USING (issued_id)
WHERE rs.issued_id IS NULL;
```

### Advanced SQL Operations

**Task 13: Identify Members with Overdue Books**

Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's ID, member's name, book title, issue date, and days overdue.

```sql
SELECT
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    DATEDIFF(CURRENT_DATE(), ist.issued_date) AS days_overdue
FROM issued_status AS ist
JOIN books AS bk
ON ist.issued_book_isbn = bk.isbn
JOIN members AS m
ON ist.issued_member_id = m.member_id
LEFT JOIN return_status AS rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL
  AND DATEDIFF(CURRENT_DATE(), ist.issued_date) > 30
ORDER BY ist.issued_member_id;
```

---

**Task 14: Update Book Status on Return**

Write a query to update the status of books in the `books` table to **"Yes"** when they are returned (based on entries in the `return_status` table).

```sql
DELIMITER $$

CREATE PROCEDURE return_book(
    IN p_return_id VARCHAR(10),
    IN p_issued_id VARCHAR(10),
    IN p_book_quality VARCHAR(10)
)
BEGIN
    DECLARE v_isbn VARCHAR(20);
    DECLARE v_book_name VARCHAR(75);

    INSERT INTO return_status
        (return_id, issued_id, return_date, book_quality)
    VALUES
        (p_return_id, p_issued_id, CURDATE(), p_book_quality);

    SELECT
        issued_book_isbn,
        issued_book_name
    INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'Yes'
    WHERE isbn = v_isbn;

    SELECT CONCAT('Thanks for returning the book ', v_book_name) AS Message;
END $$

DELIMITER ;

CALL return_book('RS119', 'IS130', 'Good');
```

---

**Task 15: Branch Performance Report**

Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

```sql
CREATE TABLE branch_reports AS
SELECT
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) AS number_book_issued,
    COUNT(rs.return_id) AS number_of_books_returned,
    SUM(bk.rental_price) AS total_revenue
FROM issued_status AS ist
JOIN employees AS e
ON e.emp_id = ist.issued_emp_id
JOIN branch AS b
ON e.branch_id = b.branch_id
LEFT JOIN return_status AS rs
ON rs.issued_id = ist.issued_id
JOIN books AS bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY b.branch_id, b.manager_id;
```

---

**Task 16: Create a Table of Active Members (CTAS)**

Use the `CREATE TABLE AS (CTAS)` statement to create a new table `active_members` containing members who have issued at least one book in the last **2 months**.

```sql
CREATE TABLE active_members AS
SELECT *
FROM members
WHERE member_id IN (
    SELECT DISTINCT issued_member_id
    FROM issued_status
    WHERE DATEDIFF(CURDATE(), issued_date) <= 60
);
```

---

**Task 17: Find Employees with the Most Book Issues Processed**

Write a query to find the top **3 employees** who have processed the most book issues. Display the employee name, number of books processed, and their branch.

```sql
SELECT
    e.emp_name,
    COUNT(ist.issued_id) AS num_books,
    b.branch_address
FROM issued_status AS ist
LEFT JOIN employees AS e
ON ist.issued_emp_id = e.emp_id
LEFT JOIN branch AS b
ON e.branch_id = b.branch_id
GROUP BY ist.issued_emp_id
ORDER BY COUNT(ist.issued_id) DESC
LIMIT 3;
```

---

**Task 18: Identify Members Issuing High-Risk Books**

Write a query to identify members who have issued books more than twice with the status **"Damaged"**. Display the member name, book title, and the number of times they've issued damaged books.

```sql
SELECT
    m.member_name,
    ist.issued_book_name,
    d.damaged_count
FROM issued_status AS ist
JOIN members AS m
ON ist.issued_member_id = m.member_id
JOIN return_status AS rs
ON ist.issued_id = rs.issued_id
JOIN (
    SELECT
        ist.issued_member_id,
        COUNT(*) AS damaged_count
    FROM issued_status AS ist
    JOIN return_status AS rs
    ON ist.issued_id = rs.issued_id
    WHERE rs.book_quality = 'Damaged'
    GROUP BY ist.issued_member_id
    HAVING COUNT(*) > 2
) AS d
ON ist.issued_member_id = d.issued_member_id
WHERE rs.book_quality = 'Damaged';
```

---

**Task 19: Create a Stored Procedure to Manage Book Status**

Create a stored procedure to manage the status of books in a library system.

The stored procedure should:
- Take the book ISBN and issue details as input.
- Check whether the book is available (`status = 'Yes'`).
- If available, issue the book and update its status to `No`.
- Otherwise, return a message indicating that the book is currently unavailable.

```sql
DELIMITER $$

CREATE PROCEDURE manage_status(
    IN p_issued_id VARCHAR(10),
    IN p_issued_member_id VARCHAR(10),
    IN p_issued_book_isbn VARCHAR(30),
    IN p_issued_emp_id VARCHAR(10)
)
BEGIN
    DECLARE v_status VARCHAR(10);

    SELECT status
    INTO v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN

        INSERT INTO issued_status
            (issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES
            (p_issued_id, p_issued_member_id, CURDATE(), p_issued_book_isbn, p_issued_emp_id);

        UPDATE books
        SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        SELECT CONCAT('Book record is added successfully with ISBN: ', p_issued_book_isbn) AS Message;

    ELSE

        SELECT CONCAT('SORRY! Book is currently unavailable. ISBN: ', p_issued_book_isbn) AS Message;

    END IF;

END $$

DELIMITER ;

CALL manage_status('IS141', 'C106', '978-0-307-58837-1', 'E106');
```

---

**Task 20: Create a CTAS Query to Calculate Overdue Book Fines**

Create a CTAS query to identify overdue books and calculate fines.

The resulting table should include:
- Member ID
- Number of overdue books
- Total fine (calculated at **$0.50 per day** after the first 30 days)

```sql
CREATE TABLE fine_on_books AS
SELECT
    ist.issued_member_id,
    COUNT(*) AS overdue_books,
    SUM((DATEDIFF(CURDATE(), ist.issued_date) - 30) * 0.50) AS total_fine
FROM issued_status AS ist
LEFT JOIN return_status AS rs
ON ist.issued_id = rs.issued_id
WHERE rs.issued_id IS NULL
  AND DATEDIFF(CURDATE(), ist.issued_date) > 30
GROUP BY ist.issued_member_id;
```
## Reports

**Database Schema**: Detailed table structures and relationships.
**Data Analysis**: Insights into book categories, employee salaries, member registration trends, and issued books.
**Summary Reports**: Aggregated data on high-demand books and employee performance.

## Conclusion
This project demonstrates the application of SQL skills in creating and managing a library management system. It includes database setup, data manipulation, and advanced querying, providing a solid foundation for data management and analysis.

