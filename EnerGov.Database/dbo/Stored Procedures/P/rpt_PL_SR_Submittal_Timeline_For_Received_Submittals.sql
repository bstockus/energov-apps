﻿
CREATE PROCEDURE rpt_PL_SR_Submittal_Timeline_For_Received_Submittals
@PLPLANID AS VARCHAR(36)
AS

SELECT PL.PLPLANID,
	PL.PLANNUMBER,
	PLS.RECEIVEDDATE,
	PLS.COMPLETEDATE,
	PLS.DUEDATE,
	WFS.NAME ACTIONSTATUS,
	CASE WFS.NAME WHEN 'STOPPED' THEN dbo.ELAPSEDBDAYS(PLS.RECEIVEDDATE, GETDATE()) WHEN 'NOT STARTED' THEN '' ELSE dbo.ELAPSEDBDAYS(PLS.RECEIVEDDATE, PLS.COMPLETEDATE) END NUMBER_DAYS,
	PLWFS.PRIORITYORDER STEP_PRIORITY,
	PLWFAS.PRIORITYORDER ACTION_PRIORITY,
	PLWFAS.NAME ACTION_NAME,
	PLWFAS.VERSIONNUMBER,
	PLST.TYPENAME SUBMITTAL_TYPE,
	(SELECT CASE WHEN R.[IMAGE] IS NULL THEN ( SELECT TOP 1 IMAGEVALUE FROM SETTINGS WHERE NAME = 'LogoImage' ) ELSE R.IMAGE END FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Municipality_Logo') LOGO,
	(SELECT CASE WHEN R.[IMAGE] IS NULL AND ( SELECT TOP 1 IMAGEVALUE FROM SETTINGS WHERE NAME = 'LogoImage' ) IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R
		WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO,
	(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name,	   
	(SELECT R.REPORTTEXT FROM RPTTEXTLIB R
		WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
FROM PLPLAN PL
INNER JOIN PLPLANWFSTEP PLWFS ON PLWFS.PLPLANID = PL.PLPLANID
INNER JOIN PLPLANWFACTIONSTEP PLWFAS ON PLWFAS.PLPLANWFSTEPID = PLWFS.PLPLANWFSTEPID
INNER JOIN PLSUBMITTAL PLS ON PLS.PLPLANWFACTIONSTEPID = PLWFAS.PLPLANWFACTIONSTEPID
INNER JOIN PLSUBMITTALTYPE PLST ON PLST.PLSUBMITTALTYPEID = PLS.PLSUBMITTALTYPEID
INNER JOIN PLSUBMITTALSTATUS PLSS ON PLSS.PLSUBMITTALSTATUSID = PLS.PLSUBMITTALSTATUSID
INNER JOIN WORKFLOWSTATUS WFS ON WFS.WORKFLOWSTATUSID = PLWFAS.WORKFLOWSTATUSID
WHERE PL.PLPLANID = @PLPLANID

