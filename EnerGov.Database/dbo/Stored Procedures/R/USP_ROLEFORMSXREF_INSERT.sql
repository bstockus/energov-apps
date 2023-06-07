﻿CREATE PROCEDURE [dbo].[USP_ROLEFORMSXREF_INSERT]
(
	@FKROLEID CHAR(36),
	@FKFORMSID CHAR(36),
	@BVISIBLE BIT,
	@BALLOWADD BIT,
	@BALLOWUPDATE BIT,
	@BALLOWDELETE BIT
)
AS

INSERT INTO [dbo].[ROLEFORMSXREF](
	[FKROLEID],
	[FKFORMSID],
	[BVISIBLE],
	[BALLOWADD],
	[BALLOWUPDATE],
	[BALLOWDELETE]
)

VALUES
(
	@FKROLEID,
	@FKFORMSID,
	@BVISIBLE,
	@BALLOWADD,
	@BALLOWUPDATE,
	@BALLOWDELETE
)