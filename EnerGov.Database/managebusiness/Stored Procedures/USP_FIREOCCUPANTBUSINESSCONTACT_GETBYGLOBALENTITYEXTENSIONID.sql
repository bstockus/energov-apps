﻿CREATE PROCEDURE [managebusiness].[USP_FIREOCCUPANTBUSINESSCONTACT_GETBYGLOBALENTITYEXTENSIONID]
@BLGLOBALENTITYEXTENSIONID CHAR(36)
AS  
BEGIN  
    SET NOCOUNT ON;
    SELECT 
           BLGLOBALENTITYEXTENSIONCONTACT.BLGLOBALENTITYEXTENSIONID,
           BLGLOBALENTITYEXTENSIONCONTACT.BLGLOBALENTITYEXTCONTACTID,
           GLOBALENTITY.GLOBALENTITYID,           
           GLOBALENTITY.FIRSTNAME,  
           GLOBALENTITY.LASTNAME,  
           GLOBALENTITY.GLOBALENTITYNAME,  
           GLOBALENTITY.TITLE,  
           GLOBALENTITY.BUSINESSPHONE,  
           GLOBALENTITY.MOBILEPHONE, 
           GLOBALENTITY.EMAIL,  
           GLOBALENTITY.FAX           
    FROM dbo.BLGLOBALENTITYEXTENSIONCONTACT  
    INNER JOIN dbo.GLOBALENTITY ON BLGLOBALENTITYEXTENSIONCONTACT.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID
    WHERE BLGLOBALENTITYEXTENSIONCONTACT.BLGLOBALENTITYEXTENSIONID = @BLGLOBALENTITYEXTENSIONID  
    
    DECLARE @GLOBALENTITYIDS RECORDIDS
    INSERT INTO @GLOBALENTITYIDS (RECORDID) 
    SELECT GLOBALENTITYID FROM BLGLOBALENTITYEXTENSIONCONTACT 
    WHERE BLGLOBALENTITYEXTENSIONCONTACT.BLGLOBALENTITYEXTENSIONID = @BLGLOBALENTITYEXTENSIONID

    EXEC [managebusiness].[USP_FIREOCCUPANTBUSINESSCONTACTADDRESS_GETBYGLOBALENTITYIDS] @GLOBALENTITYIDS
    EXEC [managebusiness].[USP_FIREOCCUPANTBUSINESSCONTACTTYPE_GETBYGLOBALENTITYIDS] @GLOBALENTITYIDS

END;