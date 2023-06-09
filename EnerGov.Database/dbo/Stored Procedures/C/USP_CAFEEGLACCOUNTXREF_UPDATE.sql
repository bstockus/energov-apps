﻿CREATE PROCEDURE [dbo].[USP_CAFEEGLACCOUNTXREF_UPDATE]
(
	@CAFEEGLACCOUNTXREFID CHAR(36),
	@CAFEEID CHAR(36),
	@DEBITGLACCOUNTID CHAR(36),
	@CREDITGLACCOUNTID CHAR(36),
	@CAPAYMENTTYPEID INT,
	@CAPAYMENTMETHODID CHAR(36),
	@PERCENTAGE DECIMAL(20,4)
)
AS

UPDATE [dbo].[CAFEEGLACCOUNTXREF] SET
	[CAFEEID] = @CAFEEID,
	[DEBITGLACCOUNTID] = @DEBITGLACCOUNTID,
	[CREDITGLACCOUNTID] = @CREDITGLACCOUNTID,
	[CAPAYMENTTYPEID] = @CAPAYMENTTYPEID,
	[CAPAYMENTMETHODID] = @CAPAYMENTMETHODID,
	[PERCENTAGE] = @PERCENTAGE

WHERE
	[CAFEEGLACCOUNTXREFID] = @CAFEEGLACCOUNTXREFID