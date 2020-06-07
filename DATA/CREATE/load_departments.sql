
-- add in all the departments
-- disabling define here because of the ampersand in the data to be inserted
--
set define off
begin
    pkg_department.p_add_department(1, 'Management',             'London');
    pkg_department.p_add_department(2, 'Engineering',            'Cardiff');
    pkg_department.p_add_department(3, 'Research & Development', 'Edinburgh');
    pkg_department.p_add_department(4, 'Sales',                  'Belfast');

    commit;
END;
set define on
