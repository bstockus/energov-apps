﻿CREATE PROCEDURE [businessmanagementsetup].[USP_ILLICENSECLASSTYPECATEGORY_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[ILLICENSECLASSTYPECATEGORY].[ILLICENSECLASSTYPECATEGORYID],
	[dbo].[ILLICENSECLASSTYPECATEGORY].[NAME]	
FROM [dbo].[ILLICENSECLASSTYPECATEGORY]
		ORDER BY [dbo].[ILLICENSECLASSTYPECATEGORY].[NAME]
END