﻿CREATE PROCEDURE [dbo].[USP_WINDOWSSERVICETASKCONFIG_UPDATE]
(
	@WINDOWSSERVICETASKCONFIGID CHAR(36),
	@CONCURRENCYLIMIT INT,
	@ISENABLED BIT
)
AS

UPDATE [dbo].[WINDOWSSERVICETASKCONFIG] SET
	[CONCURRENCYLIMIT] = @CONCURRENCYLIMIT,
	[ISENABLED] = @ISENABLED

WHERE
	[WINDOWSSERVICETASKCONFIGID] = @WINDOWSSERVICETASKCONFIGID