﻿CREATE PROCEDURE [dbo].[USP_PMPERMITTYPE_SELECT_LOOKUP]
(
	@ACTIVEONLY BIT = 1
)
AS
SET NOCOUNT ON;
SELECT 
	[dbo].[PMPERMITTYPE].[PMPERMITTYPEID],
	[dbo].[PMPERMITTYPE].[NAME]
FROM [dbo].[PMPERMITTYPE]
WHERE [dbo].[PMPERMITTYPE].[ACTIVE] = @ACTIVEONLY OR @ACTIVEONLY = 0
ORDER BY [dbo].[PMPERMITTYPE].[NAME]