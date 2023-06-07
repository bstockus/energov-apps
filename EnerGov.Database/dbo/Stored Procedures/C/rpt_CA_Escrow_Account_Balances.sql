﻿


CREATE PROCEDURE [dbo].[rpt_CA_Escrow_Account_Balances]
AS

SELECT GE.GLOBALENTITYNAME AS CompanyName, GE.FIRSTNAME AS FirstName, GE.LASTNAME AS LastName, 
       GLOBALENTITYACCOUNT.ACCOUNTNUMBER AS AccountNumber, GLOBALENTITYACCOUNT.BALANCE AS CurrentAccountBalance,
       TAXYEARLICENSE.LICENSENUMBER, GLOBALENTITYACCOUNTTYPE.TYPENAME AS ACCOUNTTYPE, GLOBALENTITYACCOUNT.NAME AS ACCOUNTNAME
FROM   GLOBALENTITYACCOUNT
INNER JOIN GLOBALENTITYACCOUNTENTITY ON GLOBALENTITYACCOUNT.GLOBALENTITYACCOUNTID = GLOBALENTITYACCOUNTENTITY.GLOBALENTITYACCOUNTID
INNER JOIN GLOBALENTITY AS GE ON GLOBALENTITYACCOUNTENTITY.GLOBALENTITYID = GE.GLOBALENTITYID
INNER JOIN GLOBALENTITYACCOUNTTYPE ON GLOBALENTITYACCOUNT.GLOBALENTITYACCOUNTTYPEID = GLOBALENTITYACCOUNTTYPE.GLOBALENTITYACCOUNTTYPEID
LEFT OUTER JOIN BLGLOBALENTITYEXTENSION AS BLGE ON GE.GLOBALENTITYID = BLGE.GLOBALENTITYID
LEFT OUTER JOIN ( SELECT BLGLOBALENTITYEXTENSIONID,MAX(TAXYEAR) MAXTAXYEAR
                  FROM   BLLICENSE
                  GROUP BY BLGLOBALENTITYEXTENSIONID
                ) AS MAXTAXYEAR ON BLGE.BLGLOBALENTITYEXTENSIONID = MAXTAXYEAR.BLGLOBALENTITYEXTENSIONID
LEFT OUTER JOIN ( SELECT BLGLOBALENTITYEXTENSIONID,BLLICENSEID,LICENSENUMBER,TAXYEAR 
                  FROM   BLLICENSE
                ) AS TAXYEARLICENSE ON MAXTAXYEAR.BLGLOBALENTITYEXTENSIONID = TAXYEARLICENSE.BLGLOBALENTITYEXTENSIONID AND MAXTAXYEAR.MAXTAXYEAR = TAXYEARLICENSE.TAXYEAR
WHERE  GLOBALENTITYACCOUNT.BALANCE  > 0


