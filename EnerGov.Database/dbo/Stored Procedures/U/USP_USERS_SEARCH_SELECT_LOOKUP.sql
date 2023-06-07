﻿CREATE PROCEDURE [dbo].[USP_USERS_SEARCH_SELECT_LOOKUP]
(
	@SEARCH AS NVARCHAR(MAX) = '',
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10,
	@IS_ASCENDING AS BIT = 1,
	@ACTIVEUSERONLY BIT = 1,
	@DEPARTMENTID AS CHAR(36) = NULL
)
AS
BEGIN
WITH RAW_DATA AS(
	SELECT
		[dbo].[USERS].[SUSERGUID],
		[dbo].[USERS].[LNAME],
		[dbo].[USERS].[FNAME],
		[dbo].[USERS].[ID],
		[dbo].[USERS].[EMAIL],
		[dbo].[USERS].[LNAME] + COALESCE(', ' + [dbo].[USERS].[FNAME], '') AS [FULLNAME],
		[dbo].[USERS].[BACTIVE] AS [ISACTIVE],
		CASE @IS_ASCENDING WHEN 1 THEN
			ROW_NUMBER() OVER(ORDER BY [dbo].[USERS].[LNAME],[dbo].[USERS].[FNAME])
		ELSE
			ROW_NUMBER() OVER(ORDER BY [dbo].[USERS].[LNAME],[dbo].[USERS].[FNAME] DESC)
		END AS RowNumber,
		COUNT(1) OVER() AS TotalRows
	FROM [dbo].[USERS]
	INNER JOIN [dbo].[APPLICATIONALLOWED] ON [dbo].[APPLICATIONALLOWED].[USERID] = [dbo].[USERS].[SUSERGUID] 
		  AND [dbo].[APPLICATIONALLOWED].[APPROVED] = 1 
	      AND ([dbo].[USERS].[BACTIVE] = 1 OR [USERS].[BACTIVE] = @ACTIVEUSERONLY)
	      AND [dbo].[APPLICATIONALLOWED].[APPLICATIONID] = 1 --[APPLICATION].[APPLICATIONID] | 1 => 'Internal' | 2 => 'External'
	WHERE (([dbo].[USERS].[LNAME] LIKE '%'+ @SEARCH +'%') OR ([dbo].[USERS].[FNAME] LIKE '%'+ @SEARCH +'%') OR ([dbo].[USERS].[ID] LIKE '%'+ @SEARCH +'%') 
	OR COALESCE([dbo].[USERS].[FNAME], '') + ' ' + [dbo].[USERS].[LNAME] LIKE '%'+ @SEARCH +'%')
	AND (@DEPARTMENTID IS NULL OR @DEPARTMENTID = '' OR (EXISTS(SELECT * FROM [dbo].[USERDEPARTMENT] where [dbo].[USERDEPARTMENT].[SUSERGUID] = [dbo].[USERS].[SUSERGUID] AND DEPARTMENTID = @DEPARTMENTID )))
)

SELECT * 
FROM RAW_DATA
WHERE
	RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
	RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY 
	RowNumber
END