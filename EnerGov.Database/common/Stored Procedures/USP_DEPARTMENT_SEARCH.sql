﻿CREATE PROCEDURE [common].[USP_DEPARTMENT_SEARCH]
(
	@SEARCH AS NVARCHAR(MAX) = '',
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10,
	@IS_ASCENDING AS BIT = 1
)
AS
WITH RAW_DATA AS (
	SELECT
		[dbo].[DEPARTMENT].[DEPARTMENTID],
		[dbo].[DEPARTMENT].[NAME],
		CASE @IS_ASCENDING WHEN 1 THEN
			ROW_NUMBER() OVER(ORDER BY [dbo].[DEPARTMENT].[NAME])
		ELSE
			ROW_NUMBER() OVER(ORDER BY [dbo].[DEPARTMENT].[NAME] DESC)
		END AS RowNumber,
		COUNT(1) OVER() AS TotalRows
	FROM [dbo].[DEPARTMENT]
	WHERE ([dbo].[DEPARTMENT].[NAME] LIKE '%'+ @SEARCH +'%')
)

SELECT * 
FROM RAW_DATA
WHERE
	RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
	RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY 
	RowNumber