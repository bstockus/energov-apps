﻿CREATE PROCEDURE [energovsystemreport].[USP_RPTREPORTATTRIBUTE_GETBYPARENTID]
(
	@RPTFRMTOBUSOBJMAPID CHAR(36)
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		[dbo].[RPTREPORTATTRIBUTE].[RPTREPORTATTRIBUTEID],
		[dbo].[RPTREPORTATTRIBUTE].[RPTREPORTID],
		[dbo].[RPTREPORTATTRIBUTE].[RPTPARAMTYPEID],
		[dbo].[RPTREPORTATTRIBUTE].[BUSINESSOBJECTPROPERTYNAME],
		[dbo].[RPTREPORTATTRIBUTE].[PROPERTYFRIENDLYNAME],
		[dbo].[RPTREPORTATTRIBUTE].[PROPERTYTOKEN],
		[dbo].[RPTREPORTATTRIBUTE].[ISMULTI],
		[dbo].[RPTREPORTATTRIBUTE].[PARAMETERNAME],
		[dbo].[RPTREPORTATTRIBUTE].[CHILDPARAMETERNAME],
		[dbo].[RPTREPORTATTRIBUTE].[PARAMETERORDER],
		[dbo].[RPTREPORTATTRIBUTE].[ISSTARTDATE],
		[dbo].[RPTREPORTATTRIBUTE].[ISREQUIRED],
		[dbo].[RPTREPORTATTRIBUTE].[VALUESOURCE]
	FROM [dbo].[RPTREPORTATTRIBUTE]
	INNER JOIN [dbo].[RPTREPORT] ON [dbo].[RPTREPORT].[RPTREPORTID] = [dbo].[RPTREPORTATTRIBUTE].[RPTREPORTID]
	WHERE [dbo].[RPTREPORT].[RPTFRMTOBUSOBJMAPID] = @RPTFRMTOBUSOBJMAPID
	ORDER BY [dbo].[RPTREPORTATTRIBUTE].[PARAMETERORDER]

END