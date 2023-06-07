﻿CREATE PROCEDURE [systemsetup].[USP_RPTREPORTFILETYPE_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[RPTREPORTFILETYPE].[RPTREPORTFILETYPEID],
	[dbo].[RPTREPORTFILETYPE].[RPTREPORTTYPEID],
	[dbo].[RPTREPORTFILETYPE].[FILETYPE],
	[dbo].[RPTREPORTFILETYPE].[NAME]
FROM 
	[dbo].[RPTREPORTFILETYPE]
ORDER BY 
	[dbo].[RPTREPORTFILETYPE].[RPTREPORTTYPEID],
	[dbo].[RPTREPORTFILETYPE].[NAME]
END