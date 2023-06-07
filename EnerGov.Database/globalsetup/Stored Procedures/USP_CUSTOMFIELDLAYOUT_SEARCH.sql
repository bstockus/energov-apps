﻿CREATE PROCEDURE [globalsetup].[USP_CUSTOMFIELDLAYOUT_SEARCH]
(
	@SEARCH AS NVARCHAR(MAX) = '',
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10,
	@IS_ASCENDING AS BIT = 1
)
AS
BEGIN
	SET NOCOUNT ON;
	WITH RAW_DATA AS (
		SELECT
			[dbo].[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS],
			[dbo].[CUSTOMFIELDLAYOUT].[SNAME],
			[dbo].[CUSTOMFIELDLAYOUT].[CUSTOMFIELDMODULEID],
			[dbo].[CUSTOMFIELDMODULES].[MODULENAME] AS MODULENAME,
			[dbo].[CUSTOMFIELDLAYOUT].[ISVERSION2] AS ISONLINE,
			CASE @IS_ASCENDING WHEN 1 THEN
				ROW_NUMBER() OVER(ORDER BY [dbo].[CUSTOMFIELDLAYOUT].[SNAME])
			ELSE
				ROW_NUMBER() OVER(ORDER BY [dbo].[CUSTOMFIELDLAYOUT].[SNAME] DESC)
			END AS RowNumber,
			COUNT(1) OVER() AS TotalRows
		FROM [dbo].[CUSTOMFIELDLAYOUT] 
		INNER JOIN [dbo].[CUSTOMFIELDMODULES]  ON [dbo].[CUSTOMFIELDMODULES].[CUSTOMFIELDMODULEID] = [dbo].[CUSTOMFIELDLAYOUT].[CUSTOMFIELDMODULEID]
		WHERE ([dbo].[CUSTOMFIELDLAYOUT].[SNAME] LIKE '%'+ @SEARCH +'%') OR
			  ([dbo].[CUSTOMFIELDMODULES].[MODULENAME] LIKE '%'+ @SEARCH +'%') OR
			  ([dbo].[CUSTOMFIELDLAYOUT].[ISVERSION2] = 1 AND ([dbo].[CUSTOMFIELDMODULES].[MODULENAME] + ' - online') LIKE '%'+ @SEARCH +'%')
	)

	SELECT * 
	FROM RAW_DATA
	WHERE
		RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
		RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
	ORDER BY 
		RowNumber

END