CREATE OR REPLACE PACKAGE PKG_EMPLOYEE 
AS 
--******************************************************************************
--* Packaged code to manipulate employee data.
--* 
--*
--* Current Version:    1.0.0
--* Formatting:         Tab size 4
--*
--* No transaction handling in this package, all decisions to be made by
--* calling procedure unless explicitly mentioned otherwise
--*
--* REVISIONS:
--* Ver     Date         Author         Description
--* ------  -----------  -------------  ---------------------------------------
--* 1.0     06-Jun-2020  rfl            Created this package.
--******************************************************************************

    TYPE t_cursor IS REF CURSOR;

    PROCEDURE p_add_employee           ( i_employee_id       IN NUMBER
                                       , i_employee_name     IN VARCHAR2
                                       , i_job_title         IN VARCHAR2
                                       , i_manager_id        IN NUMBER
                                       , i_date_hired        IN DATE      DEFAULT sysdate
                                       , i_salary            IN NUMBER
                                       , i_department_id     IN NUMBER );


    PROCEDURE p_adjust_salary          ( i_employee_id       IN  NUMBER
                                       , i_percentage_change IN  NUMBER );


    PROCEDURE p_transfer_department    ( i_employee_id       IN  NUMBER
                                       , i_to_department_id  IN  NUMBER );


    FUNCTION p_get_employee_salary     ( i_employee_id       IN  NUMBER)  RETURN NUMBER;


    PROCEDURE p_list_single_employee   ( i_employee_id       IN  NUMBER
                                       , o_cur_employee      OUT t_cursor );


    PROCEDURE p_list_employees         ( o_cur_employees     OUT t_cursor );


    PROCEDURE p_list_employees_by_dept ( i_department_id     IN  NUMBER
                                       , o_cur_employees     OUT t_cursor );


    PROCEDURE p_list_employees_by_dept ( o_cur_employees     OUT t_cursor );


    PROCEDURE p_sum_salary_by_dept     ( i_department_id     IN  NUMBER
                                       , o_cur_dept_salary   OUT t_cursor );


    PROCEDURE p_sum_salary_by_dept     ( o_cur_dept_salary   OUT t_cursor );

        
END;