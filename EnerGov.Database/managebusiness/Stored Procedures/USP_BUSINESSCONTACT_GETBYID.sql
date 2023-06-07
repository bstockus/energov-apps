﻿CREATE PROCEDURE [managebusiness].[USP_BUSINESSCONTACT_GETBYID]  
(@GLOBALENTITYEXTENSIONID CHAR(36),
@BLCONTACTTYPESYSTEMID INT = 0)  
AS  
BEGIN  
    SET NOCOUNT ON;  
  
    SELECT TOP 1 -- As we were using FirstOrDefault in EF query.  
           [GLOBALENTITY].[GLOBALENTITYNAME],  
           [GLOBALENTITY].[GLOBALENTITYID],  
           [GLOBALENTITY].[FIRSTNAME],  
           [GLOBALENTITY].[LASTNAME],  
           [GLOBALENTITY].[FIRSTNAME] + ' ' + [GLOBALENTITY].[LASTNAME] AS FULLNAME,  
           [GLOBALENTITY].[BUSINESSPHONE],  
           [GLOBALENTITY].[HOMEPHONE],  
           [GLOBALENTITY].[MOBILEPHONE],  
           [GLOBALENTITY].[OTHERPHONE],  
           [GLOBALENTITY].[EMAIL],  
           [GLOBALENTITY].[TITLE]  
    FROM [dbo].[BLGLOBALENTITYEXTENSIONCONTACT]  
        INNER JOIN [dbo].[GLOBALENTITY]  
            ON [BLGLOBALENTITYEXTENSIONCONTACT].[GLOBALENTITYID] = [GLOBALENTITY].[GLOBALENTITYID]  
   INNER JOIN [dbo].[BLCONTACTTYPE]  ON [BLGLOBALENTITYEXTENSIONCONTACT].[BLCONTACTTYPEID]=[BLCONTACTTYPE].[BLCONTACTTYPEID]     
    WHERE [BLGLOBALENTITYEXTENSIONCONTACT].[BLGLOBALENTITYEXTENSIONID] = @GLOBALENTITYEXTENSIONID
    AND ([BLCONTACTTYPE].[BLCONTACTTYPESYSTEMID] = @BLCONTACTTYPESYSTEMID OR @BLCONTACTTYPESYSTEMID = 0)
	ORDER BY FULLNAME DESC

END;