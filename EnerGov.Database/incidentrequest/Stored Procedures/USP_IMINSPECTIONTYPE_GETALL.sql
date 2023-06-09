﻿CREATE PROCEDURE [incidentrequest].[USP_IMINSPECTIONTYPE_GETALL]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
		[IMINSPECTIONTYPE].[IMINSPECTIONTYPEID],
		[IMINSPECTIONTYPE].[NAME],
		[IMINSPECTIONTYPE].[DESCRIPTION]
	FROM [dbo].[IMINSPECTIONTYPE] 
	ORDER BY [IMINSPECTIONTYPE].[NAME]
END