-- List all of the employees
--
variable c1 REFCURSOR
col employee_name format a24
col job_title     format a24
col manager_name  format a24
exec pkg_employee.p_list_employees(:c1);
print :c1

-- Test some of the error handling
--
-- duplicate key
--
set serveroutput on
exec pkg_employee.p_add_employee(9010, 'Mildred Hall',  'Secretary',   9001, TO_DATE('12-Oct-1996','DD-Mon-YYYY'), 35000,  1);

-- Incorrect data type, caught by SQL not the code
--
set serveroutput on
exec pkg_employee.p_add_employee('NineZeroOneZero', 'Mildred Hall',  'Secretary',   9001, TO_DATE('12-Oct-1996','DD-Mon-YYYY'), 35000,  1);

-- null value for Job_title
--
set serveroutput on
exec pkg_employee.p_add_employee(9010, 'Mildred Hall',  NULL,   9001, TO_DATE('12-Oct-1996','DD-Mon-YYYY'), 35000,  1);

-- Out of range date_hired
--
set serveroutput on
exec pkg_employee.p_add_employee(9011, 'Mildred Hall',  NULL,   9001, TO_DATE('31-Nov-1996','DD-Mon-YYYY'), 35000,  1);

-- Out of range employee_id
--
set serveroutput on
exec pkg_employee.p_add_employee (12345678901, 'Mildred Hall',  NULL,   9001, TO_DATE('12-Oct-1996','DD-Mon-YYYY'), 35000,  1);

-- Department does not exist
--
set serveroutput on
exec pkg_employee.p_add_employee (1, 'Jolly Roger',  'Pirate',   9001, TO_DATE('12-Oct-1996','DD-Mon-YYYY'), 135000,  99);

-- Manager does not exist
--
set serveroutput on
exec pkg_employee.p_add_employee (1, 'Jolly Roger',  'Pirate',   99, TO_DATE('12-Oct-1996','DD-Mon-YYYY'), 135000,  1);



