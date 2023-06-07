﻿CREATE PROCEDURE [common].[USP_TASKTYPEASSIGNUSER_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[TASKTYPEASSIGNUSER].[TASKTYPEASSIGNUSERID],
	[dbo].[TASKTYPEASSIGNUSER].[TASKTYPEID],
	[dbo].[TASKTYPEASSIGNUSER].[USERID],
	[dbo].[TASKTYPEASSIGNUSER].[AUTOASSIGN],
	[dbo].[TASKTYPEASSIGNUSER].[SHOWONCALENDAR],
	[dbo].[USERS].[FNAME],
	[dbo].[USERS].[LNAME]
FROM [dbo].[TASKTYPEASSIGNUSER] INNER JOIN [dbo].[USERS]
ON [dbo].[TASKTYPEASSIGNUSER].[USERID] = [dbo].[USERS].[SUSERGUID]
ORDER BY [dbo].[USERS].[LNAME], [dbo].[USERS].[FNAME]
END