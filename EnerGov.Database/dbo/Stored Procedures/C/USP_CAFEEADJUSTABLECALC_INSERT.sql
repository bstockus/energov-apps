﻿CREATE PROCEDURE [dbo].[USP_CAFEEADJUSTABLECALC_INSERT]
(
	@CAFEEADJUSTABLECALCID CHAR(36),
	@CAFEEID CHAR(36),
	@LOWERLIMIT DECIMAL(20,4),
	@UPPERLIMIT DECIMAL(20,4),
	@UNLIMITED BIT,
	@AMOUNT MONEY,
	@ADDITIONALAMOUNT MONEY,
	@ADDITIONALUNIT DECIMAL(20,4),
	@OVER DECIMAL(20,4),
	@CAFEESETUPID CHAR(36)
)
AS

INSERT INTO [dbo].[CAFEEADJUSTABLECALC](
	[CAFEEADJUSTABLECALCID],
	[CAFEEID],
	[LOWERLIMIT],
	[UPPERLIMIT],
	[UNLIMITED],
	[AMOUNT],
	[ADDITIONALAMOUNT],
	[ADDITIONALUNIT],
	[OVER],
	[CAFEESETUPID]
)

VALUES
(
	@CAFEEADJUSTABLECALCID,
	@CAFEEID,
	@LOWERLIMIT,
	@UPPERLIMIT,
	@UNLIMITED,
	@AMOUNT,
	@ADDITIONALAMOUNT,
	@ADDITIONALUNIT,
	@OVER,
	@CAFEESETUPID
)