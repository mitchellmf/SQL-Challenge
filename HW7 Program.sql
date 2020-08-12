-- The foreign key code doesn't work so I didn't use it. 

-- CREATE TABLE "departments_test" (
--     "dept_no" varchar   NOT NULL,
-- 	"dept_name" varchar   NOT NULL,
-- 	FOREIGN KEY ("dept_no") references "dept_manager"("dept_no"),
-- 	FOREIGN KEY ("dept_no") references "dept_emp"("dept_no"),
-- 	PRIMARY KEY ("dept_no")
-- );

CREATE TABLE "departments" (
    "dept_no" varchar   NOT NULL,
	"dept_name" varchar   NOT NULL );

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" varchar   NOT NULL	);

CREATE TABLE "dept_manager" (
    "dept_no" varchar   NOT NULL , 
    "emp_no" int   NOT NULL	);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" varchar   NOT NULL,
    "birthdate" date   NOT NULL,
    "first_name" varchar   NOT NULL,
    "last_name" varchar   NOT NULL,
    "gender" varchar(1)   NOT NULL,
    "hire_date" date   NOT NULL	);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL	);

CREATE TABLE "titles" (
    "title_id" varchar   NOT NULL,
    "title" varchar   NOT NULL	);

-- Merge titles to the employees.
Create table whole as
	select employees.* , titles.title 
		from titles right join employees 
		on titles.title_id = employees.emp_title_id 
			order by emp_no ; 
select * from whole ; 	

-- Merge manager's departments to full dataset. 
Create table whole_mgr as
	select whole.* , dept_manager.dept_no 
		from whole right join dept_manager
		on whole.emp_no = dept_manager.emp_no  
			order by emp_no ;
select * from whole_mgr ; 

-- Merge non-manager's departments to full dataset. 
Create table whole_empe as
	select whole.* , dept_emp.dept_no 
		from whole right join dept_emp
		on whole.emp_no = dept_emp.emp_no  
			order by emp_no ;
select * from whole_empe ; 

-- Combine the managers with the non-managers.
create table whole_all as
	select * from whole_mgr 
		union all
	select * from whole_empe  ;  
select count(*) from whole_all ; 

-- Merge department names to full dataset.
Create table whole_all2 as
	select whole_all.* , departments.dept_name 
		from whole_all left join departments
		on whole_all.dept_no = departments.dept_no  
			order by emp_no ;
select count(*) from whole_all2 ; 	

-- Merge salaries to full dataset.
Create table whole_all3 as
	select whole_all2.* , salaries.salary 
		from whole_all2 left join salaries
		on whole_all2.emp_no = salaries.emp_no  
			order by emp_no ;
select count(*) from whole_all3 ; 	
select * from whole_all3 ; 	

-- Identify duplicates. 
select emp_no, count(emp_no) as count
	from whole_all3
	group by emp_no
	order by count desc; 

-- Q1
select emp_no, last_name, first_name, gender, salary from whole_all3 ; 

-- Q2
create table whole_all4 as
select * , CAST(hire_date AS varchar) as hire_date_text
from whole_all3 ; 

select first_name, last_name, hire_date
from whole_all4 
where substring(hire_date_text,1,4) = '1986' ; 

-- Q3
Create table whole_mgr2 as
	select whole_mgr.* , departments.dept_name 
		from whole_mgr left join departments
		on whole_mgr.dept_no = departments.dept_no  
			order by emp_no ;
select dept_no, dept_name, emp_no, last_name, first_name from whole_mgr2 ; 	

-- Q4
Create table whole_empe2 as
	select whole_empe.* , departments.dept_name 
		from whole_empe left join departments
		on whole_empe.dept_no = departments.dept_no  
			order by emp_no ;
select distinct(emp_no), last_name, first_name, dept_name  from whole_empe2 ; 	

-- Q5
	select first_name, last_name, gender
		from whole_all3
		WHERE last_name LIKE 'B%'
		order by emp_no ; 

-- Q6
	select emp_no, last_name, first_name, dept_name
		from whole_all3
		WHERE dept_name = 'Sales'
		order by emp_no ; 

-- Q7
	select emp_no, last_name, first_name, dept_name
		from whole_all3
		WHERE dept_name in ('Sales','Development')
		order by emp_no ; 

-- Q8
	select last_name, count(last_name) as count_lastname
		from whole_all3
		group by last_name
		order by count_lastname desc ; 
							
							
							
							
							
							





