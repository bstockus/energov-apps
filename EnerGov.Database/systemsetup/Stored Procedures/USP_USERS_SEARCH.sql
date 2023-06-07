CREATE PROCEDURE [systemsetup].[USP_USERS_SEARCH]
(
	@SEARCH			AS NVARCHAR(MAX)	=	'',
	@PAGE_NUMBER	AS INT				=	1,
	@PAGE_SIZE		AS INT				=	10,
	@IS_ASCENDING	AS BIT				=	1
)
AS
SET NOCOUNT ON;
WITH RAW_DATA AS (
	SELECT		[dbo].[USERS].[SUSERGUID],
				[dbo].[USERS].[FNAME],
				[dbo].[USERS].[LNAME],
				[dbo].[USERS].[ID],
				[dbo].[ROLES].[ID] AS ROLENAME,
				[dbo].[USERS].[LNAME] + COALESCE(', ' + [dbo].[USERS].[FNAME], '') AS [FULLNAME],
				[dbo].[USERS].[TITLE],
				[dbo].[OFFICE].[NAME] AS OFFICE,
				[dbo].[USERS].[LICENSE_SUITE],
				CASE @IS_ASCENDING WHEN 1 THEN
					ROW_NUMBER() OVER(ORDER BY [dbo].[USERS].[LNAME] + COALESCE(', ' + ISNULL([dbo].[USERS].[FNAME], ''), ''))
				ELSE
					ROW_NUMBER() OVER(ORDER BY [dbo].[USERS].[LNAME] + COALESCE(', ' + ISNULL([dbo].[USERS].[FNAME], ''), '') DESC)
				END AS RowNumber,
				COUNT(1) OVER() AS TotalRows
	FROM		[dbo].[USERS]
				LEFT JOIN [dbo].[ROLES] ON [dbo].[USERS].[SROLEID] = [dbo].[ROLES].[SROLEGUID]
				INNER JOIN [dbo].[APPLICATIONALLOWED] ON [dbo].[APPLICATIONALLOWED].[USERID] = [dbo].[USERS].[SUSERGUID] 
				AND [dbo].[APPLICATIONALLOWED].[APPROVED] = 1				
				AND [dbo].[APPLICATIONALLOWED].[APPLICATIONID] = 1 --[APPLICATION].[APPLICATIONID] | 1 => 'EnerGov' | 2 => 'CitizenAccess'
				LEFT JOIN [dbo].[OFFICE] ON [dbo].[OFFICE].[OFFICEID] = [dbo].[USERS].[OFFICEID]
				
	WHERE ([dbo].[USERS].[FNAME] LIKE '%'+ @SEARCH +'%') OR ([dbo].[USERS].[LNAME] LIKE '%'+ @SEARCH +'%') OR ([dbo].[USERS].[ID] LIKE '%'+ @SEARCH +'%')
				
)

SELECT		* 
FROM		RAW_DATA
WHERE		RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) 
			AND RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY	RowNumber