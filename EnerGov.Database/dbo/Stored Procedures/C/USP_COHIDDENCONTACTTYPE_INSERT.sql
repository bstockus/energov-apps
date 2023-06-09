﻿CREATE PROCEDURE [dbo].[USP_COHIDDENCONTACTTYPE_INSERT]
(
	@COHIDDENCONTACTTYPEID CHAR(36),
	@SYSTEMMODULEID INT,
	@SROLEGUID CHAR(36),
	@CONTACTTYPEID CHAR(36)
)
AS

INSERT INTO [dbo].[COHIDDENCONTACTTYPE](
	[COHIDDENCONTACTTYPEID],
	[SYSTEMMODULEID],
	[SROLEGUID],
	[CONTACTTYPEID]
)

VALUES
(
	@COHIDDENCONTACTTYPEID,
	@SYSTEMMODULEID,
	@SROLEGUID,
	@CONTACTTYPEID
)