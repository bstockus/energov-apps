﻿CREATE PROCEDURE [dbo].[USP_BLTYPECLASSILTYPE_INSERT]
(
	@BLTYPECLASSILTYPEID CHAR(36),
	@BLLICENSETYPECLASSID CHAR(36),
	@ILLICENSETYPEID CHAR(36)
)
AS
BEGIN
INSERT INTO [dbo].[BLTYPECLASSILTYPE](
	[BLTYPECLASSILTYPEID],
	[BLLICENSETYPECLASSID],
	[ILLICENSETYPEID]
)
VALUES
(
	@BLTYPECLASSILTYPEID,
	@BLLICENSETYPECLASSID,
	@ILLICENSETYPEID
)
END