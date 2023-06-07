﻿CREATE PROCEDURE [gissetup].[USP_SYSTEMACTION_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[SYSTEMACTION].[SYSTEMACTIONID],
	[dbo].[SYSTEMACTION].[NAME]
FROM 
	[dbo].[SYSTEMACTION]
ORDER BY 
	[dbo].[SYSTEMACTION].[NAME]

END