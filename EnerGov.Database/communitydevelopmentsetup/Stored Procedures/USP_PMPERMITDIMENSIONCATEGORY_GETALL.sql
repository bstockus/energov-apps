﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_PMPERMITDIMENSIONCATEGORY_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[PMPERMITDIMENSIONCATEGORY].[PMPERMITDIMENSIONCATEGORYID],
	[dbo].[PMPERMITDIMENSIONCATEGORY].[CATEGORY],	
	[dbo].[PMPERMITDIMENSIONCATEGORY].[LASTCHANGEDBY],
	[dbo].[PMPERMITDIMENSIONCATEGORY].[LASTCHANGEDON],
	[dbo].[PMPERMITDIMENSIONCATEGORY].[ROWVERSION]
FROM [dbo].[PMPERMITDIMENSIONCATEGORY] ORDER BY [dbo].[PMPERMITDIMENSIONCATEGORY].[CATEGORY] ASC

END