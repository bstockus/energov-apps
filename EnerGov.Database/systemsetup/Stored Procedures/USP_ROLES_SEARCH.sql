﻿CREATE PROCEDURE [systemsetup].[USP_ROLES_SEARCH]
(
	@SEARCH AS NVARCHAR(MAX) = '',
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10,
	@IS_ASCENDING AS BIT = 1
)
AS
WITH RAW_DATA AS (
	SELECT
		[dbo].[ROLES].[SROLEGUID],
		[dbo].[ROLES].[ID] AS ROLENAME,
		[dbo].[ROLES].[SDESCRIPTION],
		CASE @IS_ASCENDING WHEN 1 THEN
			ROW_NUMBER() OVER(ORDER BY [dbo].[ROLES].[ID])
		ELSE
			ROW_NUMBER() OVER(ORDER BY [dbo].[ROLES].[ID] DESC)
		END AS RowNumber,
		COUNT(1) OVER() AS TotalRows
	FROM [dbo].[ROLES]	
	WHERE [dbo].[ROLES].[ID] LIKE '%'+ @SEARCH +'%' OR [dbo].[ROLES].[SDESCRIPTION] LIKE '%'+ @SEARCH +'%'
)

SELECT * 
FROM RAW_DATA
WHERE
	RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
	RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY 
	RowNumber