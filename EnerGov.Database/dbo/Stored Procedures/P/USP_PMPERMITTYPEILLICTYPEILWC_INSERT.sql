﻿CREATE PROCEDURE [dbo].[USP_PMPERMITTYPEILLICTYPEILWC_INSERT]
(
	@PMPERMITTYPEILLICENSETYPEID CHAR(36),
	@ILLICENSECLASSIFICATIONID CHAR(36)
)
AS

INSERT INTO [dbo].[PMPERMITTYPEILLICTYPEILWC](
	[PMPERMITTYPEILLICENSETYPEID],
	[ILLICENSECLASSIFICATIONID]
)

VALUES
(
	@PMPERMITTYPEILLICENSETYPEID,
	@ILLICENSECLASSIFICATIONID
)