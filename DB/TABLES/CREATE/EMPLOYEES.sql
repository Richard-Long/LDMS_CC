CREATE TABLE EMPLOYEES 
        (	
            EMPLOYEE_ID     NUMBER(10,0)        NOT NULL ENABLE, 
            EMPLOYEE_NAME   VARCHAR2(50 BYTE)   NOT NULL ENABLE, 
            JOB_TITLE       VARCHAR2(50 BYTE)   NOT NULL ENABLE, 
            MANAGER_ID      NUMBER(10,0), 
            DATE_HIRED      DATE                NOT NULL ENABLE, 
            SALARY          NUMBER(10,0)        NOT NULL ENABLE, 
            DEPARTMENT_ID   NUMBER(5,0)         NOT NULL ENABLE, 
            CONSTRAINT 
                    EMPLOYEE_PK PRIMARY KEY (EMPLOYEE_ID)
                                USING INDEX 
                                ENABLE, 
            CONSTRAINT 
                    DEPT_FK     FOREIGN KEY (DEPARTMENT_ID)
                                REFERENCES 
                                    DEPARTMENTS (DEPARTMENT_ID) 
                                ENABLE, 
            CONSTRAINT 
                    EMP_MGR_FK  FOREIGN KEY (MANAGER_ID)
                                REFERENCES 
                                    EMPLOYEES (EMPLOYEE_ID) 
                                ON DELETE SET NULL 
                                ENABLE
        )  
/

   COMMENT ON COLUMN EMPLOYEES.EMPLOYEE_ID      IS 'The unique identifier for the employee';
   COMMENT ON COLUMN EMPLOYEES.EMPLOYEE_NAME    IS 'The name of the employee';
   COMMENT ON COLUMN EMPLOYEES.JOB_TITLE        IS 'The job role undertaken by the employee. Some employees may undertake the same job role';
   COMMENT ON COLUMN EMPLOYEES.MANAGER_ID       IS 'Line manager of the employee';
   COMMENT ON COLUMN EMPLOYEES.DATE_HIRED       IS 'The date the employee was hired';
   COMMENT ON COLUMN EMPLOYEES.SALARY           IS 'Current salary of the employee';
   COMMENT ON COLUMN EMPLOYEES.DEPARTMENT_ID    IS 'Each employee must belong to a department';


CREATE INDEX EMPLOYEE_DEPT_FK 
    ON 
        EMPLOYEES (DEPARTMENT_ID);
