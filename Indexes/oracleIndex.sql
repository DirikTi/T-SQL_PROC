-- ORACLE

-- Bitmap 
/*

    Advantages –  
    Efficiency in terms of insertion deletion and updation.
    Faster retrieval of records

    Disadvantages – 
    Only suitable for large tables
    Bitmap Indexing is time consuming

*/
CREATE TABLE Employee (
    id NUMBER NOT NULL,
    name VARCHAR(100) NOT NULL,
    job VARCHAR(100) NOT NULL,
    new_emp BOOLEAN DEFAULT YES,
    salary NUMBER NOT NULL
);

CREATE BITMAP INDEX index_New_Emp ON Employee (new_emp);

-- Important Notes 
/*
    Parallel DML is currently only supported on the fact table. Parallel DML on one of the participating dimension tables will mark the index as unusable.
    Only one table can be updated concurrently by different transactions when using the bitmap join index.
    No table can appear twice in the join.
    You cannot create a bitmap join index on an index-organized table or a temporary table.
    The columns in the index must all be columns of the dimension tables.
    The dimension table join columns must be either primary key columns or have unique constraints.
    If a dimension table has composite primary key, each column in the primary key must be part of the join
*/


-- Function-based Indexes
CREATE TABLE user_data (
    id          NUMBER(10)    NOT NULL,
    first_name  VARCHAR2(40)  NOT NULL,
    last_name   VARCHAR2(40)  NOT NULL,
    gender      VARCHAR2(1),
    dob         DATE
);

CREATE INDEX first_name_idx ON user_data (UPPER(first_name));

SELECT *
FROM   user_data
WHERE  UPPER(first_name) = 'JOHN2';