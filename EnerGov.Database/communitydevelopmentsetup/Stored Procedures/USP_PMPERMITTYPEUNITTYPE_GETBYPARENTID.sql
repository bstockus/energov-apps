﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_PMPERMITTYPEUNITTYPE_GETBYPARENTID]
(
	@PMPERMITTYPEID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[PMPERMITTYPEUNITTYPE].[PMPERMITTYPEIPUNITTYPEID],
	[dbo].[PMPERMITTYPEUNITTYPE].[PMPERMITTYPEID],
	[dbo].[PMPERMITTYPEUNITTYPE].[PMPERMITWORKCLASSID],
	[dbo].[PMPERMITTYPEUNITTYPE].[IPUNITTYPEID],
	[dbo].[PMPERMITTYPEUNITTYPE].[ISREQUIRED],
	[dbo].[PMPERMITTYPEUNITTYPE].[UNITTYPEGROUP],
	[dbo].[IPUNITTYPE].[NAME]
FROM [dbo].[PMPERMITTYPEUNITTYPE]
INNER JOIN [dbo].[IPUNITTYPE] 
	ON [dbo].[IPUNITTYPE].[IPUNITTYPEID] = [dbo].[PMPERMITTYPEUNITTYPE].[IPUNITTYPEID]
WHERE
	[dbo].[PMPERMITTYPEUNITTYPE].[PMPERMITTYPEID] = @PMPERMITTYPEID
ORDER BY [dbo].[PMPERMITTYPEUNITTYPE].[PMPERMITWORKCLASSID], [dbo].[IPUNITTYPE].[NAME]
END