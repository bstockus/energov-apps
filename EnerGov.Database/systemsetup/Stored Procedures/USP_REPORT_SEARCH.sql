﻿CREATE PROCEDURE [systemsetup].[USP_REPORT_SEARCH]
(
	@SEARCH AS NVARCHAR(MAX) = '',
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10,
	@IS_ASCENDING AS BIT = 1
)
AS
WITH RAW_DATA AS (
	SELECT
		[dbo].[RPTREPORT].[RPTREPORTID],
		[dbo].[RPTREPORT].[REPORTNAME],
		[dbo].[RPTREPORT].[FRIENDLYNAME],
		CASE @IS_ASCENDING WHEN 1 THEN
			ROW_NUMBER() OVER(ORDER BY [dbo].[RPTREPORT].[REPORTNAME])
		ELSE
			ROW_NUMBER() OVER(ORDER BY [dbo].[RPTREPORT].[REPORTNAME] DESC)
		END AS RowNumber,
		COUNT(1) OVER() AS TotalRows,
		[dbo].[RPTREPORT].[RPTREPORTTYPEID]
	FROM 
		[dbo].[RPTREPORT]
	INNER JOIN 
		[dbo].[RPTREPORTATTRIBUTE] ON [dbo].[RPTREPORTATTRIBUTE].[RPTREPORTID] = [dbo].[RPTREPORT].[RPTREPORTID]
	WHERE 
		[dbo].[RPTREPORT].[REPORTNAME] LIKE '%'+ @SEARCH +'%' OR [dbo].[RPTREPORT].[FRIENDLYNAME] LIKE '%'+ @SEARCH +'%'
	GROUP BY 
		[dbo].[RPTREPORT].[RPTREPORTID],[dbo].[RPTREPORT].[REPORTNAME],[dbo].[RPTREPORT].[FRIENDLYNAME],[dbo].[RPTREPORT].[RPTREPORTTYPEID]
	HAVING 
		COUNT([dbo].[RPTREPORTATTRIBUTE].[RPTREPORTID]) = 2
)

SELECT * 
FROM RAW_DATA
WHERE
	RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
	RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY 
	RowNumber