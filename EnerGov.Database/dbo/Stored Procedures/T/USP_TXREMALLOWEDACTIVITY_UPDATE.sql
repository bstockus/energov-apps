﻿CREATE PROCEDURE [dbo].[USP_TXREMALLOWEDACTIVITY_UPDATE]
(
	@TXREMALLOWEDACTIVITYID CHAR(36),
	@TXREMITTANCETYPEID CHAR(36),
	@BLLICENSEACTIVITYTYPEID CHAR(36)
)
AS

UPDATE [dbo].[TXREMALLOWEDACTIVITY] SET
	[TXREMITTANCETYPEID] = @TXREMITTANCETYPEID,
	[BLLICENSEACTIVITYTYPEID] = @BLLICENSEACTIVITYTYPEID

WHERE
	[TXREMALLOWEDACTIVITYID] = @TXREMALLOWEDACTIVITYID