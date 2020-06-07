-- This file assumes that you are already connected to the DB
-- as a user with create privs and quota on its default tablespace
--

-- Create the tables
--

-- Department table
--
@ ./DB/TABLES/CREATE/DEPARTMENTS.sql

-- Employee table
--
@ ./DB/TABLES/CREATE/EMPLOYEES.sql


-- Department Package
--
@ ./DB/PACKAGES/PKG_DEPARTMENT.pks
@ ./DB/PACKAGES/PKG_DEPARTMENT.pkb

-- Employee Package
--
@ ./DB/PACKAGES/PKG_EMPLOYEE.pks
@ ./DB/PACKAGES/PKG_EMPLOYEE.pkb

