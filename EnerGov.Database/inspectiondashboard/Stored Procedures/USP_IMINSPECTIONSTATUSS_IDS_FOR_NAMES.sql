﻿CREATE PROCEDURE [inspectiondashboard].[USP_IMINSPECTIONSTATUSS_IDS_FOR_NAMES]
(	
	@NAMES RecordNames READONLY
)
AS

SET NOCOUNT ON;

SELECT
	[dbo].[IMINSPECTIONSTATUS].[IMINSPECTIONSTATUSID],
	[dbo].[IMINSPECTIONSTATUS].[STATUSNAME]
FROM [dbo].[IMINSPECTIONSTATUS]
WHERE [dbo].[IMINSPECTIONSTATUS].[STATUSNAME] IN (SELECT ALL_NAMES.[Name] FROM @NAMES ALL_NAMES)
ORDER BY [dbo].[IMINSPECTIONSTATUS].[IMINSPECTIONSTATUSID]