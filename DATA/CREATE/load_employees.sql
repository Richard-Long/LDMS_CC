set serveroutput on
begin
    -- Just as we deliberately loaded the department data first, I've chosen to load the employee
    -- data in this order so that dependent FK references are in place prior to referenceing them
    -- and so that I can use the procedure
    --
    -- Hire date is wrapped with my date mask rather than assuming that it will be the default date mask in
    -- the target DB
    --
    pkg_employee.p_add_employee(9001, 'John Smith',    'CEO',         null, TO_DATE('01-Jan-1995','DD-Mon-YYYY'), 100000, 1);
    pkg_employee.p_add_employee(9002, 'Jimmy Willis',  'Manager',     9001, TO_DATE('23-Sep-2003','DD-Mon-YYYY'), 52500,  4);
    pkg_employee.p_add_employee(9003, 'Roxy Jones',    'Salesperson', 9002, TO_DATE('11-Feb-2017','DD-Mon-YYYY'), 35000,  4);
    pkg_employee.p_add_employee(9004, 'Selwyn Field',  'Salesperson', 9003, TO_DATE('20-May-2015','DD-Mon-YYYY'), 32000,  4);
    pkg_employee.p_add_employee(9006, 'Sarah Phelps',  'Manager',     9001, TO_DATE('21-Mar-2015','DD-Mon-YYYY'), 40000,  2);
    pkg_employee.p_add_employee(9005, 'David Hallett', 'Engineer',    9006, TO_DATE('17-Apr-2018','DD-Mon-YYYY'), 45000,  2);
    pkg_employee.p_add_employee(9007, 'Louise Harper', 'Engineer',    9006, TO_DATE('01-Jan-2013','DD-Mon-YYYY'), 47000,  2);
    pkg_employee.p_add_employee(9009, 'Gus Jones',     'Manager',     9001, TO_DATE('15-May-2018','DD-Mon-YYYY'), 45000,  3);
    pkg_employee.p_add_employee(9008, 'Tina Hart',     'Engineer',    9009, TO_DATE('28-Jul-2014','DD-Mon-YYYY'), 50000,  3);
    pkg_employee.p_add_employee(9010, 'Mildred Hall',  'Secretary',   9001, TO_DATE('12-Oct-1996','DD-Mon-YYYY'), 35000,  1);
    commit;
end;

