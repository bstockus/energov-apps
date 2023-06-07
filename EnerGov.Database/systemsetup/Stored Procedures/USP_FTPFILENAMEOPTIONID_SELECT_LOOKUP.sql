﻿CREATE PROCEDURE [systemsetup].[USP_FTPFILENAMEOPTIONID_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[FTPFILENAMEOPTION].[FTPFILENAMEOPTIONID],
	[dbo].[FTPFILENAMEOPTION].[NAME],
	[dbo].[FTPFILENAMEOPTION].[DESCRIPTION]
FROM 
	[dbo].[FTPFILENAMEOPTION]
ORDER BY 
	[dbo].[FTPFILENAMEOPTION].[NAME]
END