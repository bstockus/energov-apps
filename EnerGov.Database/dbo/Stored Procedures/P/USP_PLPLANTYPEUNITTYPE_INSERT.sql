﻿CREATE PROCEDURE [dbo].[USP_PLPLANTYPEUNITTYPE_INSERT]
(
	@PLPLANTYPEUNITTYPEID CHAR(36),
	@PLPLANTYPEID CHAR(36),
	@PLPLANWORKCLASSID CHAR(36),
	@IPUNITTYPEID CHAR(36),
	@ISREQUIRED BIT,
	@UNITTYPEGROUP INT
)
AS

INSERT INTO [dbo].[PLPLANTYPEUNITTYPE](
	[PLPLANTYPEUNITTYPEID],
	[PLPLANTYPEID],
	[PLPLANWORKCLASSID],
	[IPUNITTYPEID],
	[ISREQUIRED],
	[UNITTYPEGROUP]
)

VALUES
(
	@PLPLANTYPEUNITTYPEID,
	@PLPLANTYPEID,
	@PLPLANWORKCLASSID,
	@IPUNITTYPEID,
	@ISREQUIRED,
	@UNITTYPEGROUP
)