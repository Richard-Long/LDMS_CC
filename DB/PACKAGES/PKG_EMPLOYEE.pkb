create or replace PACKAGE BODY PKG_EMPLOYEE 
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
--* General philosophy is that all actions will succeed most of the time.
--* So, instead of checking prior to the principal action of the proc
--* we shall assume that the action will complete without issue and instead
--* we will catch any errors and deal with them on an individual basis
--*
--* This leaves the code clean and free of many decision points.  The benefits
--* are that the code is easy to read and maintain and much easier to test
--*
--* And it runs faster!
--*
--* These are small procs but even these, when subjected to high concurrency
--* or throughput will falter if we instigate a check before we update paradigm
--*
--*
--* REVISIONS:
--* Ver     Date         Author         Description
--* ------  -----------  -------------  ---------------------------------------
--* 1.0     06-Jun-2020  rfl            Created this package.
--******************************************************************************
--------------------------------------------------------------------------------
--                           PACKAGE BODY TYPES                               --
--------------------------------------------------------------------------------
-- None

--------------------------------------------------------------------------------
--                           PACKAGE BODY CONSTANTS                           --
--------------------------------------------------------------------------------
-- None

--------------------------------------------------------------------------------
--                           PACKAGE BODY VARIABLES                           --
--------------------------------------------------------------------------------
-- None

--------------------------------------------------------------------------------
--                           PACKAGE BODY EXCEPTIONS                          --
--------------------------------------------------------------------------------

E_FK_LOOKUP_FAILED     EXCEPTION;

-- ORA-02291 is the standard Oracle defined FK failed error
-- Redefining it here so that reference in the code makes some sense
--

PRAGMA EXCEPTION_INIT(E_FK_LOOKUP_FAILED,  -02291);

-- Constants for Exception numbers
--
CE_FK_LOOKUP_FAILED    NUMBER := -02291 ;

--------------------------------------------------------------------------------
--                  LOCAL PROCEDURE / FUNCTION DECLARATIONS                   --
--------------------------------------------------------------------------------

-- Local Procedures
--

    -- Local proc as a wrapper to DBMS_OUTPUT
    --
    -- usually use this with some form of external flag to control
    -- the type of logging seen, eg, no logs, just to screen or 
    -- to screen and persist to table
    --
    -- Table logging requires some housekeeping to in place for it
    -- to be viable long term
    --

    procedure print (i_message IN CLOB) AS BEGIN dbms_output.put_line(i_message); END print;


--------------------------------------------------------------------------------
--                         PROCEDURE / FUNCTION CODE                          --
--------------------------------------------------------------------------------

PROCEDURE p_add_employee ( i_employee_id    IN NUMBER
                         , i_employee_name  IN VARCHAR2
                         , i_job_title      IN VARCHAR2
                         , i_manager_id     IN NUMBER
                         , i_date_hired     IN DATE         DEFAULT sysdate
                         , i_salary         IN NUMBER
                         , i_department_id  IN NUMBER
                         )
AS
BEGIN

    -- Insert one row into the employees table using
    -- the parameters passed in.
    -- Hire date is defaulted as part of the proc signature to account
    -- for possible omission.  Others are not null 

    insert into employees ( EMPLOYEE_ID
                          , EMPLOYEE_NAME
                          , JOB_TITLE
                          , MANAGER_ID
                          , DATE_HIRED
                          , SALARY
                          , DEPARTMENT_ID
                          )
                values
                          ( i_employee_id    
                          , i_employee_name  
                          , i_job_title     
                          , i_manager_id     
                          , i_date_hired     
                          , i_salary         
                          , i_department_id
                          );

    -- Our job here is to add the employee, we will let the calling function handle the
    -- transaction.
    -- Adding transaction control to this proc may not be usful for some use cases
    --

