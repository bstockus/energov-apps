﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTIONCALAMPM_INSERT]
(
	@IMINSPECTIONCALAMPMID CHAR(36),
	@AMPMTIMEID INT,
	@STARTTIME DATETIME,
	@ENDTIME DATETIME,
	@IMINSPECTIONCALENDARID CHAR(36)
)
AS

INSERT INTO [dbo].[IMINSPECTIONCALAMPM](
	[IMINSPECTIONCALAMPMID],
	[AMPMTIMEID],
	[STARTTIME],
	[ENDTIME],
	[IMINSPECTIONCALENDARID]
)

VALUES
(
	@IMINSPECTIONCALAMPMID,
	@AMPMTIMEID,
	@STARTTIME,
	@ENDTIME,
	@IMINSPECTIONCALENDARID
)