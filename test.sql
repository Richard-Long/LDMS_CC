-- This file assumes that you are already connected to the DB
-- and have run the install.sql and load.sql files 
-- to create the required objects and load the specified data
--
whenever sqlerror continue
-- List and test the departments data and code
--
@ ./TEST/List_and_test_departments.sql	

-- List and test the employees data and code
--
@ ./TEST/List_and_test_employees.sql	

-- Test adjusting the salary of an employee
--
@ ./TEST/Salary_update_test.sql		

-- Test transferring an employee to a different department
--
@ ./TEST/transfer_employee_test.sql
