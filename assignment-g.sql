create database compdb;
use compdb;

CREATE TABLE employees (
    id INT,
    name varchar(30),
    department varchar(10),
    salary int
);

INSERT INTO employees (id,name,department,salary) VALUES
(1, 'Alice','HR',50000),
(2, 'Bob', 'IT',700000),
(3, 'Charlie','IT',60000),
(4, 'David','HR',550000),
(5, 'Eve','Finance',65000);

#create a procedure to show all employees details
delimiter //
create procedure displayemployees()
begin
    select * from employees;
end //
delimiter ;

call displayemployees();

#create a stored procedure to fetch all employees from a specific department
delimiter //
create procedure departmentemployees(in dept_name varchar(50))
begin
    select * from employees
    where department = dept_name;
end //
delimiter ;

call departmentemployees('HR');

#create a stored procedure to increase salary by a given percentage for a department
delimiter //
create procedure hikesalary(
    in dept_name varchar(50),
    in percent_increase decimal(5,2)
)
begin
    update employees
    set salary = salary + (salary * percent_increase / 100)
    where department = dept_name;
end //
delimiter ;

set sql_safe_updates=0;

call hikesalary('HR',20);

#create a procedure to return the total salary of all employees
delimiter //
create procedure totalsalaryemployees()
begin
    select sum(salary) from employees;
end //
delimiter ;

call totalsalaryemployees();

#create a procedure to insert a new employee
delimiter //
create procedure insertemployee(
    in emp_name varchar(50),
    in emp_dept varchar(50),
    in emp_salary int
)
begin
    insert into employees(name,department,salary)
    values (emp_name,emp_dept,emp_salary);
end //
delimiter ;

call insertemployee('Jupyter','Finance',78000);

select * from employees;

#create a procedure to delete an existing employee from the table
delimiter //
create procedure removeemployee(in emp_id int)
begin
    delete from employees
    where id = emp_id;
end //
delimiter ;

call removeemployee(7);

#create a procedure to return average salary
delimiter //
create procedure averagesalary()
begin
    select avg(salary) from employees;
end //
delimiter ;

call averagesalary();

#create a procedure to get employees above a salary
delimiter //
create procedure highsalaryemployees(in salary_emp int)
begin
    select * from employees
    where salary > salary_emp;
end //
delimiter ;

call highsalaryemployees(96000);

#create a procedure to get highest salary
delimiter //
create procedure maximumsalary()
begin
    select max(salary) from employees;
end //
delimiter ;

call maximumsalary();

#create a procedure to update employee name
delimiter //
create procedure updateemployeename(
    in emp_name varchar(50),
    in id_emp int
)
begin
    update employees
    set name = emp_name
    where id = id_emp;
end //
delimiter ;

call updateemployeename('Venus',1);

select * from employees;