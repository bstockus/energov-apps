﻿CREATE PROCEDURE [globalsetup].[USP_HOLDMODULELIST_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[MODULEID],
	[MODULENAME]
FROM [dbo].[HOLDMODULELIST]
ORDER BY [dbo].[HOLDMODULELIST].[MODULENAME]
END