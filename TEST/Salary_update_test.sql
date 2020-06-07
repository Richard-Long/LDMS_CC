-- List the employee before the salary update
-- 
variable c1 REFCURSOR
col employee_name format a24
col job_title     format a24
col manager_name  format a24
exec pkg_employee.p_list_single_employee(9001, :c1);
print :c1

-- Make the salary update
--
set serveroutput on
BEGIN
    pkg_employee.p_adjust_salary(9001, -12.5);  -- Cut but 12.5%
    commit;
END;

-- Adjust missing employee
-- no rows to update but should not throw an exception
--
BEGIN
    pkg_employee.p_adjust_salary(99, -12.5);  -- Cut but 12.5%
    commit;
END;

--Check the employee now that we have made the adjustment
--
--exec pkg_employee.p_list_single_employee(9001, :c1);
--print :c1

select pkg_employee.p_get_employee_salary (9001) AS employee_salary
  from dual;


