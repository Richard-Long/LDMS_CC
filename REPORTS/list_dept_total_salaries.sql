
--List total salary for dept 4
--
set serveroutput on
variable c1 REFCURSOR
col department_name  format a24
col TOTAL_DEPARTMENT_SALARY format 999,999,999

exec pkg_employee.p_sum_salary_by_dept(4,:c1);

print :c1    

--List total salary for ALL departments
--
set serveroutput on
variable c1 REFCURSOR
col department_name  format a24
col TOTAL_DEPARTMENT_SALARY format 999,999,999

exec pkg_employee.p_sum_salary_by_dept(:c1);

print :c1    



--List total salary for missing dept 99
--
set serveroutput on
variable c1 REFCURSOR
col department_name  format a24
col TOTAL_DEPARTMENT_SALARY format 999,999,999

exec pkg_employee.p_sum_salary_by_dept(99,:c1);

print :c1    

