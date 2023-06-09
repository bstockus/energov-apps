﻿CREATE PROCEDURE [dbo].[USP_EXAMTYPEVERSION_UPDATE]
(
	@EXAMTYPEVERSIONID CHAR(36),
	@EXAMTYPEID CHAR(36),
	@EXAMVERSIONID CHAR(36),
	@ISDEFAULT BIT,
	@ACTIVE BIT
)
AS

UPDATE [dbo].[EXAMTYPEVERSION] SET
	[EXAMTYPEID] = @EXAMTYPEID,
	[EXAMVERSIONID] = @EXAMVERSIONID,
	[ISDEFAULT] = @ISDEFAULT,
	[ACTIVE] = @ACTIVE

WHERE
	[EXAMTYPEVERSIONID] = @EXAMTYPEVERSIONID