﻿CREATE PROCEDURE [codemanagementsetup].[USP_CMCODECATEGORY_SELECT_LOOKUP]
	AS
	SET NOCOUNT ON;
SELECT 
	[dbo].[CMCODECATEGORY].[CMCODECATEGORYID],
	[dbo].[CMCODECATEGORY].[NAME]
FROM [dbo].[CMCODECATEGORY]
ORDER BY [dbo].[CMCODECATEGORY].[NAME]