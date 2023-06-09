﻿CREATE PROCEDURE [globalsetup].[USP_MEETINGTYPEDATTENDEE_GETBYPARENTID]
(
@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[MEETINGTYPEDATTENDEE].[MEETINGTYPEDATTENDEEID],
	[dbo].[MEETINGTYPEDATTENDEE].[MEETINGTYPEID],
	[dbo].[MEETINGTYPEDATTENDEE].[ATTENDEEID],
	[dbo].[MEETINGTYPEDATTENDEE].[ISUSER],
	[dbo].[MEETINGTYPEDATTENDEE].[ISCONTACT],
	[COMPANYNAME] = ISNULL([dbo].[GLOBALENTITY].[GLOBALENTITYNAME], ''),
	[FIRSTNAME] = ISNULL([dbo].[GLOBALENTITY].[FIRSTNAME], [dbo].[USERS].[FNAME]),
	[LASTNAME] = ISNULL([dbo].[GLOBALENTITY].[LASTNAME], [dbo].[USERS].[LNAME])	
FROM [dbo].[MEETINGTYPEDATTENDEE]
LEFT JOIN [dbo].[GLOBALENTITY] WITH (NOLOCK) ON [dbo].[GLOBALENTITY].[GLOBALENTITYID] = [dbo].[MEETINGTYPEDATTENDEE].[ATTENDEEID]
LEFT JOIN [dbo].[USERS] WITH (NOLOCK) ON [dbo].[USERS].[SUSERGUID] = [dbo].[MEETINGTYPEDATTENDEE].[ATTENDEEID]
WHERE [dbo].[MEETINGTYPEDATTENDEE].[MEETINGTYPEID] = @PARENTID
ORDER BY ISNULL([dbo].[GLOBALENTITY].[FIRSTNAME], [dbo].[USERS].[FNAME])

END