EXCEPTION
    -- Catch, deal with and re-raise any problems as required
    --
    WHEN DUP_VAL_ON_INDEX 
        THEN 
            print ('Error in p_add_employee - Employee ID ( '||i_employee_id||' ) already exists.');

    WHEN VALUE_ERROR 
        THEN 
            print ('Error in p_add_employee - There is an incorrect data type '); RAISE;

    WHEN E_FK_LOOKUP_FAILED
        THEN 
            print ('Error in p_add_employee - Manager '||i_manager_id||' OR Department '|| i_department_id|| ' do not exist.');

    WHEN OTHERS 
        THEN 
            print ('Error in p_add_employee - '||SQLERRM); raise;

END p_add_employee;

--
--==============================================================================
--


PROCEDURE p_adjust_salary ( i_employee_id        IN NUMBER
                          , i_percentage_change  IN NUMBER
                          )
AS

-- Adjust employee salary by defined percentage
-- The percentage can be negative or positive
-- Round out the result to 2DP

BEGIN

    UPDATE employees
       SET salary = round(salary + salary*(i_percentage_change/100),2)
     WHERE employee_id = i_employee_id;
    
EXCEPTION
    -- Catch, deal with and re-raise any problems as required
    --
    WHEN NO_DATA_FOUND 
        THEN 
            print ('Error in p_adjust_salary - Employee ID ( '||i_employee_id||' ) does not exist.');

    WHEN VALUE_ERROR 
        THEN 
            print ('Error in p_adjust_salary - There is an incorrect data type '); RAISE;

    WHEN OTHERS 
        THEN 
            print ('Error in p_adjust_salary - '||SQLERRM); raise;

END p_adjust_salary;

--
--==============================================================================
--

PROCEDURE p_transfer_department ( i_employee_id        IN NUMBER
                                , i_to_department_id   IN NUMBER
                                )
AS

-- Transfer an employee from their current department
-- to their new department
--

BEGIN

    UPDATE employees
       SET department_id = i_to_department_id
     WHERE employee_id   = i_employee_id;


EXCEPTION
    -- Catch, deal with and re-raise any problems as required
    --
    WHEN NO_DATA_FOUND 
        THEN 
            print ('Error in p_transfer_department - Employee ID ( '||i_employee_id||' ) does not exist.');

    WHEN VALUE_ERROR 
        THEN 
            print ('Error in p_transfer_department - There is an incorrect data type '); RAISE;

    WHEN E_FK_LOOKUP_FAILED
        THEN 
            print ('Error in p_transfer_department - Department '||i_to_department_id||' does not exist.');

    WHEN OTHERS 
        THEN 
            print ('Error in p_transfer_department - '||SQLERRM); raise;

END p_transfer_department;
--
--==============================================================================
--

FUNCTION p_get_employee_salary ( i_employee_id IN NUMBER) 
  RETURN 
  NUMBER
AS
    v_return_value NUMBER;
BEGIN

    SELECT salary
      INTO v_return_value
      FROM employees
     WHERE employee_id=i_employee_id;

    RETURN (v_return_value);

EXCEPTION
    -- Catch, deal with and re-raise any problems as required
    --
    WHEN NO_DATA_FOUND 
        THEN 
            print ('Error in p_get_employee_salary - Employee ID ( '||i_employee_id||' ) does not exist.');
            RETURN (NULL);

    WHEN VALUE_ERROR 
        THEN 
            print ('Error in p_get_employee_salary - There is an incorrect data type '); RAISE;

    WHEN OTHERS 
        THEN 
            print ('Error in p_get_employee_salary - '||SQLERRM); raise;

END p_get_employee_salary;

--
--==============================================================================
--

PROCEDURE p_list_employees (o_cur_employees OUT t_cursor)
AS
BEGIN

    -- Post data insert, or any other time, list out all employees and 
    -- do the FK lookups for manager name and department name
    --
    -- NOTE: Manager name join is outer because the manager_id can be null
    --

    OPEN o_cur_employees
     FOR
         SELECT  e.employee_id
               , e.employee_name
               , e.job_title
               , m.employee_name   AS manager_name
               , e.date_hired
               , e.salary
               , d.department_name AS department_name
          FROM
                 employees   e
               , departments d
               , employees   m
         WHERE
                 d.department_id   = e.department_id
           AND   m.employee_id (+) = e.manager_id
         ORDER BY
                 e.employee_id;


