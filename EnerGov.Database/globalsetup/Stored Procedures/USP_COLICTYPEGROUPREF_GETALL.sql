﻿CREATE PROCEDURE [globalsetup].[USP_COLICTYPEGROUPREF_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[COLICTYPEGROUPREF].[COLICTYPEID],
	[dbo].[COLICTYPEGROUPREF].[GROUPID],
	[dbo].[ILLICENSEGROUP].[NAME]
FROM 
	[dbo].[COLICTYPEGROUPREF]
INNER JOIN 
[dbo].[ILLICENSEGROUP] ON [dbo].[ILLICENSEGROUP].[ILLICENSEGROUPID] = [dbo].[COLICTYPEGROUPREF].[GROUPID]
ORDER BY 
	[dbo].[ILLICENSEGROUP].[NAME]
END