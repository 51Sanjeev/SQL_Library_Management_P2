SET GLOBAL local_infile = ON;
SHOW VARIABLES LIKE 'local_infile';
-- Load branch data 
LOAD DATA LOCAL INFILE 'E:/MYSQL/Library_Management_P2/branch.csv'
INTO TABLE branch
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @branch_id,
    @manager_id,
    @branch_address,
    @contact_no
)
SET
branch_id = NULLIF(@branch_id,''),
manager_id = NULLIF(@manager_id,''),
branch_address = NULLIF(@branch_address,''),
contact_no = NULLIF(@contact_no,'');

-- Load employees data
LOAD DATA LOCAL INFILE 'E:/MYSQL/Library_Management_P2/employees.csv'
INTO TABLE employees
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @emp_id,
    @emp_name,
    @position,
    @salary,
    @branch_id
)
SET
emp_id = NULLIF(@emp_id,''),
emp_name = NULLIF(@emp_name,''),
position = NULLIF(@position,''),
salary = NULLIF(@salary,''),
branch_id = NULLIF(@branch_id,''); 

-- Load books data
LOAD DATA LOCAL INFILE 'E:/MYSQL/Library_Management_P2/books.csv'
INTO TABLE books
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @isbn,
    @book_title,
    @category,
    @rental_price,
    @status,
    @author,
    @publisher
)
SET
isbn = NULLIF(@isbn,''),
book_title = NULLIF(@book_title,''),
category = NULLIF(@category,''),
rental_price = NULLIF(@rental_price,''),
status = NULLIF(@status,''),
author = NULLIF(@author,''),
publisher = NULLIF(@publisher,''); 

-- Load members
LOAD DATA LOCAL INFILE 'E:/MYSQL/Library_Management_P2/members.csv'
INTO TABLE members
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @member_id,
    @member_name,
    @member_address,
    @reg_date
)
SET
member_id = NULLIF(@member_id,''),
member_name = NULLIF(@member_name,''),
member_address = NULLIF(@member_address,''),
reg_date = NULLIF(@reg_date,'');

--  Load issued status of books
LOAD DATA LOCAL INFILE 'E:/MYSQL/Library_Management_P2/issued_status.csv'
INTO TABLE issued_status
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @issued_id,
    @issued_member_id,
    @issued_book_name,
    @issued_date,
    @issued_book_isbn,
    @issued_emp_id
)
SET
issued_id = NULLIF(@issued_id,''),
issued_member_id = NULLIF(@issued_member_id,''),
issued_book_name = NULLIF(@issued_book_name,''),
issued_date = NULLIF(@issued_date,''),
issued_book_isbn = NULLIF(@issued_book_isbn,''),
issued_emp_id = NULLIF(@issued_emp_id,'');

-- Load returnes status of books 

LOAD DATA LOCAL INFILE 'E:/MYSQL/Library_Management_P2/return_status.csv'
INTO TABLE return_status
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @return_id,
    @issued_id,
    @return_book_name,
    @return_date,
    @return_book_isbn
)
SET
return_id = NULLIF(@return_id,''),
issued_id = NULLIF(@issued_id,''),
return_book_name = NULLIF(@return_book_name,''),
return_date = NULLIF(@return_date,''),
return_book_isbn = NULLIF(@return_book_isbn,'');

