﻿
CREATE VIEW [dbo].[PORTALINVOICEMISCFEE]
AS
SELECT  CAINVOICEMISCFEE.CAINVOICEID,
        CAMISCFEE.FEENAME,
        CAMISCFEE.AMOUNT AS FEETOTAL,
        CAMISCFEE.PAIDAMOUNT,
        (CAMISCFEE.AMOUNT - CAMISCFEE.PAIDAMOUNT) AS AMOUNTDUE
  FROM CAINVOICEMISCFEE
  INNER JOIN CAMISCFEE ON CAMISCFEE.CAMISCFEEID = CAINVOICEMISCFEE.CAMISCFEEID

