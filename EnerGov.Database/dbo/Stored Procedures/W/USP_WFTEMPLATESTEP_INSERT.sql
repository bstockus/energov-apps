﻿CREATE PROCEDURE [dbo].[USP_WFTEMPLATESTEP_INSERT]
(
	@WFTEMPLATESTEPID CHAR(36),
	@WFTEMPLATEID CHAR(36),
	@WFSTEPID CHAR(36),
	@PRIORITYORDER INT,
	@SORTORDER INT,
	@AUTOFILL BIT,
	@NOPRIORITY BIT
)
AS

INSERT INTO [dbo].[WFTEMPLATESTEP](
	[WFTEMPLATESTEPID],
	[WFTEMPLATEID],
	[WFSTEPID],
	[PRIORITYORDER],
	[SORTORDER],
	[AUTOFILL],
	[NOPRIORITY]
)

VALUES
(
	@WFTEMPLATESTEPID,
	@WFTEMPLATEID,
	@WFSTEPID,
	@PRIORITYORDER,
	@SORTORDER,
	@AUTOFILL,
	@NOPRIORITY
)