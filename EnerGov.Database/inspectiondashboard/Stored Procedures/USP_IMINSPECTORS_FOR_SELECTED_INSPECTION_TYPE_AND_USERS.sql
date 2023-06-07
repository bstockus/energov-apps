﻿CREATE PROCEDURE [inspectiondashboard].[USP_IMINSPECTORS_FOR_SELECTED_INSPECTION_TYPE_AND_USERS]
(	
	@RECORDIDs RecordIDs READONLY,
	@IMINSPECTIONTYPEID CHAR(36) = NULL
)
AS

SET NOCOUNT ON;

SELECT
	[dbo].[IMINSPECTORTYPEUSER].[USERID],
	[dbo].[IMINSPECTIONTYPE].[IMINSPECTIONTYPEID]
FROM [dbo].[IMINSPECTIONTYPE]
INNER JOIN [dbo].[IMINSPECTORTYPEINSPECTIONTYPE] ON [dbo].[IMINSPECTORTYPEINSPECTIONTYPE].[IMINSPECTIONTYPEID] = [dbo].[IMINSPECTIONTYPE].[IMINSPECTIONTYPEID]
INNER JOIN [dbo].[IMINSPECTORTYPEUSER] ON [dbo].[IMINSPECTORTYPEUSER].[INSPECTORTYPEID] = [dbo].[IMINSPECTORTYPEINSPECTIONTYPE].[IMINSPECTORTYPEID]
WHERE 
	[dbo].[IMINSPECTORTYPEUSER].[USERID] IN (SELECT ALL_USERS.RECORDID FROM @RECORDIDs ALL_USERS) AND 
	([dbo].[IMINSPECTIONTYPE].[IMINSPECTIONTYPEID] = @IMINSPECTIONTYPEID OR @IMINSPECTIONTYPEID IS NULL)
ORDER BY [dbo].[IMINSPECTORTYPEUSER].[USERID]