END p_list_employees ;

--
--==============================================================================
--

PROCEDURE p_list_single_employee ( i_employee_id    IN NUMBER
                                 , o_cur_employee  OUT t_cursor)
AS
BEGIN

    -- list out employee and do the FK lookups for manager name and department name
    --
    -- NOTE: Manager name join is outer because the manager_id can be null
    --

    OPEN o_cur_employee
     FOR
         SELECT  e.employee_id
               , e.employee_name
               , e.job_title
               , m.employee_name   AS manager_name
               , e.date_hired
               , e.salary
               , d.department_name AS department_name
          FROM
                 employees   e
               , departments d
               , employees   m
         WHERE
                 d.department_id   = e.department_id
           AND   m.employee_id (+) = e.manager_id
           AND   e.employee_id     = i_employee_id
         ORDER BY
                 e.employee_id;


END p_list_single_employee ;

--
--==============================================================================
--

-- List employees by department
--
-- These procs are overloaded because the spec is a touch ambiguous
-- as it is currently written.  
--
-- List all employes by a specified department
--
-- OR list all employees but group them by department
--

PROCEDURE p_list_employees_by_dept ( i_department_id     IN  NUMBER
                                   , o_cur_employees     OUT t_cursor )
AS

    -- List all employees by specified department
    --

BEGIN

    OPEN o_cur_employees
     FOR
         SELECT  d.department_name AS department_name
               , e.employee_id
               , e.employee_name
               , e.job_title
               , m.employee_name   AS manager_name
               , e.date_hired
               , e.salary
          FROM
                 employees   e
               , departments d
               , employees   m
         WHERE
                 d.department_id   = e.department_id
           AND   m.employee_id (+) = e.manager_id
           AND   d.department_id   = i_department_id
         ORDER BY
                 e.employee_id;


END;

PROCEDURE p_list_employees_by_dept ( o_cur_employees     OUT t_cursor )
AS
BEGIN

    -- List ALL employees and group by department
    --
    OPEN o_cur_employees
     FOR
         SELECT  d.department_name AS department_name
               , e.employee_id
               , e.employee_name
               , e.job_title
               , m.employee_name   AS manager_name
               , e.date_hired
               , e.salary
          FROM
                 employees   e
               , departments d
               , employees   m
         WHERE
                 d.department_id   = e.department_id
           AND   m.employee_id (+) = e.manager_id
         ORDER BY
                 d.department_id
               , e.employee_id;
    
END;



--
--==============================================================================
--

PROCEDURE p_sum_salary_by_dept     ( i_department_id     IN  NUMBER
                                   , o_cur_dept_salary  OUT t_cursor )
AS
BEGIN

    -- Summ salary for the department passed in.
    --
    -- The select fails silently ie no rows, for any departments that do not exist
    --

    OPEN o_cur_dept_salary
     FOR 
         SELECT  d.department_name AS department_name
               , sum(e.salary)     AS total_department_salary
          FROM
                 employees   e
               , departments d
         WHERE
                 d.department_id = e.department_id
           AND   d.department_id = i_department_id
         GROUP BY
                 d.department_name;    


END;


PROCEDURE p_sum_salary_by_dept     ( o_cur_dept_salary  OUT t_cursor )
as
BEGIN

    -- List all departments and the total salary for each
    --

    OPEN o_cur_dept_salary
     FOR 
         SELECT  d.department_name AS department_name
               , sum(e.salary)     AS total_department_salary
          FROM
                 employees   e
               , departments d
         WHERE
                 d.department_id = e.department_id
         GROUP BY
                 d.department_name
         ORDER BY
                 d.department_name;    

END;


END PKG_EMPLOYEE;