﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_PLPLANALLOWEDACTIVITY_GETBYPARENTID]
(
	@PLPLANTYPEID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[PLPLANALLOWEDACTIVITY].[PLPLANALLOWEDACTIVITYID],
	[dbo].[PLPLANALLOWEDACTIVITY].[PLPLANTYPEID],
	[dbo].[PLPLANALLOWEDACTIVITY].[PLPLANACTIVITYTYPEID],
	[dbo].[PLPLANACTIVITYTYPE].[NAME]
FROM [dbo].[PLPLANALLOWEDACTIVITY]
INNER JOIN [dbo].[PLPLANACTIVITYTYPE] 
	ON [dbo].[PLPLANACTIVITYTYPE].[PLPLANACTIVITYTYPEID] = [dbo].[PLPLANALLOWEDACTIVITY].[PLPLANACTIVITYTYPEID]
WHERE
	[dbo].[PLPLANALLOWEDACTIVITY].[PLPLANTYPEID] = @PLPLANTYPEID
ORDER BY [dbo].[PLPLANACTIVITYTYPE].[NAME]
END