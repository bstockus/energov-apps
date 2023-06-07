﻿CREATE PROCEDURE [dbo].[USP_BONDINTERESTRATE_UPDATE]
(
	@BONDINTERESTRATEID CHAR(36),
	@CAPAYMENTMETHODID CHAR(36),
	@BONDINTERESTSCHEDULEID CHAR(36),
	@STARTDATE DATETIME,
	@ENDDATE DATETIME,
	@INTERESTRATE DECIMAL(20,4),
	@ACTIVE BIT
)
AS

UPDATE [dbo].[BONDINTERESTRATE] SET
	[CAPAYMENTMETHODID] = @CAPAYMENTMETHODID,
	[BONDINTERESTSCHEDULEID] = @BONDINTERESTSCHEDULEID,
	[STARTDATE] = @STARTDATE,
	[ENDDATE] = @ENDDATE,
	[INTERESTRATE] = @INTERESTRATE,
	[ACTIVE] = @ACTIVE

WHERE
	[BONDINTERESTRATEID] = @BONDINTERESTRATEID