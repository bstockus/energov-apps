﻿CREATE PROCEDURE [dbo].[USP_SCHEDULEPRIORITYSTATUS_DELETE]
(
	@SCHEDULEPRIORITYSTATUSID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[SCHEDULEPRIORITYSTATUS]
WHERE
	[SCHEDULEPRIORITYSTATUSID] = @SCHEDULEPRIORITYSTATUSID AND 
	[ROWVERSION]= @ROWVERSION