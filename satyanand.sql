use employee;
select * from emp_record_table;
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT FROM emp_record_table;
-- Fetch employee details based on EMP_RATING
SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table WHERE EMP_RATING < 2 OR EMP_RATING > 4 OR (EMP_RATING >= 2 AND EMP_RATING <= 4);
-- Concatenate FIRST_NAME and LAST_NAME for Finance department
SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS NAME FROM emp_record_table WHERE DEPT = 'Finance';
-- List employees with subordinates
SELECT EMP_ID, FIRST_NAME, LAST_NAME FROM emp_record_table WHERE EMP_ID IN (SELECT MANAGER_ID FROM emp_record_table);
-- List employees from healthcare and finance departments using union
SELECT EMP_ID, FIRST_NAME, LAST_NAME FROM emp_record_table WHERE DEPT = 'Healthcare'
UNION
SELECT EMP_ID, FIRST_NAME, LAST_NAME FROM emp_record_table WHERE DEPT = 'Finance';
-- Employee details with max EMP_RATING per department
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING
FROM (
    SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING,
           MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS max_rating
    FROM emp_record_table
) AS subquery
WHERE EMP_RATING = max_rating;
-- Min and Max salary per role
SELECT ROLE, MIN(SALARY) AS MIN_SALARY, MAX(SALARY) AS MAX_SALARY FROM emp_record_table GROUP BY ROLE;
-- Rank employees based on experience
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EXP, RANK() OVER (ORDER BY EXP DESC) AS experience_rank
FROM emp_record_table;
-- Create a view for employees with salary > 6000
select * from emp_record_table;
create view emp_country as select emp_id, concat(first_name,' ', last_name), salary, country from employee.emp_record_table where salary > 6000;
select * from emp_country;
-- Nested query to find employees with experience > 10 years
select * from emp_record_table;
SELECT EMP_ID, FIRST_NAME, LAST_NAME FROM emp_record_table WHERE EXP > 10;
-- Stored procedure to retrieve details of employees with experience > 3 years
select * from emp_record_table;
DELIMITER //
CREATE PROCEDURE GetExperiencedEmployees()
BEGIN
    SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP
    FROM emp_record_table
    WHERE EXP > 3;
END //
DELIMITER ;

-- Function to assign job profiles in data science team
DELIMITER //
CREATE FUNCTION AssignJobProfile(experience INT) RETURNS VARCHAR(50)
BEGIN
    IF experience <= 2 THEN
        RETURN 'JUNIOR DATA SCIENTIST';
    ELSEIF experience <= 5 THEN
        RETURN 'ASSOCIATE DATA SCIENTIST';
    ELSEIF experience <= 10 THEN
        RETURN 'SENIOR DATA SCIENTIST';
    ELSEIF experience <= 12 THEN
        RETURN 'LEAD DATA SCIENTIST';
    ELSE
        RETURN 'MANAGER';
    END IF;
END //
DELIMITER ;

-- Create an index on the FIRST_NAME column
CREATE INDEX idx_first_name ON emp_record_table (FIRST_NAME);

-- Query to find employee with FIRST_NAME 'Eric'
SELECT *
FROM emp_record_table
WHERE FIRST_NAME = 'Eric';

-- Query to calculate bonus
SELECT EMP_ID, FIRST_NAME, LAST_NAME, SALARY, EMP_RATING,
       0.05 * SALARY * EMP_RATING AS bonus
FROM emp_record_table;

-- Query to calculate average salary distribution based on continent and country
delimiter //
create procedure get_emp ( in eid varchar(10), out role varchar (50))
begin
declare gain int default 1;
select exp into gain from employee.emp_record_table where emp_id = eid;
if gain <= 2 then set role = 'Junior Data Scientist';
elseif gain >2 and gain <= 5 then set role = 'Associate Data Scientist';
elseif gain >5 and gain <= 10 then set role = 'Senior Data Scientist';
elseif gain >10 and gain <=12 then set role = 'Lead Data Scientist';
elseif gain >12 and gain < 16 then set role = 'Manager';
else set role = 'President';
end if;
end //
select * from emp_record_table;
