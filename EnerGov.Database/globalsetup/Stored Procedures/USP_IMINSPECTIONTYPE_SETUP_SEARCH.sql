﻿CREATE PROCEDURE [globalsetup].[USP_IMINSPECTIONTYPE_SETUP_SEARCH]
(
	@SEARCH AS NVARCHAR(MAX) = '',
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10,
	@IS_ASCENDING AS BIT = 1
)
AS
WITH RAW_DATA AS (
	SELECT
		[dbo].[IMINSPECTIONTYPE].[IMINSPECTIONTYPEID],
		[dbo].[IMINSPECTIONTYPE].[NAME],
		[dbo].[IMINSPECTIONTYPE].[PREFIX],
		[dbo].[IMINSPECTIONTYPE].[DESCRIPTION],
		[dbo].[IMINSPECTIONTYPEGROUP].[NAME] INSPECTIONTYPEGROUP,
		[dbo].[DEPARTMENT].[NAME] DEPARTMENTNAME,
		CASE @IS_ASCENDING WHEN 1 THEN
			ROW_NUMBER() OVER(ORDER BY [dbo].[IMINSPECTIONTYPE].[NAME])
		ELSE
			ROW_NUMBER() OVER(ORDER BY [dbo].[IMINSPECTIONTYPE].[NAME] DESC)
		END AS RowNumber,
		COUNT(1) OVER() AS TotalRows
	FROM [dbo].[IMINSPECTIONTYPE]
	LEFT JOIN [dbo].[IMINSPECTIONTYPEGROUP] ON [dbo].[IMINSPECTIONTYPEGROUP].[IMINSPECTIONTYPEGROUPID] = [dbo].[IMINSPECTIONTYPE].[IMINSPECTIONTYPEGROUPID]
	LEFT JOIN [dbo].[DEPARTMENT] ON [dbo].[DEPARTMENT].[DEPARTMENTID] = [dbo].[IMINSPECTIONTYPE].[DEPARTMENTID]
	WHERE ([dbo].[IMINSPECTIONTYPE].[NAME] LIKE '%'+ @SEARCH +'%')
)

SELECT * 
FROM RAW_DATA
WHERE
	RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
	RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY 
	RowNumber