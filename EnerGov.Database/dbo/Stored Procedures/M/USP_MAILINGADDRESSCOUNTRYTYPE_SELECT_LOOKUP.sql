﻿CREATE PROCEDURE [dbo].[USP_MAILINGADDRESSCOUNTRYTYPE_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[MAILINGADDRESSCOUNTRYTYPE].[MAILINGADDRESSCOUNTRYTYPEID],
	[dbo].[MAILINGADDRESSCOUNTRYTYPE].[MAILINGADDRESSCOUNTRYTYPENAME] AS [NAME]
FROM [dbo].[MAILINGADDRESSCOUNTRYTYPE]
END