﻿
CREATE PROCEDURE [dbo].[rpt_SR_SR_Fee_Setup_GLAccount]
@FEEID AS VARCHAR(36)
AS
SELECT CAPAYMENTMETHOD.NAME AS PaymentMethod, GLACCOUNT.NAME AS CreditAccount, 
       GLACCOUNT_1.NAME AS DebitAccount, 
       CAFEEGLACCOUNTXREF.PERCENTAGE AS Percentage
FROM CAFEEGLACCOUNTXREF 
INNER JOIN GLACCOUNT ON CAFEEGLACCOUNTXREF.CREDITGLACCOUNTID = GLACCOUNT.GLACCOUNTID 
INNER JOIN CAPAYMENTMETHOD ON CAFEEGLACCOUNTXREF.CAPAYMENTMETHODID = CAPAYMENTMETHOD.CAPAYMENTMETHODID 
INNER JOIN GLACCOUNT AS GLACCOUNT_1 ON CAFEEGLACCOUNTXREF.DEBITGLACCOUNTID = GLACCOUNT_1.GLACCOUNTID
WHERE CAFEEGLACCOUNTXREF.CAFEEID = @FEEID

