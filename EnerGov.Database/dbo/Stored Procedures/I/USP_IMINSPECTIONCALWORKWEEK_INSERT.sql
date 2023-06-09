﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTIONCALWORKWEEK_INSERT]
(
	@IMINSPECTIONCALWORKWEEKID CHAR(36),
	@IMINSPECTIONCALENDARID CHAR(36),
	@DAYOFWEEK INT,
	@STARTTIME DATETIME,
	@ENDTIME DATETIME,
	@ISWORKINGDAY BIT
)
AS

INSERT INTO [dbo].[IMINSPECTIONCALWORKWEEK](
	[IMINSPECTIONCALWORKWEEKID],
	[IMINSPECTIONCALENDARID],
	[DAYOFWEEK],
	[STARTTIME],
	[ENDTIME],
	[ISWORKINGDAY]
)

VALUES
(
	@IMINSPECTIONCALWORKWEEKID,
	@IMINSPECTIONCALENDARID,
	@DAYOFWEEK,
	@STARTTIME,
	@ENDTIME,
	@ISWORKINGDAY
)