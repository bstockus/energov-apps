﻿CREATE PROCEDURE [gissetupapp].[USP_USERS_IMINSPECTORTYPEUSER_SEARCH]
(
	@SEARCH			AS NVARCHAR(255)	=	'',
	@PAGE_NUMBER	AS INT				=	1,
	@PAGE_SIZE		AS INT				=	10,
	@IS_ASCENDING	AS BIT				=	1,
	@ACTIVE_ONLY	AS BIT				=	1
)
AS

WITH RAW_DATA AS (
	SELECT		[dbo].[USERS].[SUSERGUID],
	
				[dbo].[USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'') AS [FULLNAME],
				CASE @IS_ASCENDING	WHEN 1 THEN ROW_NUMBER() OVER(ORDER BY [dbo].[USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],''))
										   ELSE ROW_NUMBER() OVER(ORDER BY [dbo].[USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'') DESC)
				END AS RowNumber,
				COUNT(1) OVER() AS TotalRows
	FROM		[dbo].[USERS]
				INNER JOIN [dbo].[IMINSPECTORTYPEUSER] ON [dbo].[USERS].[SUSERGUID] = [dbo].[IMINSPECTORTYPEUSER].[USERID]
	WHERE		([dbo].[USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'') LIKE '%'+ @SEARCH +'%' 
				AND ([dbo].[USERS].[BACTIVE] = 1 OR [USERS].[BACTIVE] = @ACTIVE_ONLY))
	GROUP BY	[dbo].[USERS].[SUSERGUID], [dbo].[USERS].[LNAME] + COALESCE(', ' + [USERS].[FNAME],'')
)

SELECT		* 
FROM		RAW_DATA
WHERE		RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) 
			AND RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY	RowNumber