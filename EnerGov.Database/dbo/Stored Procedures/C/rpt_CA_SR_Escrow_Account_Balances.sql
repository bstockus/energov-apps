﻿

CREATE PROCEDURE [dbo].[rpt_CA_SR_Escrow_Account_Balances]
AS
BEGIN

SELECT GE.GLOBALENTITYNAME AS CompanyName, GE.FIRSTNAME AS FirstName, GE.LASTNAME AS LastName, 
       GLOBALENTITYACCOUNT.ACCOUNTNUMBER AS AccountNumber, GLOBALENTITYACCOUNT.BALANCE AS CurrentAccountBalance
	  -- , TAXYEARLICENSE.LICENSENUMBER
	   , STUFF((select  ', '+ BL.LICENSENUMBER
		FROM BLLICENSE BL
		WHERE BL.BLGLOBALENTITYEXTENSIONID = MAXTAXYEAR.BLGLOBALENTITYEXTENSIONID AND BL.TAXYEAR = MAXTAXYEAR.MAXTAXYEAR
		ORDER BY BL.LICENSENUMBER
		for xml path(''), root('MyString'), type
		).value('/MyString[1]','varchar(max)'),1,2,'') AS 'LICENSENUMBER'
	   , GLOBALENTITYACCOUNTTYPE.TYPENAME AS ACCOUNTTYPE
	   , GLOBALENTITYACCOUNT.NAME AS ACCOUNTNAME
	   ,(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO
	   ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name
	   ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
	  
FROM   GLOBALENTITYACCOUNT
INNER JOIN GLOBALENTITYACCOUNTENTITY ON GLOBALENTITYACCOUNT.GLOBALENTITYACCOUNTID = GLOBALENTITYACCOUNTENTITY.GLOBALENTITYACCOUNTID
INNER JOIN GLOBALENTITY AS GE ON GLOBALENTITYACCOUNTENTITY.GLOBALENTITYID = GE.GLOBALENTITYID
INNER JOIN GLOBALENTITYACCOUNTTYPE ON GLOBALENTITYACCOUNT.GLOBALENTITYACCOUNTTYPEID = GLOBALENTITYACCOUNTTYPE.GLOBALENTITYACCOUNTTYPEID
LEFT OUTER JOIN BLGLOBALENTITYEXTENSION AS BLGE ON GE.GLOBALENTITYID = BLGE.GLOBALENTITYID
LEFT OUTER JOIN ( SELECT BLGLOBALENTITYEXTENSIONID,MAX(TAXYEAR) MAXTAXYEAR
                  FROM   BLLICENSE
                  GROUP BY BLGLOBALENTITYEXTENSIONID
                ) AS MAXTAXYEAR ON BLGE.BLGLOBALENTITYEXTENSIONID = MAXTAXYEAR.BLGLOBALENTITYEXTENSIONID
/*Removing to prevent duplicates when multiple licenses under one business account*/				
--LEFT OUTER JOIN ( SELECT BLGLOBALENTITYEXTENSIONID,BLLICENSEID,LICENSENUMBER,TAXYEAR 
--                  FROM   BLLICENSE
--                ) AS TAXYEARLICENSE ON MAXTAXYEAR.BLGLOBALENTITYEXTENSIONID = TAXYEARLICENSE.BLGLOBALENTITYEXTENSIONID AND MAXTAXYEAR.MAXTAXYEAR = TAXYEARLICENSE.TAXYEAR
WHERE  GLOBALENTITYACCOUNT.BALANCE  > 0

END
