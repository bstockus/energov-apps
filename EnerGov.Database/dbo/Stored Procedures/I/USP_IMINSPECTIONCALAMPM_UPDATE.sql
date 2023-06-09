﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTIONCALAMPM_UPDATE]
(
	@IMINSPECTIONCALAMPMID CHAR(36),
	@AMPMTIMEID INT,
	@STARTTIME DATETIME,
	@ENDTIME DATETIME,
	@IMINSPECTIONCALENDARID CHAR(36)
)
AS

UPDATE [dbo].[IMINSPECTIONCALAMPM] SET
	[AMPMTIMEID] = @AMPMTIMEID,
	[STARTTIME] = @STARTTIME,
	[ENDTIME] = @ENDTIME,
	[IMINSPECTIONCALENDARID] = @IMINSPECTIONCALENDARID

WHERE
	[IMINSPECTIONCALAMPMID] = @IMINSPECTIONCALAMPMID