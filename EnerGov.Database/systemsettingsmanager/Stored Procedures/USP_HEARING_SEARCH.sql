﻿CREATE PROCEDURE [systemsettingsmanager].[USP_HEARING_SEARCH]
(
	@SEARCH			  AS NVARCHAR(255)	    =	'',
	@PAGE_NUMBER	  AS INT				=	1,
	@PAGE_SIZE		  AS INT				=	10,
	@IS_ASCENDING	  AS BIT				=	1
)
AS

WITH RAW_DATA AS (
	SELECT
			[dbo].[HEARING].[HEARINGID],
			[dbo].[HEARING].[HEARINGTYPEID],
			[dbo].[HEARINGTYPE].[NAME] AS [HEARINGTYPENAME],
			[dbo].[HEARING].[HEARINGSTATUSID],
			[dbo].[HEARINGSTATUS].[NAME] AS [HEARINGSTATUSNAME],
			[dbo].[HEARING].[SUBJECT],
			[dbo].[HEARING].[LOCATION],
			[dbo].[HEARING].[COMMENTS],
			[dbo].[HEARING].[STARTDATE],
			[dbo].[HEARING].[ENDDATE],
			CASE @IS_ASCENDING WHEN 1 THEN
				ROW_NUMBER() OVER(ORDER BY [dbo].[HEARING].[SUBJECT])
			ELSE
				ROW_NUMBER() OVER(ORDER BY [dbo].[HEARING].[SUBJECT] DESC)
			END AS RowNumber,
			COUNT(1) OVER() AS TotalRows
	FROM	[dbo].[HEARING]
			INNER JOIN HEARINGTYPE ON [dbo].[HEARING].[HEARINGTYPEID] = [dbo].[HEARINGTYPE].[HEARINGTYPEID]
			INNER JOIN HEARINGSTATUS ON [dbo].[HEARING].[HEARINGSTATUSID] = [dbo].[HEARINGSTATUS].[HEARINGSTATUSID]
	WHERE ([dbo].[HEARING].[SUBJECT] LIKE '%'+ @SEARCH +'%')
)

SELECT		* 
FROM		RAW_DATA
WHERE		RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) 
			AND RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY	RowNumber