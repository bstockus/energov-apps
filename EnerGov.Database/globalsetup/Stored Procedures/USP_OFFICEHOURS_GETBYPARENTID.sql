﻿CREATE PROCEDURE [globalsetup].[USP_OFFICEHOURS_GETBYPARENTID]
(
@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[OFFICEHOURS].[OFFICEHOURSID],
	[dbo].[OFFICEHOURS].[WORKDAYID],
	[dbo].[OFFICEHOURS].[OFFICEID],
	[dbo].[OFFICEHOURS].[STARTTIME],
	[dbo].[OFFICEHOURS].[ENDTIME],
	[dbo].[OFFICEHOURS].[ISWORKINGDAY]
FROM [dbo].[OFFICEHOURS] 
WHERE [dbo].[OFFICEHOURS].[OFFICEID] = @PARENTID
ORDER BY [dbo].[OFFICEHOURS].[WORKDAYID] ASC
END