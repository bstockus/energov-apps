﻿CREATE PROCEDURE [globalsearch].[USP_CORRECTIONTYPECATEGORY_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[PLCORRECTIONTYPECATEGORY].[PLCORRECTIONTYPECATEGORYID],
	[PLCORRECTIONTYPECATEGORY].[NAME]
FROM [dbo].[PLCORRECTIONTYPECATEGORY] WITH (NOLOCK)
	ORDER BY [PLCORRECTIONTYPECATEGORY].[NAME]
END