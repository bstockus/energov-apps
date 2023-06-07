﻿CREATE PROCEDURE [inspectiondashboard].[USP_IMINSPECTION_UPDATE_PARTIAL]
	@INSPECTIONID CHAR(36),
    @ROWVERSION INT,
    @SCHEDULEDSTARTDATE DATETIME,
    @SCHEDULEDENDDATE DATETIME,
    @SCHEDULEDAMORPM INT,
    @LASTCHANGEDON DATETIME,
    @LASTCHANGEDBY CHAR(36),
    @INSPECTIONSTATUSID CHAR(36),
    @ISDATECHANGED BIT,
    @ISSTATUSCHANGED BIT
AS
UPDATE [dbo].[IMINSPECTION]
SET 
	[ROWVERSION] = @ROWVERSION,
	[IMINSPECTIONSTATUSID] = CASE @ISSTATUSCHANGED WHEN 1 THEN @INSPECTIONSTATUSID ELSE [IMINSPECTIONSTATUSID] END,
	[SCHEDULEDSTARTDATE] = CASE @ISDATECHANGED WHEN 1 THEN @SCHEDULEDSTARTDATE ELSE [SCHEDULEDSTARTDATE] END,
	[SCHEDULEDENDDATE] = CASE @ISDATECHANGED WHEN 1 THEN @SCHEDULEDENDDATE ELSE [SCHEDULEDENDDATE] END,
	[SCHEDULEDAMORPM] = CASE @ISDATECHANGED WHEN 1 THEN @SCHEDULEDAMORPM ELSE [SCHEDULEDAMORPM] END,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[LASTCHANGEDBY] = @LASTCHANGEDBY
WHERE 
	[dbo].[IMINSPECTION].[IMINSPECTIONID] = @INSPECTIONID AND 
	[dbo].[IMINSPECTION].[ROWVERSION] = (@ROWVERSION -1)