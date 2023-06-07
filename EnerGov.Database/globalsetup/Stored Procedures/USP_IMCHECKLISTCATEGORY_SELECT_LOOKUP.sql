﻿CREATE PROCEDURE [globalsetup].[USP_IMCHECKLISTCATEGORY_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[IMCHECKLISTCATEGORY].[IMCHECKLISTCATEGORYID],
	[dbo].[IMCHECKLISTCATEGORY].[NAME]
FROM 
	[dbo].[IMCHECKLISTCATEGORY]
ORDER BY 
	[dbo].[IMCHECKLISTCATEGORY].[NAME]

END