﻿CREATE PROCEDURE [dbo].[USP_ILLICENSEALLOWEDACTIVITY_INSERT]
(
	@ILLICENSEALLOWEDACTIVITYID CHAR(36),
	@ILLICENSETYPEID CHAR(36),
	@ILLICENSEACTIVITYTYPEID CHAR(36)
)
AS

INSERT INTO [dbo].[ILLICENSEALLOWEDACTIVITY](
	[ILLICENSEALLOWEDACTIVITYID],
	[ILLICENSETYPEID],
	[ILLICENSEACTIVITYTYPEID]
)

VALUES
(
	@ILLICENSEALLOWEDACTIVITYID,
	@ILLICENSETYPEID,
	@ILLICENSEACTIVITYTYPEID
)