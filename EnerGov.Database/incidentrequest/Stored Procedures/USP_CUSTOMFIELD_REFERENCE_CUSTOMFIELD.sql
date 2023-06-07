﻿/*
  Get Custom Fields can hold data in the Layout exclude Table and Worksheet
*/
CREATE PROCEDURE [incidentrequest].[USP_CUSTOMFIELD_REFERENCE_CUSTOMFIELD]
	@LayoutId CHAR(36)
AS
BEGIN

	SET NOCOUNT ON;

	SELECT [CUSTOMFIELD].[GCUSTOMFIELD],
		   [CUSTOMFIELD].[SFIELDNAME], 
		   CASE WHEN [CUSTOMFIELDOBJECT].[ISLABELSURPRESSED] = 1 THEN [CUSTOMFIELD].[SCUSTOMFIELD] ELSE [CUSTOMFIELDOBJECT].[SLABEL] END AS [FIELDLABEL],
		   [CUSTOMFIELD].[FKICUSTOMFIELDTYPE], 
		   [CUSTOMFIELDOBJECT].[FKCUSTOMFIELDLAYOUTCONTROLTYPE],	   
		   [CUSTOMFIELD].[BISPICKLIST], 
		   COALESCE([CUSTOMFIELDPICKLIST].[GCUSTOMFIELDPICKLIST], '') AS [GCUSTOMFIELDPICKLIST], 
		   CAST(COALESCE([CUSTOMFIELDPICKLIST].[BALLOWMULTIPLESELECTIONS], 0) AS BIT) AS [BALLOWMULTIPLESELECTIONS]
	FROM [dbo].[CUSTOMFIELDLAYOUT]
	JOIN [dbo].[CUSTOMFIELDOBJECT] ON [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = [CUSTOMFIELDOBJECT].[FKGCUSTOMFIELDLAYOUT]
	JOIN [dbo].[CUSTOMFIELD] ON [CUSTOMFIELDOBJECT].[GCUSTOMFIELD] = [CUSTOMFIELD].[GCUSTOMFIELD]
	LEFT JOIN [dbo].[CUSTOMFIELDPICKLIST] ON [CUSTOMFIELD].[GCUSTOMFIELD] = [CUSTOMFIELDPICKLIST].[FKGCUSTOMFIELD]
	WHERE [CUSTOMFIELDLAYOUT].[GCUSTOMFIELDLAYOUTS] = @LayoutId
	AND [CUSTOMFIELD].[FKCUSTOMFIELDTABLE] IS NULL
	AND COALESCE([CUSTOMFIELD].[BISWORKSHEET], 0) = 0
	AND COALESCE([CUSTOMFIELDOBJECT].[BFOOTER], 0) = 0
	AND [CUSTOMFIELDOBJECT].[FKCUSTOMFIELDLAYOUTCONTROLTYPE] IN (1,2,3)
	ORDER BY [CUSTOMFIELDOBJECT].[IPOSITION]

END