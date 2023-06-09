﻿CREATE PROCEDURE [dbo].[USP_WFTEMPLATESTEPACTION_UPDATE]
(
	@WFTEMPLATESTEPACTIONID CHAR(36),
	@WFTEMPLATESTEPID CHAR(36),
	@WFACTIONID CHAR(36),
	@PRIORITYORDER INT,
	@SORTORDER INT,
	@AUTORECEIVE BIT,
	@AUTOFILL BIT,
	@NOPRIORITY BIT,
	@ISCAPOPTIONALINSPECTION BIT,
	@INSPECTIONSET INT
)
AS

UPDATE [dbo].[WFTEMPLATESTEPACTION] SET
	[WFTEMPLATESTEPID] = @WFTEMPLATESTEPID,
	[WFACTIONID] = @WFACTIONID,
	[PRIORITYORDER] = @PRIORITYORDER,
	[SORTORDER] = @SORTORDER,
	[AUTORECEIVE] = @AUTORECEIVE,
	[AUTOFILL] = @AUTOFILL,
	[NOPRIORITY] = @NOPRIORITY,
	[ISCAPOPTIONALINSPECTION] = @ISCAPOPTIONALINSPECTION,
	[INSPECTIONSET] = @INSPECTIONSET

WHERE
	[WFTEMPLATESTEPACTIONID] = @WFTEMPLATESTEPACTIONID