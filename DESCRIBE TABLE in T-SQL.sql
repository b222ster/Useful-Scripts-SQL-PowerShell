DECLARE @tableName nvarchar(100)
SET @tableName = '[dbo].[BigBangEpisodes]' -- change with table name
SELECT
    [column].*,
    COLUMNPROPERTY(object_id([column].[TABLE_NAME]), [column].[COLUMN_NAME], 'IsIdentity') AS [identity]
FROM 
    INFORMATION_SCHEMA.COLUMNS [column] 
WHERE
    [column].[Table_Name] = @tableName