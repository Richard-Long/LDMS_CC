CREATE OR REPLACE PACKAGE BODY PKG_DEPARTMENT 
AS

--******************************************************************************
--* Packaged code to manipulate Department data.
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
-- None

--------------------------------------------------------------------------------
--                  LOCAL PROCEDURE / FUNCTION DECLARATIONS                   --
--------------------------------------------------------------------------------

    -- Local proc as a wrapper to DBMS_OUTPUT
    --
    -- usually use this with some form of flag to control
    -- the type of logging seen, eg, no logs, just to screen or 
    -- to screen and persist to table
    --
    -- Table logging requires some housekeeping to be in place for it
    -- to be viable long term
    --

    procedure print (i_message IN CLOB) AS BEGIN dbms_output.put_line(i_message); END print;



--------------------------------------------------------------------------------
--                         PROCEDURE / FUNCTION CODE                          --
--------------------------------------------------------------------------------

PROCEDURE p_add_department ( i_department_id   IN NUMBER
                           , i_department_name IN VARCHAR2
                           , i_location        IN VARCHAR2
                           )
AS

BEGIN

    insert into DEPARTMENTS ( DEPARTMENT_ID
                            , DEPARTMENT_NAME
                            , LOCATION
                            )
                values
                            ( i_department_id    
                            , i_department_name  
                            , i_location
                            );

    print ('Department ID ( '||i_department_id||' ) added.');

    -- Our job here is to add the employee, we will let the calling function handle the
    -- transaction.
    -- Adding transaction control to this proc may not be usful for some use cases
    --

EXCEPTION
    -- Catch and process some specific exceptions and the catch-all
    --
    WHEN DUP_VAL_ON_INDEX 
        THEN 
            print ('Error in p_add_department - Department ID ( '||i_department_id||' ) already exists.');
            
    WHEN VALUE_ERROR 
        THEN 
            print ('Error in p_add_department - There is an incorrect data type '); RAISE;

    WHEN OTHERS 
        THEN 
            print ('Error in p_add_department - '||SQLERRM); RAISE;

END p_add_department;

--
--==============================================================================
--

PROCEDURE p_list_departments (o_cur_departments OUT t_cursor)
AS
BEGIN
    -- Collect all departments, can be used as a report function
    -- or as post dataload check
    --
    OPEN o_cur_departments
     FOR
         SELECT   Department_ID
                , Department_name
                , Location
           FROM 
                  departments
          ORDER BY
                  department_id;

END p_list_departments;

END PKG_DEPARTMENT;