
--List all employees in dept 4
--
set serveroutput on
variable c1 REFCURSOR
col employee_name format a24
col job_title     format a24
col manager_name  format a24
col department_name  format a24

exec pkg_employee.p_list_employees_by_dept(4,:c1);

print :c1    

--List all employees in all departments
--
set serveroutput on
variable c1 REFCURSOR
col employee_name format a24
col job_title     format a24
col manager_name  format a24
col department_name  format a24

exec pkg_employee.p_list_employees_by_dept(:c1);

print :c1    


--List all employees in fictional dept 99
--
set serveroutput on
variable c1 REFCURSOR
col employee_name format a24
col job_title     format a24
col manager_name  format a24
col department_name  format a24

exec pkg_employee.p_list_employees_by_dept(99,:c1);

print :c1    

