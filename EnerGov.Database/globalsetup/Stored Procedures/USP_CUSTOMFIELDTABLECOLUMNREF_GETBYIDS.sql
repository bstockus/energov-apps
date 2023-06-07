﻿CREATE PROCEDURE [globalsetup].[USP_CUSTOMFIELDTABLECOLUMNREF_GETBYIDS]
(
	@RECORDIDs RecordIDs READONLY
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		[dbo].[CUSTOMFIELDTABLECOLUMNREF].[CUSTOMFIELDTABLECOLUMNREFID],
		[dbo].[CUSTOMFIELDTABLECOLUMNREF].[CUSTOMFIELDTABLEID],
		[dbo].[CUSTOMFIELDTABLECOLUMNREF].[DISPLAYNAME],
		[dbo].[CUSTOMFIELDTABLECOLUMNREF].[IORDER],
		[dbo].[CUSTOMFIELDTABLECOLUMNREF].[BISREQUIRED],
		[dbo].[CUSTOMFIELDTABLECOLUMNREF].[SHOWONMOBILE],
		[dbo].[CUSTOMFIELDTABLECOLUMNREF].[FORMULA],
		[dbo].[CUSTOMFIELDTABLECOLUMNREF].[SDEFAULTVALUE],
		[dbo].[CUSTOMFIELDLAYOUTCONTROLTYPE].[SNAME] AS CONTROLTYPENAME,
		[dbo].[CUSTOMFIELD].[GCUSTOMFIELD] AS FOOTERCUSTOMFIELD,
		[dbo].[CUSTOMFIELDCOLUMNTEMPLATE].[SCOLUMNNAME],
		TEMPLATEFIELD.[FKICUSTOMFIELDTYPE] AS FIELDTYPEID,
		[dbo].[CUSTOMFIELDTYPE].[SNAME] AS FIELDTYPENAME
	FROM [dbo].[CUSTOMFIELDTABLECOLUMNREF]
	LEFT OUTER JOIN [dbo].[CUSTOMFIELD] ON  [dbo].[CUSTOMFIELD].[FKCUSTOMFIELDTABLECOLREF] = [dbo].[CUSTOMFIELDTABLECOLUMNREF].[CUSTOMFIELDTABLECOLUMNREFID]
	INNER JOIN [dbo].[CUSTOMFIELDCOLUMNTEMPLATE] ON [dbo].[CUSTOMFIELDCOLUMNTEMPLATE].[CUSTOMFIELDCOLUMNTEMPLATEID] = [dbo].[CUSTOMFIELDTABLECOLUMNREF].[CUSTOMFIELDCOLUMNTEMPLATEID]
	INNER JOIN [dbo].[CUSTOMFIELD] AS TEMPLATEFIELD ON  TEMPLATEFIELD.[GCUSTOMFIELD] = [dbo].[CUSTOMFIELDCOLUMNTEMPLATE].[GCUSTOMFIELD]
	INNER JOIN [dbo].[CUSTOMFIELDTYPE] ON  [dbo].[CUSTOMFIELDTYPE].[ICUSTOMFIELDTYPE] = TEMPLATEFIELD.[FKICUSTOMFIELDTYPE]
	INNER JOIN [dbo].[CUSTOMFIELDLAYOUTCONTROLTYPE] ON  [dbo].[CUSTOMFIELDLAYOUTCONTROLTYPE].[ICUSTOMFIELDLAYOUTCONTROLTYPE] = [dbo].[CUSTOMFIELDCOLUMNTEMPLATE].[FKCUSTOMFIELDLAYOUTCONTROLTYPE]
	INNER JOIN @RECORDIDs AS RECORDIDS ON RECORDIDS.RECORDID = [dbo].[CUSTOMFIELDTABLECOLUMNREF].[CUSTOMFIELDTABLECOLUMNREFID]

END