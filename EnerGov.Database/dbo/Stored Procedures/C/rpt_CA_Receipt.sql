﻿

CREATE PROCEDURE [dbo].[rpt_CA_Receipt]
@TRANSACTIONID AS VARCHAR(36)
AS

SELECT CATransaction.CATransactionID, CATransaction.ReceiptNumber, CAComputedFee.CAComputedFeeID, CAComputedFee.FeeName, CATransactionFee.PaidAmount, CATRANSACTIONFEE.REFUNDAMOUNT,
       CATransactionType.Name AS TransactionType, CATransaction.GlobalEntityID, 
       COALESCE(BLLICENSE.LICENSENUMBER, CMCODECASE.CASENUMBER, ILLICENSE.LICENSENUMBER, PLAPPLICATION.APPNUMBER, PLPLAN.PLANNUMBER, PMPERMIT.PERMITNUMBER, PRPROJECT.PROJECTNUMBER, 
                RPLANDLORDLICENSE.LANDLORDNUMBER, RPPROPERTY.PROPERTYNUMBER, TXREMITTANCEACCOUNT.REMITTANCEACCOUNTNUMBER
       )AS CaseNumber,
       CATransactionPayment.PaymentDate, CAPaymentMethod.Name AS PaymentMethod, CATransactionPayment.SupplementalData,
       ( SELECT TOP 1 IMAGEVALUE FROM SETTINGS WHERE NAME = 'LogoImage' ) AS IMAGEVALUE
FROM CACOMPUTEDFEE 
INNER JOIN CATRANSACTIONFEE ON CATRANSACTIONFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID 
INNER JOIN CATRANSACTION ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID 
INNER JOIN CATRANSACTIONTYPE ON CATRANSACTIONTYPE.CATRANSACTIONTYPEID = CATRANSACTION.CATRANSACTIONTYPEID 
INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID  
INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID 
INNER JOIN CAPAYMENTMETHOD ON CATRANSACTIONPAYMENT.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID 
LEFT OUTER JOIN BLLICENSEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = BLLICENSEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN BLLICENSE ON BLLICENSEFEE.BLLICENSEID = BLLICENSE.BLLICENSEID 
LEFT OUTER JOIN CMCODECASEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CMCODECASEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN CMCODECASE ON CMCODECASEFEE.CMCODECASEID = CMCODECASE.CMCODECASEID 
LEFT OUTER JOIN ILLICENSEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = ILLICENSEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN ILLICENSE ON ILLICENSEFEE.ILLICENSEID = ILLICENSE.ILLICENSEID 
LEFT OUTER JOIN PLAPPLICATIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PLAPPLICATIONFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN PLAPPLICATION ON PLAPPLICATIONFEE.PLAPPLICATIONID = PLAPPLICATION.PLAPPLICATIONID 
LEFT OUTER JOIN PLPLANFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PLPLANFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN PLPLAN ON PLPLANFEE.PLPLANID = PLPLAN.PLPLANID 
LEFT OUTER JOIN PMPERMITFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PMPERMITFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN PMPERMIT ON PMPERMITFEE.PMPERMITID = PMPERMIT.PMPERMITID 
LEFT OUTER JOIN PRPROJECTFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = PRPROJECTFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN PRPROJECT ON PRPROJECTFEE.PRPROJECTID = PRPROJECT.PRPROJECTID 
LEFT OUTER JOIN RPLANDLORDLICENSEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = RPLANDLORDLICENSEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN RPLANDLORDLICENSE ON RPLANDLORDLICENSEFEE.RPLANDLORDLICENSEID = RPLANDLORDLICENSE.RPLANDLORDLICENSEID 
LEFT OUTER JOIN RPPROPERTYFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = RPPROPERTYFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN RPPROPERTY ON RPPROPERTYFEE.RPPROPERTYID = RPPROPERTY.RPPROPERTYID 
LEFT OUTER JOIN TXREMITTANCEFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = TXREMITTANCEFEE.CACOMPUTEDFEEID 
LEFT OUTER JOIN TXREMITTANCE ON TXREMITTANCEFEE.TXREMITTANCEID = TXREMITTANCE.TXREMITTANCEID 
LEFT OUTER JOIN TXREMITTANCEACCOUNT ON TXREMITTANCE.TXREMITTANCEACCOUNTID = TXREMITTANCEACCOUNT.TXREMITTANCEACCOUNTID
WHERE (NOT (CATRANSACTIONTYPE.NAME IN ('Void Reversal'))) 
AND   (NOT (CATRANSACTIONSTATUS.NAME IN ('Void'))) 
AND   CATransaction.CATransactionID = @TRANSACTIONID
UNION ALL

SELECT CATransaction.CATransactionID, CATransaction.ReceiptNumber, CAMiscFee.CAMISCFEEID AS CAComputedFeeID, CAMiscFee.FeeName, CATransactionMiscFee.PaidAmount, CATransactionMiscFee.REFUNDAMOUNT,
       CATransactionType.Name AS TransactionType, CATransaction.GlobalEntityID, 'Cashier' AS CaseNumber, 
       CATransactionPayment.PaymentDate, CAPaymentMethod.Name AS PaymentMethod, CATransactionPayment.SupplementalData,
       ( SELECT TOP 1 IMAGEVALUE FROM SETTINGS WHERE NAME = 'LogoImage' ) AS IMAGEVALUE
