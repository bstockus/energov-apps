﻿CREATE PROCEDURE [dbo].[USP_CMCODEALLOWEDACTIVITY_INSERT]
(
	@CMCODEALLOWEDACTIVITYID CHAR(36),
	@CMCASETYPEID CHAR(36),
	@CMCODEACTIVITYTYPEID CHAR(36)
)
AS

INSERT INTO [dbo].[CMCODEALLOWEDACTIVITY](
	[CMCODEALLOWEDACTIVITYID],
	[CMCASETYPEID],
	[CMCODEACTIVITYTYPEID]
)

VALUES
(
	@CMCODEALLOWEDACTIVITYID,
	@CMCASETYPEID,
	@CMCODEACTIVITYTYPEID
)