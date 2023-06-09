﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_PMPERMITTYPEBUSLICTYPEBUSWC_GETBYPARENTID]
(
	@PMPERMITTYPEID CHAR(36)
)
AS
BEGIN
SELECT 
	[dbo].[PMPERMITTYPEBUSLICTYPE].[PMPERMITTYPEBUSLICTYPEID],
	[dbo].[PMPERMITTYPEBUSLICTYPE].[PMPERMITTYPEID],
	[dbo].[PMPERMITTYPEBUSLICTYPE].[PMPERMITWORKCLASSID],
	[dbo].[PMPERMITTYPEBUSLICTYPE].[BLLICENSETYPEID],
	[dbo].[PMPERMITTYPEBUSLICTYPE].[PMPERMITTYPEWORKCLASSID],
	[dbo].[BLLICENSECLASS].[BLLICENSECLASSID],
	[dbo].[BLLICENSECLASS].[NAME]
FROM [dbo].[PMPERMITTYPEBUSLICTYPE]
INNER JOIN [dbo].[PMPERMITTYPEBUSLICTYPEBUSWC]
	ON [dbo].[PMPERMITTYPEBUSLICTYPE].[PMPERMITTYPEBUSLICTYPEID] = [dbo].[PMPERMITTYPEBUSLICTYPEBUSWC].[PMPERMITTYPEBUSLICTYPEID]
INNER JOIN [dbo].[BLLICENSECLASS]
	ON [dbo].[BLLICENSECLASS].[BLLICENSECLASSID] = [dbo].[PMPERMITTYPEBUSLICTYPEBUSWC].[BLLICENSECLASSID]	
WHERE
	[dbo].[PMPERMITTYPEBUSLICTYPE].[PMPERMITTYPEID] = @PMPERMITTYPEID
ORDER BY [dbo].[BLLICENSECLASS].[NAME]
END