FROM CAMISCFEE 
INNER JOIN CATRANSACTIONMISCFEE ON CATRANSACTIONMISCFEE.CAMISCFEEID = CAMISCFEE.CAMISCFEEID 
INNER JOIN CATRANSACTION ON CATRANSACTIONMISCFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID 
INNER JOIN CATRANSACTIONTYPE ON CATRANSACTIONTYPE.CATRANSACTIONTYPEID = CATRANSACTION.CATRANSACTIONTYPEID 
INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID  
INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID 
INNER JOIN CAPAYMENTMETHOD ON CATRANSACTIONPAYMENT.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID
WHERE (NOT (CATRANSACTIONTYPE.NAME IN ('Void Reversal'))) 
AND   (NOT (CATRANSACTIONSTATUS.NAME IN ('Void'))) 
AND   CATransaction.CATransactionID = @TRANSACTIONID                      
UNION ALL

SELECT CATRANSACTION.CATRANSACTIONID, CATRANSACTION.RECEIPTNUMBER, CATRANSACTIONACCOUNT.CATRANSACTIONACCOUNTID, 
       'ACCT#  '+GLOBALENTITYACCOUNT.ACCOUNTNUMBER AS FEENAME, 
       CATRANSACTIONPAYMENT.PAYMENTAMOUNT, 0 AS REFUNDAMOUNT,
       CATransactionType.Name AS TransactionType, CATransaction.GlobalEntityID, 'Contacts Account' AS CaseNumber, 
       CATransactionPayment.PaymentDate, CAPaymentMethod.Name AS PaymentMethod, CATransactionPayment.SupplementalData,
       ( SELECT TOP 1 IMAGEVALUE FROM SETTINGS WHERE NAME = 'LogoImage' ) AS IMAGEVALUE
FROM GLOBALENTITYACCOUNT 
INNER JOIN GLOBALENTITYACCOUNTTYPE ON GLOBALENTITYACCOUNT.GLOBALENTITYACCOUNTTYPEID = GLOBALENTITYACCOUNTTYPE.GLOBALENTITYACCOUNTTYPEID
INNER JOIN CATRANSACTIONACCOUNT ON GLOBALENTITYACCOUNT.GLOBALENTITYACCOUNTID = CATRANSACTIONACCOUNT.ENTITYACCOUNTID
INNER JOIN CATRANSACTION ON CATRANSACTIONACCOUNT.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID
INNER JOIN CATRANSACTIONTYPE ON CATRANSACTIONTYPE.CATRANSACTIONTYPEID = CATRANSACTION.CATRANSACTIONTYPEID 
INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID
INNER JOIN CATRANSACTIONPAYMENT ON CATRANSACTION.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID
INNER JOIN CAPAYMENTMETHOD ON CATRANSACTIONPAYMENT.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID
WHERE (NOT (CATRANSACTIONTYPE.NAME IN ('Void Reversal'))) AND (NOT (CATRANSACTIONSTATUS.NAME IN ('Void'))) 
AND CATRANSACTION.CATRANSACTIONID = @TRANSACTIONID
AND NOT EXISTS ( SELECT 'X' FROM CATRANSACTIONFEE WHERE CATRANSACTION.CATRANSACTIONID = CATRANSACTIONFEE.CATRANSACTIONID )
AND NOT EXISTS ( SELECT 'X' FROM CATRANSACTIONMISCFEE WHERE CATRANSACTION.CATRANSACTIONID = CATRANSACTIONMISCFEE.CATRANSACTIONID )

/*
UNION ALL

SELECT CATRANSACTION.CATRANSACTIONID, CATRANSACTION.RECEIPTNUMBER, CATRANSACTIONBOND.CATRANSACTIONBONDID, 'BOND' AS FEENAME, 
       ISNULL(CATRANSACTIONPAYMENT.PAYMENTAMOUNT,0) AS PAYMENTAMOUNT, ISNULL(BONDREFUND.AMOUNT,0) AS REFUNDAMOUNT,
       CATransactionType.Name AS TransactionType, CATransaction.GlobalEntityID, 'Cashier' AS CaseNumber, 
       CATransactionPayment.PaymentDate, CAPaymentMethod.Name AS PaymentMethod, CATransactionPayment.SupplementalData
FROM   CATRANSACTIONBOND INNER JOIN
       CATRANSACTION ON CATRANSACTIONBOND.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID INNER JOIN
       CATRANSACTIONPAYMENT ON CATRANSACTIONBOND.CATRANSACTIONID = CATRANSACTIONPAYMENT.CATRANSACTIONID INNER JOIN
       CATRANSACTIONTYPE ON CATRANSACTION.CATRANSACTIONTYPEID = CATRANSACTIONTYPE.CATRANSACTIONTYPEID INNER JOIN
       CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID INNER JOIN
       CAPAYMENTMETHOD ON CATRANSACTIONPAYMENT.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID INNER JOIN
       BOND ON CATRANSACTIONBOND.BONDID = BOND.BONDID LEFT OUTER JOIN
       ( SELECT BONDRELEASE.BONDID, SUM(BONDRELEASE.AMOUNT) AS AMOUNT FROM BONDRELEASE GROUP BY BONDRELEASE.BONDID ) AS BONDREFUND ON BOND.BONDID = BONDREFUND.BONDID
WHERE  CATRANSACTION.CATRANSACTIONID = @TRANSACTIONID  
*/

