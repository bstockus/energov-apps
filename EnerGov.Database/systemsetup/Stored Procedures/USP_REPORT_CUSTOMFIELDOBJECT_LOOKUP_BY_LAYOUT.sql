﻿CREATE PROCEDURE [systemsetup].[USP_REPORT_CUSTOMFIELDOBJECT_LOOKUP_BY_LAYOUT]
	@CUSTOMLAYOUTID char(36)
AS
BEGIN
SET NOCOUNT ON;

SELECT  [CUSTOMFIELDOBJECT].[GCUSTOMFIELD],
		[CUSTOMFIELD].[SFIELDNAME], 
		[CUSTOMFIELDOBJECT].[SLABEL], 
		[CUSTOMFIELDLAYOUTCONTROLTYPE].[SNAME], 
		[CUSTOMFIELDOBJECT2].[SLABEL] PARENTLABEL

FROM [CUSTOMFIELDOBJECT] 
	INNER JOIN [CUSTOMFIELDLAYOUTCONTROLTYPE] on 
	[CUSTOMFIELDOBJECT].[FKCUSTOMFIELDLAYOUTCONTROLTYPE] = [CUSTOMFIELDLAYOUTCONTROLTYPE].[ICUSTOMFIELDLAYOUTCONTROLTYPE]
	 LEFT JOIN [CUSTOMFIELD] on 
	 [CUSTOMFIELDOBJECT].[FKGCUSTOMFIELD] = [CUSTOMFIELD].[GCUSTOMFIELD]
	 LEFT JOIN [CUSTOMFIELDOBJECT] CUSTOMFIELDOBJECT2 on [CUSTOMFIELDOBJECT].[FKGPARENTCONTROL] = [CUSTOMFIELDOBJECT2].[GCUSTOMFIELD]
WHERE 
[CUSTOMFIELDOBJECT].[FKGCUSTOMFIELDLAYOUT] = @CUSTOMLAYOUTID AND 
([CUSTOMFIELDLAYOUTCONTROLTYPE].[ICUSTOMFIELDLAYOUTCONTROLTYPE] = 1 
OR [CUSTOMFIELDLAYOUTCONTROLTYPE].[ICUSTOMFIELDLAYOUTCONTROLTYPE] = 2 
OR [CUSTOMFIELDLAYOUTCONTROLTYPE].[ICUSTOMFIELDLAYOUTCONTROLTYPE] = 3
OR [CUSTOMFIELDLAYOUTCONTROLTYPE].[ICUSTOMFIELDLAYOUTCONTROLTYPE] = 9 )  

ORDER BY [CUSTOMFIELDOBJECT].[IPOSITION]	
END