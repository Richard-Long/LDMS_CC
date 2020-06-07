create or replace PACKAGE PKG_DEPARTMENT
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


    TYPE t_cursor IS REF CURSOR;

    PROCEDURE p_add_department ( i_department_id   IN NUMBER
                               , i_department_name IN VARCHAR2
                               , i_location        IN VARCHAR2
                               );

    PROCEDURE p_list_departments (o_cur_departments OUT t_cursor);
 
END;