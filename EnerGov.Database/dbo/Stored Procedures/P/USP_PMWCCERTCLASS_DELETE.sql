﻿CREATE PROCEDURE [dbo].[USP_PMWCCERTCLASS_DELETE]
(
@PMPERMITTYPELICENSETYPEID CHAR(36),
@ILLICENSECLASSIFICATIONID CHAR(36)
)
AS
DELETE FROM [dbo].[PMWCCERTCLASS]
WHERE
	[PMPERMITTYPELICENSETYPEID] = @PMPERMITTYPELICENSETYPEID AND 
	[ILLICENSECLASSIFICATIONID] = @ILLICENSECLASSIFICATIONID