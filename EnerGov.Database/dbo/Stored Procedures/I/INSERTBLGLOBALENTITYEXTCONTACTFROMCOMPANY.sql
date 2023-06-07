﻿CREATE PROCEDURE [dbo].[INSERTBLGLOBALENTITYEXTCONTACTFROMCOMPANY]
	
AS
	INSERT INTO BLGLOBALENTITYEXTENSIONCONTACT (BLGLOBALENTITYEXTCONTACTID, BLGLOBALENTITYEXTENSIONID, GLOBALENTITYID, BLCONTACTTYPEID)	
SELECT NEWID(), BLGLOBALENTITYEXTENSION.BLGLOBALENTITYEXTENSIONID, BLGLOBALENTITYEXTENSION.GLOBALENTITYID, SETTINGS.STRINGVALUE FROM BLGLOBALENTITYEXTENSION 
JOIN SETTINGS ON SETTINGS.NAME = 'DefaultContactTypeForBusiness' and SETTINGS.STRINGVALUE is not null and SETTINGS.STRINGVALUE <> ''
WHERE BLGLOBALENTITYEXTENSION.BLGLOBALENTITYEXTENSIONID + BLGLOBALENTITYEXTENSION.GLOBALENTITYID + SETTINGS.STRINGVALUE NOT IN (SELECT BLGLOBALENTITYEXTENSIONID + GLOBALENTITYID + BLCONTACTTYPEID FROM BLGLOBALENTITYEXTENSIONCONTACT)