create database lion ;
use lion;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10,2)
);

CREATE TABLE employee_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    action VARCHAR(255),  -- Increased size to accommodate longer concat messages
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 

-- Populate initial data
INSERT INTO employees (emp_id, name, salary)
VALUES
(1, 'Amit', 50000.00),
(2, 'Neha', 62000.00),
(3, 'Ravi', 45000.00),
(4, 'Priya', 70000.00);


-- ==========================================
-- 2. TRIGGERS AND TESTING
-- ==========================================

-- 1. Trigger to log insert activity
CREATE TRIGGER trg_after_insert_employee
AFTER INSERT ON employees
FOR EACH ROW
INSERT INTO employee_log(emp_id, action)
VALUES (NEW.emp_id, 'Employee Inserted');

-- Test 1 (Using ID 5 to avoid duplicate primary key)
INSERT INTO employees VALUES (5, 'Vikram', 55000);


-- 2. Trigger to Log Employee Delete
CREATE TRIGGER trg_after_delete_employee
AFTER DELETE ON employees
FOR EACH ROW
INSERT INTO employee_log(emp_id, action)
VALUES (OLD.emp_id, 'Employee Deleted');

-- Test 2
DELETE FROM employees WHERE emp_id = 1;


-- 3. Trigger to Log Salary Update
CREATE TRIGGER trg_after_salary_update
AFTER UPDATE ON employees
FOR EACH ROW
INSERT INTO employee_log(emp_id, action)
VALUES (NEW.emp_id, 'Salary Updated');

-- Test 3
UPDATE employees SET salary = 60000 WHERE emp_id = 2;


-- 4. Trigger to Prevent Negative Salary
DELIMITER //

CREATE TRIGGER trg_before_insert_salary
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END //

DELIMITER ;

-- Test 4 (This should fail intentionally)
INSERT INTO employees VALUES (6, 'Rohit', -5000);


-- 5. Trigger to Automatically Increase Salary by 10%
CREATE TRIGGER trg_before_insert_bonus
BEFORE INSERT ON employees
FOR EACH ROW
SET NEW.salary = NEW.salary * 1.10;

-- Test 5 (Inserting 50000, but it will save as 55000)
INSERT INTO employees VALUES (7, 'Anjali', 50000);


-- 6. Trigger to Store Old and New Salary Change
CREATE TRIGGER trg_salary_change
AFTER UPDATE ON employees
FOR EACH ROW
INSERT INTO employee_log(emp_id, action)
VALUES (
    NEW.emp_id,
    CONCAT('Salary changed from ', OLD.salary, ' to ', NEW.salary)
);

-- Test 6
UPDATE employees SET salary = 70000 WHERE emp_id = 3;


-- 7. Trigger to Convert Employee Name to Uppercase
CREATE TRIGGER trg_uppercase_name
BEFORE INSERT ON employees
FOR EACH ROW
SET NEW.name = UPPER(NEW.name); 

-- Test 7 (Will insert as 'RAHUL')
INSERT INTO employees VALUES (8, 'rahul', 30000);


-- 8. Trigger to Restrict Salary Reduction
DELIMITER //

CREATE TRIGGER trg_prevent_salary_reduce
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < OLD.salary THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary reduction not allowed';
    END IF;
END //

DELIMITER ;

-- Test 8 (This should fail intentionally)
UPDATE employees SET salary = 20000 WHERE emp_id = 4; 


-- 9. Trigger to Log Name Changes
DELIMITER //

CREATE TRIGGER trg_name_change
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF OLD.name <> NEW.name THEN
        INSERT INTO employee_log(emp_id, action)
        VALUES (NEW.emp_id, 'Employee Name Changed');
    END IF;
END //

DELIMITER ;

-- Test 9
UPDATE employees SET name = 'Karan' WHERE emp_id = 4;

-- 10. Add default salary
DELIMITER //

CREATE TRIGGER trg_default_salary
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary IS NULL THEN
        SET NEW.salary = 20000;
    END IF;
END //

DELIMITER ;

-- Test
INSERT INTO employees(emp_id,name,salary)
VALUES (22,'Simran',NULL);

SELECT * 
FROM employees
WHERE emp_id = 22;

-- 11.Trigger to Store Promotions
CREATE TABLE promotions(
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2)
);

DELIMITER //

CREATE TRIGGER trg_promotion
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary > OLD.salary THEN
        INSERT INTO promotions
        VALUES(
            NEW.emp_id,
            OLD.salary,
            NEW.salary
        );
    END IF;
END //

DELIMITER ;

-- Test
UPDATE employees
SET salary=90000
WHERE emp_id=4;



-- 12. Trigger to Prevent Salary = 0
DELIMITER //

CREATE TRIGGER trg_salary_zero
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Salary cannot be zero';
    END IF;
END //

DELIMITER ;

-- Test
INSERT INTO employees VALUES (16,'Neha',0);

-- 13. Trigger to Prevent Empty Name
DELIMITER //

CREATE TRIGGER trg_empty_name
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.name='' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Name cannot be empty';
    END IF;
END //

DELIMITER ;

-- Test
INSERT INTO employees VALUES (14,'',25000);


-- 14. Trigger to Prevent Salary Less Than 10000

DELIMITER //

CREATE TRIGGER trg_min_salary
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 10000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT='Minimum salary is 10000';
    END IF;
END //

DELIMITER ;

-- Test
INSERT INTO employees VALUES (13,'Karan',5000);

-- 15. Add Employee Grade Automatically
ALTER TABLE employees
ADD grade CHAR(1);

DELIMITER //

CREATE TRIGGER trg_employee_grade
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary >= 70000 THEN
        SET NEW.grade = 'A';
    ELSEIF NEW.salary >= 40000 THEN
        SET NEW.grade = 'B';
    ELSE
        SET NEW.grade = 'C';
    END IF;
END //

DELIMITER ;
	
-- Test
INSERT INTO employees(emp_id,name,salary)
VALUES (20,'Rohan',80000);
SELECT * FROM employees WHERE emp_id=20;

SELECT * FROM promotions;
SELECT * FROM employees;
SELECT * FROM employee_log;