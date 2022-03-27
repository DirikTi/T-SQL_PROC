-- Using SQL B-Tree Indexing
-- 
CREATE TABLE users (
    id int IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(100),
    email VARCHAR(100),
    password VARCHAR(100),
    city VARCHAR(100),
)

-- Unique indexes are not store duplicate datas
CREATE UNIQUE INDEX INDEX_USERS_EMAILUSERNAME ON users (email, username);

-- Indexes are created based on one table column. Only a single Btree (Binary Tree) is created for indexes
CREATE INDEX INDEX INDEX_USERS_COUNTRYCITY ON users (city);