CREATE TABLE DEPARTMENTS 
    (	
        DEPARTMENT_ID       NUMBER(5,0)         NOT NULL ENABLE, 
        DEPARTMENT_NAME     VARCHAR2(50 BYTE)   NOT NULL ENABLE, 
        LOCATION            VARCHAR2(50 BYTE)   NOT NULL ENABLE, 
        CONSTRAINT 
                DEPARTMENTS_PK PRIMARY KEY (DEPARTMENT_ID)
                USING INDEX 
                ENABLE
    )  
/
        
   COMMENT ON COLUMN DEPARTMENTS.DEPARTMENT_ID      IS 'The unique identifier for the department';
   COMMENT ON COLUMN DEPARTMENTS.DEPARTMENT_NAME    IS 'The name of the department';
   COMMENT ON COLUMN DEPARTMENTS.LOCATION           IS 'The physical location of the department';
