﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_PMWCCERTCLASS_GETBYPARENTID]
(
	@PMPERMITTYPEID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[PMPERMITTYPELICENSETYPE].[PMPERMITTYPELICENSETYPEID],
	[dbo].[PMPERMITTYPELICENSETYPE].[PMPERMITTYPEID],
	[dbo].[PMPERMITTYPELICENSETYPE].[PMPERMITWORKCLASSID],
	[dbo].[PMPERMITTYPELICENSETYPE].[COSIMPLELICCERTTYPEID],
	[dbo].[PMPERMITTYPELICENSETYPE].[REQUIREALLCERTCLASS],
	[dbo].[PMWCCERTCLASS].[ILLICENSECLASSIFICATIONID],
	[dbo].[ILLICENSECLASSIFICATION].[NAME]	
FROM [dbo].[PMWCCERTCLASS]
INNER JOIN [dbo].[PMPERMITTYPELICENSETYPE] 
	ON [dbo].[PMPERMITTYPELICENSETYPE].[PMPERMITTYPELICENSETYPEID] = [dbo].[PMWCCERTCLASS].[PMPERMITTYPELICENSETYPEID]
INNER JOIN [dbo].[ILLICENSECLASSIFICATION] 
	ON [dbo].[ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [dbo].[PMWCCERTCLASS].[ILLICENSECLASSIFICATIONID]	
WHERE
	[dbo].[PMPERMITTYPELICENSETYPE].[PMPERMITTYPEID] = @PMPERMITTYPEID
ORDER BY [dbo].[ILLICENSECLASSIFICATION].[NAME]
END