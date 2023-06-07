﻿
CREATE PROCEDURE [dbo].[rpt_TX_SR_Tax_Remittance_Report_Account_Balance]
AS
-- exec rpt_TX_SR_Tax_Remittance_Report_Account_Balance
SELECT 
       GLOBALENTITY.GLOBALENTITYNAME BusinessName,GlobalEntity.GlobalEntityID,
       GLOBALENTITYACCOUNTTYPE.TYPENAME AccountType,
       GLOBALENTITYACCOUNT.Name AccountName,GLOBALENTITYACCOUNT.BALANCE , GLOBALENTITYACCOUNT.ACCOUNTNUMBER,
       GLOBALENTITYACCOUNT.DESCRIPTION,
       TxRemittanceAccount.REMITTANCEACCOUNTNUMBER,
--(SELECT R.[IMAGE] FROM RPTIMAGELIB R
--		WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer

FROM GLOBALENTITY
INNER JOIN GLOBALENTITYACCOUNTENTITY ON GLOBALENTITY.GLOBALENTITYID  = GLOBALENTITYACCOUNTENTITY.GLOBALENTITYID
INNER JOIN GLOBALENTITYACCOUNT ON GLOBALENTITYACCOUNTENTITY.GLOBALENTITYACCOUNTID = GLOBALENTITYACCOUNT.GLOBALENTITYACCOUNTID
INNER JOIN GLOBALENTITYACCOUNTTYPE ON GLOBALENTITYACCOUNT.GLOBALENTITYACCOUNTTYPEID = GLOBALENTITYACCOUNTTYPE.GLOBALENTITYACCOUNTTYPEID
LEFT OUTER JOIN BLGLOBALENTITYEXTENSION ON GLOBALENTITY.GLOBALENTITYID  = BLGLOBALENTITYEXTENSION.GLOBALENTITYID
INNER JOIN TXREMITTANCEACCOUNT ON TXREMITTANCEACCOUNT.BLGLOBALENTITYEXTENSIONID = BLGLOBALENTITYEXTENSION.BLGLOBALENTITYEXTENSIONID
INNER JOIN TXREMACCCONTACT ON GLOBALENTITY.GLOBALENTITYID = TXREMACCCONTACT.GLOBALENTITYID 
INNER JOIN TXREMITSTATUS ON TxRemittanceAccount.TxRemittanceStatusID = TxRemitStatus.TxRemitStatusID

WHERE TxRemitStatus.TxRemitStatusSystemID <> 2 
	AND GLOBALENTITYACCOUNT.ACTIVE = 1
	AND GLOBALENTITYACCOUNT.Balance <> 0

Order by TxRemittanceAccount.REMITTANCEACCOUNTNUMBER, GLOBALENTITYACCOUNT.ACCOUNTNUMBER

