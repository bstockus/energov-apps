﻿CREATE PROCEDURE [managebusiness].[USP_BLGLOBALENTITYEXTENSIONVIOLATIONS_GETBYGLOBALENTIITYID]
(
@BLGLOBALENTITYEXTENSIONID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;

SELECT 
	7 AS MODULEID,
	'Code Case' AS MODULENAME,
	BLGLOBALENTITYEXTENSIONCODECASEXREF.BLGLOBALENTITYEXTENSIONID,
	CMCODE.CODENUMBER,
	CMCODECATEGORY.NAME CODECATEGORY,
	VIOLATIONPRIORITYSYSTEMTYPE.NAME PRIORITY,
	CMVIOLATION.CMVIOLATIONID,
	CMVIOLATION.CITATIONISSUEDATE,
	CMCODECASE.CMCODECASEID,
	CMCODECASE.CASENUMBER CODECASENUMBER,
	CMCODECASE.DESCRIPTION CODECASEDESCRIPTION,
	CMCASETYPE.NAME CASETYPE
FROM BLGLOBALENTITYEXTENSIONCODECASEXREF
	INNER JOIN CMCODECASE ON CMCODECASE.CMCODECASEID = BLGLOBALENTITYEXTENSIONCODECASEXREF.CMCODECASEID
	INNER JOIN CMCODEWFSTEP ON CMCODEWFSTEP.CMCODECASEID = CMCODECASE.CMCODECASEID
	INNER JOIN CMCODEWFACTIONSTEP ON CMCODEWFACTIONSTEP.CMCODEWFSTEPID = CMCODEWFSTEP.CMCODEWFSTEPID
	INNER JOIN CMCASETYPE ON CMCASETYPE.CMCASETYPEID = CMCODECASE.CMCASETYPEID
	INNER JOIN CMVIOLATION ON CMVIOLATION.CMCODEWFACTIONID = CMCODEWFACTIONSTEP.CMCODEWFACTIONSTEPID
	INNER JOIN CMVIOLATIONSTATUS ON CMVIOLATION.CMVIOLATIONSTATUSID = CMVIOLATIONSTATUS.CMVIOLATIONSTATUSID
	INNER JOIN CMCODEVIOLATIONPRIORITY ON CMCODEVIOLATIONPRIORITY.CMCODEVIOLATIONPRIORITYID = CMVIOLATION.CMCODEVIOLATIONPRIORITYID
	INNER JOIN VIOLATIONPRIORITYSYSTEMTYPE ON VIOLATIONPRIORITYSYSTEMTYPE.VIOLATIONPRIORITYSYSTEMTYPEID = CMCODEVIOLATIONPRIORITY.VIOLATIONPRIORITYSYSTEMTYPEID
	INNER JOIN CMCODE ON CMCODE.CMCODEID = CMVIOLATION.CMCODEID
	INNER JOIN CMCODECATEGORY ON CMCODECATEGORY.CMCODECATEGORYID = CMCODE.CMCODECATEGORYID
WHERE 
	CMVIOLATIONSTATUS.SUCCESSFLAG = 0 AND
	BLGLOBALENTITYEXTENSIONCODECASEXREF.BLGLOBALENTITYEXTENSIONID =  @BLGLOBALENTITYEXTENSIONID
ORDER BY CITATIONISSUEDATE DESC

END