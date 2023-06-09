﻿CREATE PROCEDURE [dbo].[USP_TASKTYPEASSIGNUSER_INSERT]
(
	@TASKTYPEASSIGNUSERID CHAR(36),
	@TASKTYPEID CHAR(36),
	@USERID CHAR(36),
	@AUTOASSIGN BIT,
	@SHOWONCALENDAR BIT
)
AS

INSERT INTO [dbo].[TASKTYPEASSIGNUSER](
	[TASKTYPEASSIGNUSERID],
	[TASKTYPEID],
	[USERID],
	[AUTOASSIGN],
	[SHOWONCALENDAR]
)

VALUES
(
	@TASKTYPEASSIGNUSERID,
	@TASKTYPEID,
	@USERID,
	@AUTOASSIGN,
	@SHOWONCALENDAR
)