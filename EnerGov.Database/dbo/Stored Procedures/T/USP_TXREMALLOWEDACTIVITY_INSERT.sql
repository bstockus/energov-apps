﻿CREATE PROCEDURE [dbo].[USP_TXREMALLOWEDACTIVITY_INSERT]
(
	@TXREMALLOWEDACTIVITYID CHAR(36),
	@TXREMITTANCETYPEID CHAR(36),
	@BLLICENSEACTIVITYTYPEID CHAR(36)
)
AS

INSERT INTO [dbo].[TXREMALLOWEDACTIVITY](
	[TXREMALLOWEDACTIVITYID],
	[TXREMITTANCETYPEID],
	[BLLICENSEACTIVITYTYPEID]
)

VALUES
(
	@TXREMALLOWEDACTIVITYID,
	@TXREMITTANCETYPEID,
	@BLLICENSEACTIVITYTYPEID
)