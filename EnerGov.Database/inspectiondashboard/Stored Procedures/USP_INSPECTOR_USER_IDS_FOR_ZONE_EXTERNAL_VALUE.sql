﻿CREATE PROCEDURE [inspectiondashboard].[USP_INSPECTOR_USER_IDS_FOR_ZONE_EXTERNAL_VALUE]
(	
	@GISZONEEXTERNALVALUEID CHAR(36)
)
AS

SET NOCOUNT ON;

SELECT DISTINCT
	[dbo].[GISZONETOINSPECTORDESIG].[USERID]
FROM [dbo].[GISZONETOINSPECTORDESIG]
INNER JOIN [dbo].[GISZONEEXTERNALVALUE] ON [dbo].[GISZONEEXTERNALVALUE].[GISZONEEXTERNALVALUEID] = [dbo].[GISZONETOINSPECTORDESIG].[GISZONEEXTERNALVALUEID]
WHERE [dbo].[GISZONEEXTERNALVALUE].[GISZONEEXTERNALVALUEID] = @GISZONEEXTERNALVALUEID
ORDER BY [dbo].[GISZONETOINSPECTORDESIG].[USERID]