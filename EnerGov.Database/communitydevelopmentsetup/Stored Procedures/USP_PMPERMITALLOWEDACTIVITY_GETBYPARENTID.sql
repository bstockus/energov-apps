﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_PMPERMITALLOWEDACTIVITY_GETBYPARENTID]
(
	@PMPERMITTYPEID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[PMPERMITALLOWEDACTIVITY].[PMPERMITALLOWEDACTIVITYID],
	[dbo].[PMPERMITALLOWEDACTIVITY].[PMPERMITTYPEID],
	[dbo].[PMPERMITALLOWEDACTIVITY].[PMPERMITACTIVITYTYPEID],
	[dbo].[PMPERMITACTIVITYTYPE].[NAME]
FROM [dbo].[PMPERMITALLOWEDACTIVITY]
INNER JOIN [dbo].[PMPERMITACTIVITYTYPE] 
	ON [dbo].[PMPERMITACTIVITYTYPE].[PMPERMITACTIVITYTYPEID] = [dbo].[PMPERMITALLOWEDACTIVITY].[PMPERMITACTIVITYTYPEID]
WHERE
	[dbo].[PMPERMITALLOWEDACTIVITY].[PMPERMITTYPEID] = @PMPERMITTYPEID
ORDER BY [dbo].[PMPERMITACTIVITYTYPE].[NAME]
END