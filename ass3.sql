create database companydb2;
use companydb2;

CREATE TABLE Departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) UNIQUE NOT NULL
);

-- Create the Employees table
CREATE TABLE Employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    hire_date DATE NOT NULL,
    salary INT NOT NULL,
    dept_id INT
);

ALTER TABLE Employees ADD FOREIGN KEY (dept_id) REFERENCES Departments(dept_id);

-- insert data into Departments table
INSERT INTO Departments (dept_name) VALUES
('IT'),
('HR'),
('Finance'),
('Marketing'),
('Operations');

-- insert data into Employees table
INSERT INTO Employees (first_name, last_name, email, hire_date, salary, dept_id) VALUES
('Amit', 'Sharma', 'amit.sharma@example.com', '2022-01-15', 60000.00, 1),
('Priya', 'Verma', 'priya.verma@example.com', '2021-07-20', 75000.00, 2),
('Rohit', 'Patel', 'rohit.patel@example.com', '2020-03-12', 80000.00, 3),
('Sneha', 'Iyer', 'sneha.iyer@example.com', '2019-06-25', 90000.00, 1),
('Vikram', 'Singh', 'vikram.singh@example.com', '2023-02-10', 55000.00, NULL); -- No department

-- --------------------------------------------------------------------------------------

-- Q1. Calculate Total Salary per Department Develop a function that accepts a department ID and returns the total salary of employees in that department.
 delimiter //
 drop function getsal//
 create function getsal(did int ) returns int
 deterministic
 begin	
	declare psal int default 0;
    
	select sum(salary) into psal 
	from  Employees 
	where dept_id = did;
    
	return psal;
end //

delimiter ;
select getsal(2);

-- Q2. Find Employee Experience in Years Create a function that takes an employee ID as input and calculates the number of years the employee has worked in the company based on their hire date.
delimiter //
drop function getExp//
create function getExp(eid int ) returns int
deterministic
begin
	declare empexp int default 0;

	select timestampdiff(year, hire_date, curdate()) into empexp 
	from Employees
	where emp_id = eid;

	return empexp;
end //

delimiter ;
select getExp(2);


-- Q3. Retrieve Department Name Using Employee ID Write a function that takes an employee ID and returns the name of the department the employee belongs to.
delimiter //
drop function getDept//
create function getDept(eid int ) returns varchar(50)
deterministic
begin
	declare deptname varchar(50);
    
    select d.dept_name into deptname
    from Employees e
    join Departments d on e.dept_id = d.dept_id
    where e.emp_id = eid;
    
    return deptname;
end //

delimiter ;
select getDept(2);

-- Q4. Identify the Highest-Paid Employee in a Department  Create a function that accepts a department ID and returns the name of the highest-paid employee in that department.
delimiter //
drop function getHP//
create function getHP(did int ) returns varchar(50)
deterministic
begin
	declare highpaid varchar(50);
    
    select first_name into highpaid
    from Employees
    where dept_id = did
    order by salary desc 
    limit 1;
    
    return highpaid;
end //

delimiter ;
select getHP(3);

-- Q5. Count Employees in a Department Develop a function that takes a department ID as input and returns the total number of employees working in that department.
delimiter //
drop function getcountEmp//
create function getcountEmp(did int ) returns int
deterministic
begin
	declare countemp int;
    
    select count(*) into countemp
    from Employees
    where dept_id = did;
    
    return countemp;
end //

delimiter ;
select getcountEmp(3);