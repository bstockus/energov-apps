﻿CREATE PROCEDURE [dbo].[USP_MEETINGCASETYPE_UPDATE]
(
	@CASETYPEID CHAR(36),
	@MODULEID INT,
	@TYPEID CHAR(36),
	@WORKCLASSID CHAR(36),
	@LIMIT INT,
	@MEETINGTYPEID CHAR(36),
	@MODULENAME NVARCHAR(50),
	@TYPENAME NVARCHAR(50),
	@WORKCLASSNAME NVARCHAR(50)
)
AS

UPDATE [dbo].[MEETINGCASETYPE] SET
	[MODULEID] = @MODULEID,
	[TYPEID] = @TYPEID,
	[WORKCLASSID] = @WORKCLASSID,
	[LIMIT] = @LIMIT,
	[MEETINGTYPEID] = @MEETINGTYPEID,
	[MODULENAME] = @MODULENAME,
	[TYPENAME] = @TYPENAME,
	[WORKCLASSNAME] = @WORKCLASSNAME

WHERE
	[CASETYPEID] = @CASETYPEID