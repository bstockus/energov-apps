﻿CREATE PROCEDURE [globalsetup].[USP_CUSTOMFIELDTEMPLATE_ASSOCIATEDFIELDS_GETBYCUSTOMFIELDTEMPLATEID]
(
	@GCUSTOMFIELDTEMPLATE CHAR(36)
)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		[dbo].[CUSTOMFIELD].[SFIELDNAME],
		[dbo].[CUSTOMFIELDLAYOUT].[SNAME],
		[dbo].[CUSTOMFIELDMODULES].[MODULENAME]
	FROM [dbo].[CUSTOMFIELDLAYOUT]
		INNER JOIN [dbo].[CUSTOMFIELDMODULES] 
			ON [dbo].[CUSTOMFIELDLAYOUT].[CUSTOMFIELDMODULEID]=[dbo].[CUSTOMFIELDMODULES].[CUSTOMFIELDMODULEID]
		INNER JOIN [dbo].[CUSTOMFIELDOBJECT] 
			ON [dbo].[CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS]=[dbo].[CUSTOMFIELDOBJECT].[FKGCUSTOMFIELDLAYOUT]
		INNER JOIN [dbo].[CUSTOMFIELD] 
			ON [dbo].[CUSTOMFIELDOBJECT].[GCUSTOMFIELD]= [dbo].[CUSTOMFIELD].[GCUSTOMFIELD]
		LEFT JOIN [dbo].[CUSTOMFIELDTEMPLATE] 
			ON [dbo].[CUSTOMFIELD].[FKGCUSTOMFIELDTEMPLATE]=[dbo].[CUSTOMFIELDTEMPLATE].[GCUSTOMFIELDTEMPLATE]
	WHERE [dbo].[CUSTOMFIELDTEMPLATE].[GCUSTOMFIELDTEMPLATE]=@GCUSTOMFIELDTEMPLATE
END