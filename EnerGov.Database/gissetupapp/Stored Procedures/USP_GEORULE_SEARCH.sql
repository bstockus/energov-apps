﻿CREATE PROCEDURE [gissetupapp].[USP_GEORULE_SEARCH]
(
	@SEARCH			  AS NVARCHAR(255)	    =	'',
	@PAGE_NUMBER	  AS INT				=	1,
	@PAGE_SIZE		  AS INT				=	10,
	@IS_ASCENDING	  AS BIT				=	1,
	@GEORULEENTITYID  AS CHAR(36)		    =   NULL
)
AS

WITH RAW_DATA AS (
	SELECT
			[dbo].[GEORULE].[GEORULEID],
			[dbo].[GEORULE].[RULENAME],
			[dbo].[GEORULE].[DESCRIPTION],
			[dbo].[GEORULEENTITY].[GEORYLEENTITYFRIENDLYNAME],
			[dbo].[GEOQUERY].[QUERYNAME],
			CASE @IS_ASCENDING WHEN 1 THEN
				ROW_NUMBER() OVER(ORDER BY [dbo].[GEORULE].[RULENAME])
			ELSE
				ROW_NUMBER() OVER(ORDER BY [dbo].[GEORULE].[RULENAME] DESC)
			END AS RowNumber,
			COUNT(1) OVER() AS TotalRows
	FROM	[dbo].[GEORULE]
		JOIN [dbo].[GEORULEENTITY] ON [dbo].[GEORULEENTITY].[GEORULEENTITYID] = [dbo].[GEORULE].[GEORULEENTITYID]
		JOIN [dbo].[GEOQUERY] ON [dbo].[GEOQUERY].[GEOQUERYID] = [dbo].[GEORULE].[GEOQUERYID]
 	WHERE	(@GEORULEENTITYID IS NULL OR @GEORULEENTITYID = '' OR [dbo].[GEORULE].[GEORULEENTITYID] = @GEORULEENTITYID) AND
				([dbo].[GEORULE].[RULENAME] LIKE '%'+ @SEARCH +'%')
)

SELECT		* 
FROM		RAW_DATA
WHERE		RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) 
			AND RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY	RowNumber