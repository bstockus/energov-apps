﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_OMOBJECTCLASSIFICATION_SEARCH]
(
	@SEARCH AS NVARCHAR(50) = '',
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10,
	@IS_ASCENDING AS BIT = 1
)
AS
WITH RAW_DATA AS (
	SELECT
		[dbo].[OMOBJECTCLASSIFICATION].[OMOBJECTCLASSIFICATIONID],
		[dbo].[OMOBJECTCLASSIFICATION].[NAME],				
		CASE @IS_ASCENDING WHEN 1 THEN
			ROW_NUMBER() OVER(ORDER BY [dbo].[OMOBJECTCLASSIFICATION].[NAME])
		ELSE
			ROW_NUMBER() OVER(ORDER BY [dbo].[OMOBJECTCLASSIFICATION].[NAME] DESC)
		END AS RowNumber,
		COUNT(1) OVER() AS TotalRows
	FROM [dbo].[OMOBJECTCLASSIFICATION]
	WHERE ([dbo].[OMOBJECTCLASSIFICATION].[NAME] LIKE '%'+ @SEARCH +'%')
)

SELECT * 
FROM RAW_DATA
WHERE
	RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
	RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY 
	RowNumber