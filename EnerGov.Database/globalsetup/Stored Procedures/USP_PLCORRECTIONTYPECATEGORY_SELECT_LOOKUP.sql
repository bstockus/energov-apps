﻿CREATE PROCEDURE [globalsetup].[USP_PLCORRECTIONTYPECATEGORY_SELECT_LOOKUP]
AS
SET NOCOUNT ON;
SELECT 
	[dbo].[PLCORRECTIONTYPECATEGORY].[PLCORRECTIONTYPECATEGORYID],
	[dbo].[PLCORRECTIONTYPECATEGORY].[NAME]
FROM [dbo].[PLCORRECTIONTYPECATEGORY]
ORDER BY [dbo].[PLCORRECTIONTYPECATEGORY].[NAME]