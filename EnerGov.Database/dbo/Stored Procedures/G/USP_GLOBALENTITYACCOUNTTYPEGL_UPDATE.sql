﻿CREATE PROCEDURE [dbo].[USP_GLOBALENTITYACCOUNTTYPEGL_UPDATE]
(
	@GLOBALENTITYACCOUNTTYPEGLID CHAR(36),
	@GLOBALENTITYACCOUNTTYPEID CHAR(36),
	@DEBITGLACCOUNTID CHAR(36),
	@CREDITGLACCOUNTID CHAR(36),
	@CAPAYMENTTYPEID INT,
	@CAPAYMENTMETHODID CHAR(36)
)
AS

UPDATE [dbo].[GLOBALENTITYACCOUNTTYPEGL] SET
	[GLOBALENTITYACCOUNTTYPEID] = @GLOBALENTITYACCOUNTTYPEID,
	[DEBITGLACCOUNTID] = @DEBITGLACCOUNTID,
	[CREDITGLACCOUNTID] = @CREDITGLACCOUNTID,
	[CAPAYMENTTYPEID] = @CAPAYMENTTYPEID,
	[CAPAYMENTMETHODID] = @CAPAYMENTMETHODID

WHERE
	[GLOBALENTITYACCOUNTTYPEGLID] = @GLOBALENTITYACCOUNTTYPEGLID