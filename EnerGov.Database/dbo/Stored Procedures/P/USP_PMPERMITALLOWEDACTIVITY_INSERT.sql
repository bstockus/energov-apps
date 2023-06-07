﻿CREATE PROCEDURE [dbo].[USP_PMPERMITALLOWEDACTIVITY_INSERT]
(
	@PMPERMITALLOWEDACTIVITYID CHAR(36),
	@PMPERMITTYPEID CHAR(36),
	@PMPERMITACTIVITYTYPEID CHAR(36)
)
AS

INSERT INTO [dbo].[PMPERMITALLOWEDACTIVITY](
	[PMPERMITALLOWEDACTIVITYID],
	[PMPERMITTYPEID],
	[PMPERMITACTIVITYTYPEID]
)

VALUES
(
	@PMPERMITALLOWEDACTIVITYID,
	@PMPERMITTYPEID,
	@PMPERMITACTIVITYTYPEID
)