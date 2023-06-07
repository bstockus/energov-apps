﻿CREATE PROCEDURE [managecontacts].[USP_MANAGECONTACT_GETBYIDS]
(
	@MANAGECONTACTLIST RecordIDs READONLY,
	@USERID AS CHAR(36) = NULL
)
AS	
BEGIN

SELECT 
	[GLOBALENTITY].[GLOBALENTITYID],    
 [GLOBALENTITY].[GLOBALENTITYNAME],    
 [GLOBALENTITY].[TITLE],    
 [GLOBALENTITY].[LASTCHANGEDON],    
 [GLOBALENTITY].[FIRSTNAME],    
 [GLOBALENTITY].[MIDDLENAME],    
 [GLOBALENTITY].[LASTNAME],    
 [GLOBALENTITY].[ISACTIVE],    
 [GLOBALENTITY].[EMAIL],    
 [GLOBALENTITY].[ISCONTACT],    
 [GLOBALENTITY].[ISCOMPANY],    
 [GLOBALENTITY].[MOBILEPHONE],    
 [GLOBALENTITY].[HOMEPHONE],    
   CASE WHEN EXISTS     
    (SELECT 1 FROM [dbo].[CITIZENREQUESTCALLERXREF]       
     WHERE [CITIZENREQUESTCALLERXREF].[GLOBALENTITYID]  = [GLOBALENTITY].[GLOBALENTITYID])    
  THEN CAST(1 AS BIT)     
  ELSE CAST(0 AS BIT)
  END AS ISPORTAL,    
 [GLOBALENTITY].[CONTACTID]    
 FROM [dbo].[GLOBALENTITY]  
INNER JOIN @MANAGECONTACTLIST MANAGECONTACTLIST ON [GLOBALENTITY].[GLOBALENTITYID] = MANAGECONTACTLIST.RECORDID
LEFT OUTER JOIN [dbo].[RECENTHISTORYGLOBALENTITY] ON [dbo].[RECENTHISTORYGLOBALENTITY].[GLOBALENTITYID] =[GLOBALENTITY].[GLOBALENTITYID]
 AND [RECENTHISTORYGLOBALENTITY].[USERID] = @USERID
ORDER BY [RECENTHISTORYGLOBALENTITY].[LOGGEDDATETIME] DESC

EXEC [managecontacts].[USP_MANAGECONTACTADDRESS_GETBYIDS] @MANAGECONTACTLIST

END