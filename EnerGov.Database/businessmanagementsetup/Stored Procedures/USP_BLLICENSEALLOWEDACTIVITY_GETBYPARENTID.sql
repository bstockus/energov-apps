﻿CREATE PROCEDURE [businessmanagementsetup].[USP_BLLICENSEALLOWEDACTIVITY_GETBYPARENTID]
(
	@BLLICENSETYPEID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[BLLICENSEALLOWEDACTIVITY].[BLLICENSEALLOWEDACTIVITYID],
	[dbo].[BLLICENSEALLOWEDACTIVITY].[BLLICENSETYPEID],
	[dbo].[BLLICENSEALLOWEDACTIVITY].[BLLICENSEACTIVITYTYPEID],
	[dbo].[BLLICENSEACTIVITYTYPE].[NAME]
FROM [dbo].[BLLICENSEALLOWEDACTIVITY]
INNER JOIN [dbo].[BLLICENSEACTIVITYTYPE] 
	ON [dbo].[BLLICENSEACTIVITYTYPE].[BLLICENSEACTIVITYTYPEID] = [dbo].[BLLICENSEALLOWEDACTIVITY].[BLLICENSEACTIVITYTYPEID]
WHERE
	[dbo].[BLLICENSEALLOWEDACTIVITY].[BLLICENSETYPEID] = @BLLICENSETYPEID
ORDER BY [dbo].[BLLICENSEACTIVITYTYPE] .[NAME]
END