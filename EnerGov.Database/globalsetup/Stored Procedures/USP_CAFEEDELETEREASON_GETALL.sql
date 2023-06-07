﻿CREATE PROCEDURE [globalsetup].[USP_CAFEEDELETEREASON_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[CAFEEDELETEREASON].[CAFEEDELETEREASONID],
	[dbo].[CAFEEDELETEREASON].[REASONNAME],
	[dbo].[CAFEEDELETEREASON].[LASTCHANGEDBY],
	[dbo].[CAFEEDELETEREASON].[LASTCHANGEDON],
	[dbo].[CAFEEDELETEREASON].[ROWVERSION]
FROM [dbo].[CAFEEDELETEREASON]
	ORDER BY [dbo].[CAFEEDELETEREASON].[REASONNAME]
END