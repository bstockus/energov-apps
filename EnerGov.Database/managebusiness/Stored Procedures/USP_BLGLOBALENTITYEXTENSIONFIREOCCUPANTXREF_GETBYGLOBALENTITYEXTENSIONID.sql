﻿CREATE PROCEDURE [managebusiness].[USP_BLGLOBALENTITYEXTENSIONFIREOCCUPANTXREF_GETBYGLOBALENTITYEXTENSIONID]
(  
 @GLOBALENTITYEXTENSIONID CHAR(36)  
)  
AS  
BEGIN
SET NOCOUNT ON;
SELECT 
	[BLGLOBALENTITYEXTENSIONFIREOCCUPANTXREFID],
	[BLGLOBALENTITYEXTENSIONID],
	[FIREOCCUPANTID]
FROM [dbo].[BLGLOBALENTITYEXTENSIONFIREOCCUPANTXREF]
WHERE
	[BLGLOBALENTITYEXTENSIONFIREOCCUPANTXREF].[BLGLOBALENTITYEXTENSIONID] = @GLOBALENTITYEXTENSIONID 
END