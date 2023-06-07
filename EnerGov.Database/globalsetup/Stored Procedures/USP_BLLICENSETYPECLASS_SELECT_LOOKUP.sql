﻿CREATE PROCEDURE [globalsetup].[USP_BLLICENSETYPECLASS_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT DISTINCT 
		[dbo].[BLLICENSETYPE].[BLLICENSETYPEID],
		[dbo].[BLLICENSETYPE].[NAME] 
FROM [BLLICENSETYPE] INNER JOIN [dbo].[BLLICENSETYPECLASS] ON
[BLLICENSETYPE].[BLLICENSETYPEID] =[BLLICENSETYPECLASS].[BLLICENSETYPEID]
ORDER BY [dbo].[BLLICENSETYPE].[NAME]

EXEC [globalsetup].[USP_BLLICENSECLASS_SELECT_LOOKUP] 

END