﻿CREATE PROCEDURE [dbo].[USP_BONDGLACCOUNTXREF_INSERT]
(
	@BONDGLACCOUNTXREFID CHAR(36),
	@BONDINTERESTSCHEDULEID CHAR(36),
	@DEBITGLACCOUNTID CHAR(36),
	@CREDITGLACCOUNTID CHAR(36),
	@CAPAYMENTMETHODID CHAR(36),
	@PERCENTAGE DECIMAL(20,4)
)
AS

INSERT INTO [dbo].[BONDGLACCOUNTXREF](
	[BONDGLACCOUNTXREFID],
	[BONDINTERESTSCHEDULEID],
	[DEBITGLACCOUNTID],
	[CREDITGLACCOUNTID],
	[CAPAYMENTMETHODID],
	[PERCENTAGE]
)

VALUES
(
	@BONDGLACCOUNTXREFID,
	@BONDINTERESTSCHEDULEID,
	@DEBITGLACCOUNTID,
	@CREDITGLACCOUNTID,
	@CAPAYMENTMETHODID,
	@PERCENTAGE
)