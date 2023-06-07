﻿CREATE PROCEDURE [dbo].[USP_PROVINCE_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[PROVINCE].[PROVINCEID],
	[dbo].[PROVINCE].[NAME],
	[dbo].[PROVINCE].[ABBREVIATION]
FROM [dbo].[PROVINCE]
ORDER BY [dbo].[PROVINCE].[ABBREVIATION] ASC
END