﻿CREATE PROCEDURE [codemanagementsetup].[USP_VIOLATIONPRIORITYSYSTEMTYPE_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[VIOLATIONPRIORITYSYSTEMTYPE].[VIOLATIONPRIORITYSYSTEMTYPEID],
	[dbo].[VIOLATIONPRIORITYSYSTEMTYPE].[NAME]
FROM [dbo].[VIOLATIONPRIORITYSYSTEMTYPE] 
ORDER BY [dbo].[VIOLATIONPRIORITYSYSTEMTYPE].[VIOLATIONPRIORITYSYSTEMTYPEID] ASC
END