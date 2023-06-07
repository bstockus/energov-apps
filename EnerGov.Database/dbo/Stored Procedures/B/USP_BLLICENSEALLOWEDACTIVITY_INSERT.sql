﻿CREATE PROCEDURE [dbo].[USP_BLLICENSEALLOWEDACTIVITY_INSERT]
(
	@BLLICENSEALLOWEDACTIVITYID CHAR(36),
	@BLLICENSETYPEID CHAR(36),
	@BLLICENSEACTIVITYTYPEID CHAR(36)
)
AS

INSERT INTO [dbo].[BLLICENSEALLOWEDACTIVITY](
	[BLLICENSEALLOWEDACTIVITYID],
	[BLLICENSETYPEID],
	[BLLICENSEACTIVITYTYPEID]
)

VALUES
(
	@BLLICENSEALLOWEDACTIVITYID,
	@BLLICENSETYPEID,
	@BLLICENSEACTIVITYTYPEID
)