﻿CREATE PROCEDURE [cashieringsetup].[USP_CAPAYMENTTYPE_SELECT_LOOKUP]
AS
SET NOCOUNT ON;
SELECT 
	[dbo].[CAPAYMENTTYPE].[CAPAYMENTTYPEID],
	[dbo].[CAPAYMENTTYPE].[NAME]
FROM [dbo].[CAPAYMENTTYPE]
ORDER BY [dbo].[CAPAYMENTTYPE].[NAME]