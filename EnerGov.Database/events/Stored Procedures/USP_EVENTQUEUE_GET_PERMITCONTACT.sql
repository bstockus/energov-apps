﻿CREATE PROCEDURE [events].[USP_EVENTQUEUE_GET_PERMITCONTACT]
(
@UNIQUEIDS RecordIDs READONLY
)
AS
BEGIN
	SELECT 
		[PMPERMITCONTACT].[PMPERMITID],
		[PMPERMITCONTACT].[ISBILLING],
		[GLOBALENTITY].[GLOBALENTITYID],
		[GLOBALENTITY].[GLOBALENTITYNAME],
		[GLOBALENTITY].[FIRSTNAME],
		[GLOBALENTITY].[MIDDLENAME],
		[GLOBALENTITY].[LASTNAME],
		[LANDMANAGEMENTCONTACTTYPE].NAME AS [CONTACTTYPENAME],
		[LANDMANAGEMENTCONTACTSYSTEMTYP].NAME AS [SYSTEMCONTACTTYPENAME]
	FROM [dbo].[PMPERMITCONTACT] WITH(NOLOCK)
	INNER JOIN @UNIQUEIDS AS [PMPERMITIDs] ON [dbo].[PMPERMITCONTACT].[PMPERMITID] = [PMPERMITIDs].[RECORDID]
	INNER JOIN [dbo].[GLOBALENTITY] WITH(NOLOCK) ON [dbo].[GLOBALENTITY].[GLOBALENTITYID] = [dbo].[PMPERMITCONTACT].[GLOBALENTITYID]
	INNER JOIN [dbo].[LANDMANAGEMENTCONTACTTYPE] WITH(NOLOCK) ON [dbo].[LANDMANAGEMENTCONTACTTYPE].[LANDMANAGEMENTCONTACTTYPEID] = [dbo].[PMPERMITCONTACT].[LANDMANAGEMENTCONTACTTYPEID]
	INNER JOIN [dbo].[LANDMANAGEMENTCONTACTSYSTEMTYP] WITH(NOLOCK) ON [dbo].[LANDMANAGEMENTCONTACTSYSTEMTYP].[LANDMANAGEMENTCONTACTSYSTEMTYP] = [dbo].[LANDMANAGEMENTCONTACTTYPE].[LANDMANAGEMENTCONTACTSYSTEMTYP]
END