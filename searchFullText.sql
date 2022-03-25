USE [Wordexp]
GO
/****** Object:  StoredProcedure [dbo].[searchAlg]    Script Date: 26.03.2022 02:00:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<ASIKUS>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[searchAlg]
@searchWord VARCHAR(100)
AS
BEGIN
	DECLARE @RESULT bit;
	DECLARE @SPLIT_VALUES_SEARCH_TABLE TABLE (
		id INT IDENTITY(1,1),
		value char(100)
	);


	INSERT INTO @SPLIT_VALUES_SEARCH_TABLE (value) 
	SELECT value FROM STRING_SPLIT(@searchWord, ' ')

	IF 1=(
			SELECT COUNT(*) 
			FROM @SPLIT_VALUES_SEARCH_TABLE
		)
	BEGIN
		SELECT TOP 50 id, name, description 
		FROM V_CATEGORIES
		WHERE CHARINDEX(@searchWord, name) > 0 OR CHARINDEX(@searchWord, description) > 0
		ORDER BY CASE
			WHEN name=@searchWord THEN 1
			WHEN name LIKE @searchWord + '%' THEN 2
			WHEN name LIKE '%' + @searchWord THEN 3
			WHEN name LIKE '%' + @searchWord + '%' THEN 4
			ELSE 5
		END

	END
	ELSE
	BEGIN

		SELECT TOP 50 a.id, a.name, a.description
		FROM V_CATEGORIES a
		INNER JOIN STRING_SPLIT(@searchWord, ' ') ON CHARINDEX(value, name) > 0
		ORDER BY CASE
			WHEN name=@searchWord THEN 1
			WHEN name LIKE value + '%' THEN 2
			WHEN name LIKE '%' + value THEN 3
			WHEN name LIKE '%' + value + '%' THEN 4
			ELSE 5
		END
		
		
		
	END
	


END
