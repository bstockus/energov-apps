﻿CREATE PROCEDURE [dbo].[USP_CADISCOUNTADJUSTABLECALC_UPDATE]
(
	@CADISCOUNTADJUSTABLECALCID CHAR(36),
	@CADISCOUNTID CHAR(36),
	@CADISCOUNTSETUPID CHAR(36),
	@LOWERLIMIT DECIMAL(20,4),
	@UPPERLIMIT DECIMAL(20,4),
	@UNLIMITED BIT,
	@AMOUNT MONEY,
	@ADDITIONALAMOUNT MONEY,
	@ADDITIONALUNIT DECIMAL(20,4),
	@OVER DECIMAL(20,4)
)
AS

UPDATE [dbo].[CADISCOUNTADJUSTABLECALC] SET
	[CADISCOUNTID] = @CADISCOUNTID,
	[CADISCOUNTSETUPID] = @CADISCOUNTSETUPID,
	[LOWERLIMIT] = @LOWERLIMIT,
	[UPPERLIMIT] = @UPPERLIMIT,
	[UNLIMITED] = @UNLIMITED,
	[AMOUNT] = @AMOUNT,
	[ADDITIONALAMOUNT] = @ADDITIONALAMOUNT,
	[ADDITIONALUNIT] = @ADDITIONALUNIT,
	[OVER] = @OVER

WHERE
	[CADISCOUNTADJUSTABLECALCID] = @CADISCOUNTADJUSTABLECALCID