﻿ CREATE FUNCTION [managebusiness].[UFN_GET_BLLICENSE_BALANCE_DUE]
(
     @BLGLOBALENTITYEXTENSIONID CHAR(36),
	 @CURRENTDATE DATETIME
)
RETURNS MONEY
AS
BEGIN
    DECLARE @BALANCEDUE AS MONEY
    SELECT @BALANCEDUE = ISNULL(SUM(CACOMPUTEDFEE.COMPUTEDAMOUNT - CACOMPUTEDFEE.AMOUNTPAIDTODATE),0)
    FROM [dbo].[BLLICENSEFEE]
    INNER JOIN [dbo].[BLLICENSE] ON  [BLLICENSE].[BLLICENSEID] = [BLLICENSEFEE].[BLLICENSEID]
    INNER JOIN [dbo].[CACOMPUTEDFEE]  ON [BLLICENSEFEE].[CACOMPUTEDFEEID] = [CACOMPUTEDFEE].[CACOMPUTEDFEEID]
    WHERE
      [BLLICENSE].[BLGLOBALENTITYEXTENSIONID] = @BLGLOBALENTITYEXTENSIONID
 AND [BLLICENSE].[LASTRENEWALDATE] IS NULL
 AND ([BLLICENSE].[EXPIRATIONDATE] IS NULL OR [BLLICENSE].[EXPIRATIONDATE] > @CURRENTDATE)
 AND ((CASE WHEN (BLLICENSE.BLLICENSEPARENTID IS NOT NULL AND BLLICENSE.BLLICENSEPARENTID = BLLICENSE.BLLICENSEID) THEN  0 ELSE 1 END)=1)
 AND [CACOMPUTEDFEE].[CASTATUSID] NOT IN (10,5) -- FeeStatuses.Deleted | 5 --FeeStatuses.Void

    RETURN @BALANCEDUE;
END