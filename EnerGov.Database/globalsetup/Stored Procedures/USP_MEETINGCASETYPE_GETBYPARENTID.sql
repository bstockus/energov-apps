﻿CREATE PROCEDURE [globalsetup].[USP_MEETINGCASETYPE_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
	[dbo].[MEETINGCASETYPE].[CASETYPEID],
	[dbo].[MEETINGCASETYPE].[MODULEID],
	[dbo].[MEETINGCASETYPE].[TYPEID],
	[dbo].[MEETINGCASETYPE].[WORKCLASSID],
	[dbo].[MEETINGCASETYPE].[LIMIT],
	[dbo].[MEETINGCASETYPE].[MEETINGTYPEID],
	[dbo].[MEETINGCASETYPE].[MODULENAME],
	[dbo].[MEETINGCASETYPE].[TYPENAME],
	[dbo].[MEETINGCASETYPE].[WORKCLASSNAME]
	FROM [dbo].[MEETINGCASETYPE]
	WHERE [dbo].[MEETINGCASETYPE].[MEETINGTYPEID] = @PARENTID
	ORDER BY [dbo].[MEETINGCASETYPE].[TYPENAME]
END