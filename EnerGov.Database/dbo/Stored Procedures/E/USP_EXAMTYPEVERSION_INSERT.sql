﻿CREATE PROCEDURE [dbo].[USP_EXAMTYPEVERSION_INSERT]
(
	@EXAMTYPEVERSIONID CHAR(36),
	@EXAMTYPEID CHAR(36),
	@EXAMVERSIONID CHAR(36),
	@ISDEFAULT BIT,
	@ACTIVE BIT
)
AS

INSERT INTO [dbo].[EXAMTYPEVERSION](
	[EXAMTYPEVERSIONID],
	[EXAMTYPEID],
	[EXAMVERSIONID],
	[ISDEFAULT],
	[ACTIVE]
)

VALUES
(
	@EXAMTYPEVERSIONID,
	@EXAMTYPEID,
	@EXAMVERSIONID,
	@ISDEFAULT,
	@ACTIVE
)