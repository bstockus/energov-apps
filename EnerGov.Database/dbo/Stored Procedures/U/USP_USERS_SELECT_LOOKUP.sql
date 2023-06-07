﻿CREATE PROCEDURE [dbo].[USP_USERS_SELECT_LOOKUP]
(
	@ACTIVEUSERONLY BIT = 1
)
AS
SET NOCOUNT ON;
SELECT 
	[dbo].[USERS].[SUSERGUID],
	[dbo].[USERS].[LNAME],
	[dbo].[USERS].[FNAME],
	[dbo].[USERS].[EMAIL],
	[dbo].[USERS].[LNAME] + COALESCE(', ' + [dbo].[USERS].[FNAME], '') AS [FULLNAME],  
	[dbo].[USERS].[BACTIVE] AS [ISACTIVE] 
FROM [dbo].[USERS]
INNER JOIN [dbo].[APPLICATIONALLOWED] ON [dbo].[APPLICATIONALLOWED].[USERID] = [dbo].[USERS].[SUSERGUID] 
	  AND [dbo].[APPLICATIONALLOWED].[APPROVED] = 1 
	  AND ([dbo].[USERS].[BACTIVE] = 1 OR [dbo].[USERS].BACTIVE = @ACTIVEUSERONLY)
INNER JOIN [dbo].[APPLICATION] ON [dbo].[APPLICATION].[APPLICATIONID] = [dbo].[APPLICATIONALLOWED].[APPLICATIONID] 
	  AND [dbo].[APPLICATION].[APPLICATIONID] = 1 --[APPLICATION].[APPLICATIONID] | 1 => 'Internal' | 2 => 'External' 
ORDER BY [FULLNAME] ASC