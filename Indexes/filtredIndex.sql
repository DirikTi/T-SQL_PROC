-- When we want to use filtred Indexes, The SET options in the required Value column are required

/*
Create a filtered index.

INSERT, UPDATE, DELETE, or MERGE operation modifies the data in a filtered index.

The filtered index is used by the query optimizer to produce the query plan.

*/

CREATE NONCLUSTERED INDEX fIX_tablename_ColumnName
ON tablename (ColumnName)
WHERE amount > 2000 --(statement)


-- Advantages

/*

Reduced index maintenance costs. Insert, update, delete, and merge operations are not as expensive, since a filtered index is smaller and does not require as much time for reorganization or rebuilding.

Reduced storage cost. The smaller size of a filtered index results in a lower overall index storage requirement.

More accurate statistics. Filtered index statistics cover only the rows the meet the WHERE criteria, so in general, they are more accurate than full-table statistics.

Optimized query performance. Because filtered indexes are smaller and have more accurate statistics, queries and execution plans are more efficient.

*/

-- Limitations

/*
Statistics may not get updated often enough, depending on how often filtered column data is changed. Because of how SQL Server decides when to update statistics (when about 20% of a column’s data has been modified), statistics could become quite out of date. The solution to this issue is to set up a job to run UPDATE STATISTICS more frequently.

Filtered indexes cannot be created on views. However, a filtered index on the base table of a view will still optimize a view’s query.

XML indexes and full-text indexes cannot be filtered. Only nonclustered indexes are able to take advantage of the WHERE clause.

The WHERE clause of a filtered index will accept simple predicates only.

*/