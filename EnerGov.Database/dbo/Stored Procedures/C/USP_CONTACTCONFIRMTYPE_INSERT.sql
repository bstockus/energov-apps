﻿CREATE PROCEDURE [dbo].[USP_CONTACTCONFIRMTYPE_INSERT]
(
	@CONTACTCONFIRMTYPEID CHAR(36),
	@LANDMANAGEMENTCONTACTTYPEID CHAR(36),
	@MODULETYPE INT,
	@ISREQUIRE BIT,
	@HASEDITRIGHT BIT,
	@CANCREATESUBRECORD BIT,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE AS TABLE([ROWVERSION]  INT)
INSERT INTO [dbo].[CONTACTCONFIRMTYPE](
	[CONTACTCONFIRMTYPEID],
	[LANDMANAGEMENTCONTACTTYPEID],
	[MODULETYPE],
	[ISREQUIRE],
	[HASEDITRIGHT],
	[CANCREATESUBRECORD],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@CONTACTCONFIRMTYPEID,
	@LANDMANAGEMENTCONTACTTYPEID,
	@MODULETYPE,
	@ISREQUIRE,
	@HASEDITRIGHT,
	@CANCREATESUBRECORD,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE