﻿

--exec rpt_BL_Tax_DueOrPartiallyPaid '2011-02-01','2012-03-01'

cREATE PROCEDURE [dbo].[rpt_BL_Tax_Account_Balance]

AS

SELECT 
       GLOBALENTITY.GLOBALENTITYNAME BusinessName,GlobalEntity.GlobalEntityID
       ,GLOBALENTITYACCOUNTTYPE.TYPENAME AccountType
       ,GLOBALENTITYACCOUNT.Name AccountName,GLOBALENTITYACCOUNT.BALANCE , GLOBALENTITYACCOUNT.ACCOUNTNUMBER
       ,GLOBALENTITYACCOUNT.DESCRIPTION
       ,TxRemittanceAccount.REMITTANCEACCOUNTNUMBER

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
AND GLOBALENTITYACCOUNT.Balance <>0

