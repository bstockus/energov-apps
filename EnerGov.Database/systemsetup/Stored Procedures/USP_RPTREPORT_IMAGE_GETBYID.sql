﻿CREATE PROCEDURE [systemsetup].[USP_RPTREPORT_IMAGE_GETBYID]
(
	@REPORTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;

SELECT 
		[dbo].[RPTREPORT].[RPTREPORTID],
		[dbo].[RPTREPORT].[REPORTPREVIEWIMAGE]
	FROM [dbo].[RPTREPORT]
	WHERE [dbo].[RPTREPORT].[RPTREPORTID] = @REPORTID
END