﻿CREATE PROCEDURE [dbo].[USP_CMCODEALLOWEDACTIVITY_UPDATE]
(
	@CMCODEALLOWEDACTIVITYID CHAR(36),
	@CMCASETYPEID CHAR(36),
	@CMCODEACTIVITYTYPEID CHAR(36)
)
AS

UPDATE [dbo].[CMCODEALLOWEDACTIVITY] SET
	[CMCASETYPEID] = @CMCASETYPEID,
	[CMCODEACTIVITYTYPEID] = @CMCODEACTIVITYTYPEID

WHERE
	[CMCODEALLOWEDACTIVITYID] = @CMCODEALLOWEDACTIVITYID