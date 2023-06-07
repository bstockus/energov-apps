﻿CREATE FUNCTION [managebusinesslicense].[UFN_GET_LICENSE_BALANCE_DUE]
(
	@LICENSEID char(36)
)
RETURNS MONEY
AS
BEGIN
	DECLARE @BALANCEDUE AS MONEY
	SELECT @BALANCEDUE = ISNULL(SUM(CACOMPUTEDFEE.COMPUTEDAMOUNT - CACOMPUTEDFEE.AMOUNTPAIDTODATE),0)
	FROM BLLICENSEFEE 
	INNER JOIN CACOMPUTEDFEE ON BLLICENSEFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID AND CACOMPUTEDFEE.CASTATUSID NOT IN (10,5) -- DELETED & VOID
	WHERE BLLICENSEFEE.BLLICENSEID = @LICENSEID
	RETURN @BALANCEDUE;
END