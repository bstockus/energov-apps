﻿CREATE PROCEDURE [inspectiondashboard].[USP_IMINSPECTORREF_DELETE_BY_INSPECTION_ID]
(
	@INSPECTIONID CHAR(36)
)
AS
DELETE FROM [dbo].[IMINSPECTORREF]
WHERE
	[INSPECTIONID] = @INSPECTIONID