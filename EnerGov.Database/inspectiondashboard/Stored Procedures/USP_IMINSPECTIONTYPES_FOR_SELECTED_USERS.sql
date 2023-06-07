﻿CREATE PROCEDURE [inspectiondashboard].[USP_IMINSPECTIONTYPES_FOR_SELECTED_USERS]
(	
	@RECORDIDs RecordIDs READONLY
)
AS

SET NOCOUNT ON;

SELECT
	[dbo].[IMINSPECTIONTYPE].[IMINSPECTIONTYPEID],
	[dbo].[IMINSPECTORTYPEUSER].[USERID]
FROM [dbo].[IMINSPECTIONTYPE]
INNER JOIN [dbo].[IMINSPECTORTYPEINSPECTIONTYPE] ON [dbo].[IMINSPECTORTYPEINSPECTIONTYPE].[IMINSPECTIONTYPEID] = [dbo].[IMINSPECTIONTYPE].[IMINSPECTIONTYPEID]
INNER JOIN [dbo].[IMINSPECTORTYPEUSER] ON [dbo].[IMINSPECTORTYPEUSER].[INSPECTORTYPEID] = [dbo].[IMINSPECTORTYPEINSPECTIONTYPE].[IMINSPECTORTYPEID]
WHERE [dbo].[IMINSPECTORTYPEUSER].[USERID] IN (SELECT ALL_USERS.RECORDID FROM @RECORDIDs ALL_USERS)
ORDER BY [dbo].[IMINSPECTIONTYPE].[IMINSPECTIONTYPEID]