﻿CREATE PROCEDURE [systemsetup].[USP_RPTREPORT_LOOKUP_BY_MAPPING]
(
	@BUSINESSOBJECT AS NVARCHAR(255) = ''
)
AS
SELECT 
		[dbo].[RPTREPORT].[RPTREPORTID],
		[dbo].[RPTREPORT].[REPORTNAME],
		[dbo].[RPTREPORT].[FRIENDLYNAME]
FROM [dbo].[RPTREPORT]
JOIN [dbo].[RPTFORMTOBUSINESSOBJECTMAPPING]
ON [dbo].[RPTREPORT].[RPTFRMTOBUSOBJMAPID] = [dbo].[RPTFORMTOBUSINESSOBJECTMAPPING].[RPTFRMTOBUSOBJMAPID]
WHERE [dbo].[RPTFORMTOBUSINESSOBJECTMAPPING].[TYPEOFBBUSINESSOBJECT] = @BUSINESSOBJECT