﻿CREATE PROCEDURE [businessmanagementsetup].[USP_BLEXTBUSINESSCATEGORY_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[BLEXTBUSINESSCATEGORY].[BLEXTBUSINESSCATEGORYID],
	[dbo].[BLEXTBUSINESSCATEGORY].[NAME],
	[dbo].[BLEXTBUSINESSCATEGORY].[DESCRIPTION],
	[dbo].[BLEXTBUSINESSCATEGORY].[LASTCHANGEDBY],
	[dbo].[BLEXTBUSINESSCATEGORY].[LASTCHANGEDON],
	[dbo].[BLEXTBUSINESSCATEGORY].[ROWVERSION]
FROM [dbo].[BLEXTBUSINESSCATEGORY]
ORDER BY [dbo].[BLEXTBUSINESSCATEGORY].[NAME] ASC

END