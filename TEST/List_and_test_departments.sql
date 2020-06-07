-- 
-- List all of the departments
--
variable c1 REFCURSOR
exec pkg_department.p_list_departments(:c1);
print :c1


-- Test some of the error handling
--

-- duplicate key
--
set serveroutput on
exec pkg_department.p_add_department(1, 'Management', 'London');

-- Incorrect data type, caught by SQL not the code
--
set serveroutput on
exec pkg_department.p_add_department('ONE', 'Management', 'London');


-- null value
--
set serveroutput on echo off
exec pkg_department.p_add_department(1, 'Management', NULL);

