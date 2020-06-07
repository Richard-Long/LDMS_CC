-- List the employee before the transfer update
-- 
variable c1 REFCURSOR
col employee_name format a24
col job_title     format a24
col manager_name  format a24

--Check the employee before we make the adjustment
--
exec pkg_employee.p_list_single_employee(9009, :c1);
print :c1


-- Make the transfer update
--
BEGIN
    pkg_employee.p_transfer_department(9009, 1);  -- move to management
    commit;
END;
/

--Check the employee now that we have made the adjustment
--
exec pkg_employee.p_list_single_employee(9009, :c1);
print :c1



-- Make a transfer to a non-existant department
--
set serveroutput on
BEGIN
    pkg_employee.p_transfer_department(9009, 99);  -- 99 does not exist
    commit;
END;
/
-- Transfer a non-existant employee
--
set serveroutput on
BEGIN
    pkg_employee.p_transfer_department(99, 1);  -- 99 does not exist
    commit;
END;
/
