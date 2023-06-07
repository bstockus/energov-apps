﻿CREATE PROCEDURE [dbo].[USP_WFTEMPLATESTEP_UPDATE]
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

UPDATE [dbo].[WFTEMPLATESTEP] SET
	[WFTEMPLATEID] = @WFTEMPLATEID,
	[WFSTEPID] = @WFSTEPID,
	[PRIORITYORDER] = @PRIORITYORDER,
	[SORTORDER] = @SORTORDER,
	[AUTOFILL] = @AUTOFILL,
	[NOPRIORITY] = @NOPRIORITY

WHERE
	[WFTEMPLATESTEPID] = @WFTEMPLATESTEPID