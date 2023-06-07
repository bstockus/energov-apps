﻿
-- =============================================
-- Author:		Khang Tran
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CSS_CALENDAR_EVENT]
(
	@HEARINGOPTION BIT = 0,
	@MEETINGOPTION BIT = 0,
	@HOLIDAYOPTION BIT = 0,
	@PLANOPTION BIT = 0,
	@PERMITOPTION BIT = 0,
	@INSPECTIONOPTION BIT = 0,
	@INVOICEOPTION BIT = 0,
	@BUSINESSLICENSEOPTION BIT = 0,
	@PROFLICENSEOPTION BIT=0,
	@START_DATE DATETIME,
	@END_DATE DATETIME,
	@GLOBAL_ENTITY_ID CHAR(36) = NULL,
	@HIDELICENSE BIT=0
)
AS
BEGIN		
	SELECT	CALENDAROPTION,
	EVENTID,
	EVENTNAME,
	SUBJECT,
	STATUS,
	COMMENTS,
	STARTDATE,
	ENDDATE,
	EXPIRATIONDATE,
	APPROVALEXPIRATIONDATE,
	LOCATION,
	GLOBALENTITYID,
	AVAILINCAP,
	AVAILINCAPCONTACTS,		
	CASERECORDID,
	CASENUMBER,
	CASETYPEID,
	CASETYPE,
	CASEMODULE,
	CASEWORKCLASSID,
	CASEWORKCLASS,
	ASSIGNEDUSER,
	CASEDESCRIPTION,
	INVOICEDATE,
	TOTAL,
	PROJECTNAME,
	APPLYDATE,
	ISSUEDATE,
	FINALIZEDATE,
	COMPLETEDATE,
	ADDRESS,
	DBA,
	COMPANY
	FROM 
	(SELECT 1 AS CALENDAROPTION,
	HEARING.HEARINGID AS EVENTID,
    HEARINGTYPE.NAME AS EVENTNAME,
	HEARING.SUBJECT AS SUBJECT,
    HEARINGSTATUS.NAME AS STATUS,
	HEARING.COMMENTS AS COMMENTS,
	HEARING.STARTDATE AS STARTDATE,
	HEARING.ENDDATE AS ENDDATE,
	NULL AS EXPIRATIONDATE,
	NULL AS APPROVALEXPIRATIONDATE,
	HEARING.LOCATION AS LOCATION,
	HEARINGATTENDEE.ATTENDEEID AS GLOBALENTITYID,
	HEARINGTYPE.AVAILINCAP AS AVAILINCAP,
	HEARINGTYPE.AVAILINCAPCONTACTS AS AVAILINCAPCONTACTS,
	COALESCE(
		(SELECT TOP 1 PLPLAN.PLPLANID AS "CASERECORDID" 
			FROM PLPLAN
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			(SELECT TOP 1 PMPERMIT.PMPERMITID AS "CASERECORDID" 
			FROM PMPERMIT
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			(SELECT TOP 1 PA.PLAPPLICATIONID AS "CASERECORDID" 
			FROM PLAPPLICATION PA
			WHERE PA.PLAPPLICATIONID = HEARINGXREF.OBJECTID),
			''
	) AS CASERECORDID,
	COALESCE(
		(SELECT TOP 1 PLPLAN.PLANNUMBER AS "CASENUMBER" 
			FROM PLPLAN
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			(SELECT TOP 1 PMPERMIT.PERMITNUMBER AS "CASENUMBER" 
			FROM PMPERMIT
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			(SELECT TOP 1 PLAPPLICATION.APPNUMBER AS "CASENUMBER" 
			FROM PLAPPLICATION
			WHERE PLAPPLICATION.PLAPPLICATIONID = HEARINGXREF.OBJECTID),
			''
	) AS CASENUMBER,
	COALESCE(
		(SELECT TOP 1 PLPLAN.PLPLANTYPEID AS "CASETYPEID" 
			FROM PLPLAN
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			(SELECT TOP 1 PMPERMIT.PMPERMITTYPEID AS "CASETYPEID" 
			FROM PMPERMIT
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			(SELECT  PA.PLAPPLICATIONTYPEID AS "CASETYPEID"
			FROM PLAPPLICATION PA
			WHERE PA.PLAPPLICATIONID = HEARINGXREF.OBJECTID),
			''
	) AS CASETYPEID,
	COALESCE(
		(SELECT TOP 1 PLPLANTYPE.PLANNAME AS "CASETYPE" 
			FROM PLPLAN
			INNER JOIN PLPLANTYPE ON PLPLANTYPE.PLPLANTYPEID = PLPLAN.PLPLANTYPEID
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			(SELECT TOP 1 PMPERMITTYPE.NAME AS "CASETYPE"
			FROM PMPERMIT
			INNER JOIN PMPERMITTYPE ON PMPERMITTYPE.PMPERMITTYPEID = PMPERMIT.PMPERMITTYPEID
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			(SELECT PT.APPLICATIONTYPENAME AS "CASETYPE" 
			FROM PLAPPLICATION PA
			INNER JOIN PLAPPLICATIONTYPE PT ON PT.PLAPPLICATIONTYPEID = PA.PLAPPLICATIONTYPEID			
			WHERE PA.PLAPPLICATIONID = HEARINGXREF.OBJECTID),
			''
	) AS CASETYPE,
	COALESCE(
		(SELECT TOP 1 2 AS "CASEMODULE" 
			FROM PLPLAN
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			(SELECT TOP 1 1 AS "CASEMODULE" 
			FROM PMPERMIT
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			(SELECT TOP 1 4 AS "CASEMODULE" 
			FROM PLAPPLICATION PA
			WHERE PA.PLAPPLICATIONID = HEARINGXREF.OBJECTID),
			0
	) AS CASEMODULE,
	COALESCE(
		(SELECT TOP 1 PLPLAN.PLPLANWORKCLASSID AS "CASEWORKCLASSID" 
			FROM PLPLAN
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			(SELECT TOP 1 PMPERMIT.PMPERMITWORKCLASSID AS "CASEWORKCLASSID" 
			FROM PMPERMIT
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			''
	) AS CASEWORKCLASSID,
	COALESCE(
		(SELECT TOP 1 PLPLANWORKCLASS.NAME AS "CASEWORKCLASS" 
			FROM PLPLAN
			INNER JOIN PLPLANWORKCLASS ON PLPLANWORKCLASS.PLPLANWORKCLASSID = PLPLAN.PLPLANWORKCLASSID
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			(SELECT TOP 1 PMPERMITWORKCLASS.NAME AS "CASEWORKCLASS"
			FROM PMPERMIT
			INNER JOIN PMPERMITWORKCLASS ON PMPERMITWORKCLASS.PMPERMITWORKCLASSID = PMPERMIT.PMPERMITWORKCLASSID
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			''
	) AS CASEWORKCLASS,
	COALESCE(
		(SELECT TOP 1 (USERS.FNAME + ' ' + USERS.LNAME) AS "ASSIGNEDUSER" 
			FROM PLPLAN
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			LEFT OUTER JOIN USERS ON USERS.SUSERGUID = PLPLAN.ASSIGNEDTO
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			(SELECT TOP 1 (USERS.FNAME + ' ' + USERS.LNAME) AS "ASSIGNEDUSER"  
			FROM PMPERMIT
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			LEFT OUTER JOIN USERS ON USERS.SUSERGUID = PMPERMIT.ASSIGNEDTO
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = HEARINGXREF.OBJECTID),
			(SELECT TOP 1 (USERS.FNAME + ' ' + USERS.LNAME) AS "ASSIGNEDUSER" 
			FROM PLAPPLICATION
			LEFT OUTER JOIN USERS ON USERS.SUSERGUID = PLAPPLICATION.ASSIGNEDTO
			WHERE PLAPPLICATION.PLAPPLICATIONID = HEARINGXREF.OBJECTID),
			''
	) AS ASSIGNEDUSER,
	NULL AS CASEDESCRIPTION,
	NULL AS INVOICEDATE,
	0 AS TOTAL,
	'' AS PROJECTNAME,
	NULL AS APPLYDATE,
	NULL AS ISSUEDATE,
	NULL AS FINALIZEDATE,
	NULL AS COMPLETEDATE,
	'' AS ADDRESS,	
	'' AS DBA,
	'' AS COMPANY													
    FROM HEARING
	INNER JOIN HEARINGSTATUS ON HEARINGSTATUS.HEARINGSTATUSID = HEARING.HEARINGSTATUSID
	INNER JOIN HEARINGTYPE ON HEARINGTYPE.HEARINGTYPEID = HEARING.HEARINGTYPEID
	LEFT OUTER JOIN HEARINGATTENDEE ON HEARING.HEARINGID = HEARINGATTENDEE.HEARINGID AND HEARINGATTENDEE.ISUSER = 0 AND HEARINGATTENDEE.ISGLOBALENTITY = 1
	LEFT OUTER JOIN HEARINGXREF ON HEARINGXREF.HEARINGID = HEARING.HEARINGID		
	WHERE   @HEARINGOPTION = 1 AND (((@GLOBAL_ENTITY_ID IS NULL OR @GLOBAL_ENTITY_ID = '') AND HEARINGTYPE.AVAILINCAP = 1) OR 
		    (@GLOBAL_ENTITY_ID IS NOT NULL AND @GLOBAL_ENTITY_ID <> '' AND HEARINGTYPE.AVAILINCAP = 1) OR
			(@GLOBAL_ENTITY_ID IS NOT NULL AND @GLOBAL_ENTITY_ID <> '' AND HEARINGTYPE.AVAILINCAPCONTACTS = 1 AND HEARINGATTENDEE.ATTENDEEID = @GLOBAL_ENTITY_ID)) AND
			((HEARING.STARTDATE >= @START_DATE AND HEARING.ENDDATE < @END_DATE))				 
	
	UNION
	SELECT 2 AS CALENDAROPTION,
	MEETING.MEETINGID AS EVENTID,
    MEETINGTYPE.NAME AS EVENTNAME,
	MEETING.SUBJECT AS SUBJECT,
    '' AS STATUS,
	MEETING.COMMENTS AS COMMENTS,
	MEETING.STARTDATE AS STARTDATE,
	MEETING.ENDDATE AS ENDDATE,
	NULL AS EXPIRATIONDATE,
    NULL AS APPROVALEXPIRATIONDATE,
	MEETING.LOCATION AS LOCATION,
	MEETINGATTENDEE.ATTENDEEID AS GLOBALENTITYID,
	1 AS AVAILINCAP,
	1 AS AVAILINCAPCONTACTS,
	COALESCE(
		(SELECT TOP 1 PLPLAN.PLPLANID AS "CASERECORDID" 
			FROM PLPLAN
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			(SELECT TOP 1 PMPERMIT.PMPERMITID AS "CASERECORDID" 
			FROM PMPERMIT
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			(SELECT TOP 1 PA.PLAPPLICATIONID AS "CASERECORDID" 
			FROM PLAPPLICATION PA
			WHERE PA.PLAPPLICATIONID = MEETINGXREF.OBJECTID),
			''
	) AS CASERECORDID,
	COALESCE(
		(SELECT TOP 1 PLPLAN.PLANNUMBER AS "CASENUMBER" 
			FROM PLPLAN
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			(SELECT TOP 1 PMPERMIT.PERMITNUMBER AS "CASENUMBER" 
			FROM PMPERMIT
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			(SELECT TOP 1 PLAPPLICATION.APPNUMBER AS "CASENUMBER" 
			FROM PLAPPLICATION
			WHERE PLAPPLICATION.PLAPPLICATIONID = MEETINGXREF.OBJECTID),
			''
	) AS CASENUMBER,
	COALESCE(
		(SELECT TOP 1 PLPLAN.PLPLANTYPEID AS "CASETYPEID" 
			FROM PLPLAN
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			(SELECT TOP 1 PMPERMIT.PMPERMITTYPEID AS "CASETYPEID" 
			FROM PMPERMIT
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			(SELECT  PA.PLAPPLICATIONTYPEID AS "CASETYPEID"
			FROM PLAPPLICATION PA
			WHERE PA.PLAPPLICATIONID = MEETINGXREF.OBJECTID),
			''
	) AS CASETYPEID,
	COALESCE(
		(SELECT TOP 1 PLPLANTYPE.PLANNAME AS "CASETYPE" 
			FROM PLPLAN
			INNER JOIN PLPLANTYPE ON PLPLANTYPE.PLPLANTYPEID = PLPLAN.PLPLANTYPEID
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			(SELECT TOP 1 PMPERMITTYPE.NAME AS "CASETYPE"
			FROM PMPERMIT
			INNER JOIN PMPERMITTYPE ON PMPERMITTYPE.PMPERMITTYPEID = PMPERMIT.PMPERMITTYPEID
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			(SELECT PT.APPLICATIONTYPENAME AS "CASETYPE" 
			FROM PLAPPLICATION PA
			INNER JOIN PLAPPLICATIONTYPE PT ON PT.PLAPPLICATIONTYPEID = PA.PLAPPLICATIONTYPEID			
			WHERE PA.PLAPPLICATIONID = MEETINGXREF.OBJECTID),
			''
	) AS CASETYPE,
	COALESCE(
		(SELECT TOP 1 2 AS "CASEMODULE" 
			FROM PLPLAN
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			(SELECT TOP 1 1 AS "CASEMODULE" 
			FROM PMPERMIT
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			(SELECT TOP 1 4 AS "CASEMODULE" 
			FROM PLAPPLICATION PA
			WHERE PA.PLAPPLICATIONID = MEETINGXREF.OBJECTID),
			0
	) AS CASEMODULE,
	COALESCE(
		(SELECT TOP 1 PLPLAN.PLPLANWORKCLASSID AS "CASEWORKCLASSID" 
			FROM PLPLAN
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			(SELECT TOP 1 PMPERMIT.PMPERMITWORKCLASSID AS "CASEWORKCLASSID" 
			FROM PMPERMIT
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			''
	) AS CASEWORKCLASSID,
	COALESCE(
		(SELECT TOP 1 PLPLANWORKCLASS.NAME AS "CASEWORKCLASS" 
			FROM PLPLAN
			INNER JOIN PLPLANWORKCLASS ON PLPLANWORKCLASS.PLPLANWORKCLASSID = PLPLAN.PLPLANWORKCLASSID
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			(SELECT TOP 1 PMPERMITWORKCLASS.NAME AS "CASEWORKCLASS"
			FROM PMPERMIT
			INNER JOIN PMPERMITWORKCLASS ON PMPERMITWORKCLASS.PMPERMITWORKCLASSID = PMPERMIT.PMPERMITWORKCLASSID
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			''
	) AS CASEWORKCLASS,
	COALESCE(
		(SELECT TOP 1 (USERS.FNAME + ' ' + USERS.LNAME) AS "ASSIGNEDUSER" 
			FROM PLPLAN
			INNER JOIN PLPLANWFSTEP ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID
			INNER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFSTEPID = PLPLANWFSTEP.PLPLANWFSTEPID
			LEFT OUTER JOIN USERS ON USERS.SUSERGUID = PLPLAN.ASSIGNEDTO
			WHERE PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			(SELECT TOP 1 (USERS.FNAME + ' ' + USERS.LNAME) AS "ASSIGNEDUSER"  
			FROM PMPERMIT
			INNER JOIN PMPERMITWFSTEP ON PMPERMITWFSTEP.PMPERMITID = PMPERMIT.PMPERMITID
			INNER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID
			LEFT OUTER JOIN USERS ON USERS.SUSERGUID = PMPERMIT.ASSIGNEDTO
			WHERE PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = MEETINGXREF.OBJECTID),
			(SELECT TOP 1 (USERS.FNAME + ' ' + USERS.LNAME) AS "ASSIGNEDUSER" 
			FROM PLAPPLICATION
			LEFT OUTER JOIN USERS ON USERS.SUSERGUID = PLAPPLICATION.ASSIGNEDTO
			WHERE PLAPPLICATION.PLAPPLICATIONID = MEETINGXREF.OBJECTID),
			''
	) AS ASSIGNEDUSER,
	NULL AS CASEDESCRIPTION,
	NULL AS INVOICEDATE,
	0 AS TOTAL,
	'' AS PROJECTNAME,
	NULL AS APPLYDATE,
	NULL AS ISSUEDATE,
	NULL AS FINALIZEDATE,
	NULL AS COMPLETEDATE,
	'' AS ADDRESS,
	'' AS DBA,
	'' AS COMPANY													
    FROM MEETING		
	INNER JOIN MEETINGTYPE ON MEETINGTYPE.MEETINGTYPEID = MEETING.MEETINGTYPEID
	LEFT OUTER JOIN MEETINGATTENDEE ON MEETING.MEETINGID = MEETINGATTENDEE.HEARINGID AND MEETINGATTENDEE.ISUSER = 0 AND MEETINGATTENDEE.ISGLOBALENTITY = 1
	LEFT OUTER JOIN MEETINGXREF ON MEETINGXREF.MEETINGID = MEETING.MEETINGID
	WHERE   @MEETINGOPTION = 1 AND (((@GLOBAL_ENTITY_ID IS NULL OR @GLOBAL_ENTITY_ID = '') AND MEETINGTYPE.AVAILINCAP = 1) OR 
		    (@GLOBAL_ENTITY_ID IS NOT NULL AND @GLOBAL_ENTITY_ID <> '' AND MEETINGTYPE.AVAILINCAP = 1) OR
			(@GLOBAL_ENTITY_ID IS NOT NULL AND @GLOBAL_ENTITY_ID <> '' AND MEETINGTYPE.AVAILINCAPCONTACTS = 1 AND MEETINGATTENDEE.ATTENDEEID = @GLOBAL_ENTITY_ID)) AND
			((MEETING.STARTDATE >= @START_DATE AND MEETING.ENDDATE < @END_DATE))			
	
	UNION
	SELECT 3 AS CALENDAROPTION,
	'' AS EVENTID,
    HOLIDAY.NAME AS EVENTNAME,
	'' AS SUBJECT,
    '' AS STATUS,
	'' AS COMMENTS,
	HOLIDAY.HOLIDAYDATE AS STARTDATE,
	HOLIDAY.HOLIDAYDATE AS ENDDATE,
	NULL AS EXPIRATIONDATE,
	NULL AS APPROVALEXPIRATIONDATE,
	'' AS LOCATION,
	'' AS GLOBALENTITYID,
	1 AS AVAILINCAP,
	1 AS AVAILINCAPCONTACTS,
	'' AS CASERECORDID,
	'' CASENUMBER,
	'' AS CASETYPEID,
	'' AS CASETYPE,
	0 AS CASEMODULE,
	'' AS CASEWORKCLASSID,
	'' AS CASEWORKCLASS,
	'' AS ASSIGNEDUSER,
	NULL AS CASEDESCRIPTION,
	NULL AS INVOICEDATE,
	0 AS TOTAL,
	'' AS PROJECTNAME,
	NULL AS APPLYDATE,
	NULL AS ISSUEDATE,
	NULL AS FINALIZEDATE,
	NULL AS COMPLETEDATE,
	'' AS ADDRESS,
	'' AS DBA,
	'' AS COMPANY													
    FROM HOLIDAY
	WHERE   @HOLIDAYOPTION = 1 AND HOLIDAY.HOLIDAYDATE >= @START_DATE AND HOLIDAY.HOLIDAYDATE < @END_DATE
	
	UNION
	SELECT 	4 AS CALENDAROPTION,
	'' AS EVENTID,
    PLPLAN.PLANNUMBER AS EVENTNAME,
	'' AS SUBJECT,
    PLPLANSTATUS.NAME AS STATUS,
	'' AS COMMENTS,
	PLPLAN.EXPIREDATE  AS STARTDATE,
	DATEADD(MINUTE,30,PLPLAN.EXPIREDATE) AS ENDDATE,
	PLPLAN.EXPIREDATE AS EXPIRATIONDATE,	
	PLPLAN.APPROVALEXPIREDATE  AS APPROVALEXPIRATIONDATE,
	'' AS LOCATION,
	PLPLAN.ASSIGNEDTO AS GLOBALENTITYID,
	1 AS AVAILINCAP,
	1 AS AVAILINCAPCONTACTS,
	PLPLAN.PLPLANID AS CASERECORDID,
	PLPLAN.PLANNUMBER AS CASENUMBER,
	PLPLAN.PLPLANTYPEID AS CASETYPEID,
	PLPLANTYPE.PLANNAME AS CASETYPE,
	0 AS CASEMODULE,
	PLPLANWORKCLASS.PLPLANWORKCLASSID AS CASEWORKCLASSID,
	PLPLANWORKCLASS.NAME AS CASEWORKCLASS,
	'' AS ASSIGNEDUSER,
	PLPLAN.DESCRIPTION AS CASEDESCRIPTION,
	NULL AS INVOICEDATE,
	0 AS TOTAL,
	PRPROJECT.NAME AS PROJECTNAME,
	PLPLAN.APPLICATIONDATE AS APPLYDATE,
	NULL AS ISSUEDATE,
	NULL AS FINALIZEDATE,
	PLPLAN.COMPLETEDATE AS COMPLETEDATE,
	ISNULL(MAILINGADDRESS.ADDRESSLINE1, '') + ' ' + 
		ISNULL(MAILINGADDRESS.ADDRESSLINE2, '') + ' ' + 
		ISNULL(MAILINGADDRESS.STREETTYPE, '') + ' ' + 
		ISNULL(MAILINGADDRESS.CITY, '') + ' ' + 
		ISNULL(MAILINGADDRESS.STATE, '') + ' ' + 
		ISNULL(MAILINGADDRESS.POSTALCODE, '') AS ADDRESS,
	'' AS DBA,
	'' AS COMPANY						
    FROM PLPLAN
	INNER JOIN PLPLANTYPE ON PLPLANTYPE.PLPLANTYPEID = PLPLAN.PLPLANTYPEID
	INNER JOIN PLPLANSTATUS ON PLPLANSTATUS.PLPLANSTATUSID = PLPLAN.PLPLANSTATUSID
	INNER JOIN PLPLANWORKCLASS ON PLPLANWORKCLASS.PLPLANWORKCLASSID = PLPLAN.PLPLANWORKCLASSID
	LEFT OUTER JOIN PRPROJECTPLAN ON PRPROJECTPLAN.PLPLANID = PLPLAN.PLPLANID 
	LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTPLAN.PRPROJECTID
	LEFT OUTER JOIN PLPLANADDRESS ON PLPLAN.PLPLANID = PLPLANADDRESS.PLPLANID AND PLPLANADDRESS.MAIN = 1
	LEFT OUTER JOIN MAILINGADDRESS ON PLPLANADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
	WHERE @PLANOPTION =1 AND ISNULL(@GLOBAL_ENTITY_ID,'')!='' AND  EXISTS(SELECT * FROM PLPLANCONTACT WHERE PLPLANCONTACT.GLOBALENTITYID = @GLOBAL_ENTITY_ID AND PLPLANCONTACT.PLPLANID = PLPLAN.PLPLANID)
	AND PLPLAN.EXPIREDATE  >= @START_DATE AND PLPLAN.EXPIREDATE < @END_DATE
	
	UNION
	--Getting records with Approval Expiry date as expiry date
	SELECT 	4 AS CALENDAROPTION,
	'' AS EVENTID,
    PLPLAN.PLANNUMBER AS EVENTNAME,
	'' AS SUBJECT,
    PLPLANSTATUS.NAME AS STATUS,
	'' AS COMMENTS,
	PLPLAN.APPROVALEXPIREDATE  AS STARTDATE,
	DATEADD(MINUTE,30,PLPLAN.APPROVALEXPIREDATE) AS ENDDATE,
	PLPLAN.EXPIREDATE  AS EXPIRATIONDATE,    	
	PLPLAN.APPROVALEXPIREDATE AS APPROVALEXPIRATIONDATE,
	'' AS LOCATION,
	PLPLAN.ASSIGNEDTO AS GLOBALENTITYID,
	1 AS AVAILINCAP,
	1 AS AVAILINCAPCONTACTS,
	PLPLAN.PLPLANID AS CASERECORDID,
	PLPLAN.PLANNUMBER AS CASENUMBER,
	PLPLAN.PLPLANTYPEID AS CASETYPEID,
	PLPLANTYPE.PLANNAME AS CASETYPE,
	0 AS CASEMODULE,
	PLPLANWORKCLASS.PLPLANWORKCLASSID AS CASEWORKCLASSID,
	PLPLANWORKCLASS.NAME AS CASEWORKCLASS,
	'' AS ASSIGNEDUSER,
	PLPLAN.DESCRIPTION AS CASEDESCRIPTION,
	NULL AS INVOICEDATE,
	0 AS TOTAL,
	PRPROJECT.NAME AS PROJECTNAME,
	PLPLAN.APPLICATIONDATE AS APPLYDATE,
	NULL AS ISSUEDATE,
	NULL AS FINALIZEDATE,
	PLPLAN.COMPLETEDATE AS COMPLETEDATE,
	ISNULL(MAILINGADDRESS.ADDRESSLINE1, '') + ' ' + 
		ISNULL(MAILINGADDRESS.ADDRESSLINE2, '') + ' ' + 
		ISNULL(MAILINGADDRESS.STREETTYPE, '') + ' ' + 
		ISNULL(MAILINGADDRESS.CITY, '') + ' ' + 
		ISNULL(MAILINGADDRESS.STATE, '') + ' ' + 
		ISNULL(MAILINGADDRESS.POSTALCODE, '') AS ADDRESS,
	'' AS DBA,
	'' AS COMPANY							
    FROM PLPLAN
	INNER JOIN PLPLANTYPE ON PLPLANTYPE.PLPLANTYPEID = PLPLAN.PLPLANTYPEID
	INNER JOIN PLPLANSTATUS ON PLPLANSTATUS.PLPLANSTATUSID = PLPLAN.PLPLANSTATUSID
	INNER JOIN PLPLANWORKCLASS ON PLPLANWORKCLASS.PLPLANWORKCLASSID = PLPLAN.PLPLANWORKCLASSID
	LEFT OUTER JOIN PRPROJECTPLAN ON PRPROJECTPLAN.PLPLANID = PLPLAN.PLPLANID 
	LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTPLAN.PRPROJECTID
	LEFT OUTER JOIN PLPLANADDRESS ON PLPLAN.PLPLANID = PLPLANADDRESS.PLPLANID AND PLPLANADDRESS.MAIN = 1
	LEFT OUTER JOIN MAILINGADDRESS ON PLPLANADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
	WHERE @PLANOPTION =1 AND ISNULL(@GLOBAL_ENTITY_ID,'')!='' AND EXISTS(SELECT * FROM PLPLANCONTACT WHERE PLPLANCONTACT.GLOBALENTITYID = @GLOBAL_ENTITY_ID AND PLPLANCONTACT.PLPLANID = PLPLAN.PLPLANID)
	AND PLPLAN.APPROVALEXPIREDATE  >= @START_DATE AND PLPLAN.APPROVALEXPIREDATE < @END_DATE
	
	UNION
	SELECT 	5 AS CALENDAROPTION,
	'' AS EVENTID,
    PMPERMIT.PERMITNUMBER AS EVENTNAME,
	'' AS SUBJECT,
    PMPERMITSTATUS.NAME AS STATUS,
	'' AS COMMENTS,
	PMPERMIT.EXPIREDATE AS STARTDATE,
    DATEADD(MINUTE,30,PMPERMIT.EXPIREDATE) AS ENDDATE,
	NULL AS EXPIRATIONDATE,
	NULL AS APPROVALEXPIRATIONDATE,
	'' AS LOCATION,
	'' AS GLOBALENTITYID,
	1 AS AVAILINCAP,
	1 AS AVAILINCAPCONTACTS,
	PMPERMIT.PMPERMITID  AS CASERECORDID,
	PMPERMIT.PERMITNUMBER AS CASENUMBER,
	PMPERMITTYPE.PMPERMITTYPEID AS CASETYPEID,
	PMPERMITTYPE.NAME AS CASETYPE,
	0 AS CASEMODULE,
	PMPERMITWORKCLASS.PMPERMITWORKCLASSID AS CASEWORKCLASSID,
	PMPERMITWORKCLASS.NAME AS CASEWORKCLASS,
	'' AS ASSIGNEDUSER,
	PMPERMIT.DESCRIPTION AS CASEDESCRIPTION,
	NULL AS INVOICEDATE,
	0 AS TOTAL,
	PRPROJECT.NAME AS PROJECTNAME,
	PMPERMIT.APPLYDATE AS APPLYDATE,
	PMPERMIT.ISSUEDATE AS ISSUEDATE,
	PMPERMIT.FINALIZEDATE AS FINALIZEDATE,
	NULL AS COMPLETEDATE,
	ISNULL(MAILINGADDRESS.ADDRESSLINE1, '') + ' ' + 
		ISNULL(MAILINGADDRESS.ADDRESSLINE2, '') + ' ' + 
		ISNULL(MAILINGADDRESS.STREETTYPE, '') + ' ' + 
		ISNULL(MAILINGADDRESS.CITY, '') + ' ' + 
		ISNULL(MAILINGADDRESS.STATE, '') + ' ' + 
		ISNULL(MAILINGADDRESS.POSTALCODE, '') AS ADDRESS,
	'' AS DBA,
	'' AS COMPANY														
    FROM PMPERMIT
	INNER JOIN PMPERMITTYPE ON PMPERMITTYPE.PMPERMITTYPEID = PMPERMIT.PMPERMITTYPEID
	INNER JOIN PMPERMITSTATUS ON PMPERMITSTATUS.PMPERMITSTATUSID = PMPERMIT.PMPERMITSTATUSID
	INNER JOIN PMPERMITWORKCLASS ON PMPERMITWORKCLASS.PMPERMITWORKCLASSID = PMPERMIT.PMPERMITWORKCLASSID
	LEFT OUTER JOIN PRPROJECTPERMIT ON PRPROJECTPERMIT.PMPERMITID = PMPERMIT.PMPERMITID 
	LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTPERMIT.PRPROJECTID
	LEFT OUTER JOIN PMPERMITADDRESS ON PMPERMIT.PMPERMITID = PMPERMITADDRESS.PMPERMITID AND PMPERMITADDRESS.MAIN = 1
	LEFT OUTER JOIN MAILINGADDRESS ON PMPERMITADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
	WHERE  @PERMITOPTION=1 AND ISNULL(@GLOBAL_ENTITY_ID,'')!='' AND  EXISTS(SELECT * FROM PMPERMITCONTACT WHERE PMPERMITCONTACT.GLOBALENTITYID = @GLOBAL_ENTITY_ID AND PMPERMITCONTACT.PMPERMITID = PMPERMIT.PMPERMITID)
	AND PMPERMIT.EXPIREDATE  >= @START_DATE AND PMPERMIT.EXPIREDATE < @END_DATE
	
	UNION
	SELECT 	distinct 6 AS CALENDAROPTION,
	'' AS EVENTID,
    IMINSPECTION.INSPECTIONNUMBER  AS EVENTNAME,
	IMINSPECTIONTYPE.NAME AS SUBJECT,
    '' AS STATUS,
	'' AS COMMENTS,
	IMINSPECTION.SCHEDULEDSTARTDATE    AS STARTDATE,
	CASE WHEN IMINSPECTION.SCHEDULEDSTARTDATE = IMINSPECTION.SCHEDULEDENDDATE 
		THEN DATEADD(MINUTE,30,IMINSPECTION.SCHEDULEDSTARTDATE) 
	ELSE IMINSPECTION.SCHEDULEDENDDATE END  AS ENDDATE,
	NULL AS EXPIRATIONDATE,
	NULL AS APPROVALEXPIRATIONDATE,
	'' AS LOCATION,
	'' AS GLOBALENTITYID,
	1 AS AVAILINCAP,
	1 AS AVAILINCAPCONTACTS,
	IMINSPECTION.IMINSPECTIONID AS CASERECORDID,
	IMINSPECTION.LINKNUMBER AS CASENUMBER,
	(CASE WHEN PMPERMIT.PMPERMITID is not null THEN PMPERMIT.PMPERMITID  ELSE PLPLAN.PLPLANID END ) AS CASETYPEID,
	'' AS CASETYPE,
	(CASE WHEN PMPERMIT.PMPERMITID is null THEN 2 ELSE 1 END ) AS CASEMODULE,
	'' AS CASEWORKCLASSID,
	'' AS CASEWORKCLASS,
	USERS.FNAME + ' ' + USERS.LNAME AS ASSIGNEDUSER,
	NULL AS CASEDESCRIPTION,
    NULL AS INVOICEDATE,
	0 AS TOTAL,
	'' AS PROJECTNAME,
	NULL AS APPLYDATE,
	NULL AS ISSUEDATE,
	NULL AS FINALIZEDATE,
	NULL AS COMPLETEDATE,
	'' AS ADDRESS,
	'' AS DBA,
	'' AS COMPANY													
    FROM IMINSPECTION
	INNER JOIN  IMINSPECTIONTYPE ON IMINSPECTIONTYPE.IMINSPECTIONTYPEID = IMINSPECTION.IMINSPECTIONTYPEID
	INNER JOIN  IMINSPECTORREF ON IMINSPECTION.IMINSPECTIONID = IMINSPECTORREF.INSPECTIONID 
	INNER JOIN  USERS ON IMINSPECTORREF.USERID = USERS.SUSERGUID
	LEFT JOIN PMPERMIT ON PMPERMIT.PMPERMITID  = IMINSPECTION.LINKID
	LEFT JOIN PLPLAN ON PLPLAN.PLPLANID = IMINSPECTION.LINKID 
	  
	WHERE @INSPECTIONOPTION =1 AND ISNULL(@GLOBAL_ENTITY_ID,'')!='' AND  EXISTS(SELECT 1 FROM IMINSPECTIONCONTACT WHERE IMINSPECTIONCONTACT.GLOBALENTITYID = @GLOBAL_ENTITY_ID 
				AND IMINSPECTIONCONTACT.IMINSPECTIONID = IMINSPECTION.IMINSPECTIONID) 
				 AND (@HIDELICENSE=0 OR (@HIDELICENSE=1 AND IMINSPECTION.IMINSPECTIONLINKID NOT IN (6,7)))
	AND IMINSPECTION.SCHEDULEDSTARTDATE >= @START_DATE AND IMINSPECTION.SCHEDULEDENDDATE < @END_DATE 
	
	UNION
	SELECT 	7 AS CALENDAROPTION,
	'' AS EVENTID,
    CAINVOICE.INVOICENUMBER AS EVENTNAME,
	'' AS SUBJECT,
    CASTATUS.NAME AS STATUS,
	'' AS COMMENTS,
	CAINVOICE.INVOICEDUEDATE AS STARTDATE,
	DATEADD(MINUTE,30,CAINVOICE.INVOICEDUEDATE) AS ENDDATE,
	NULL AS EXPIRATIONDATE,
	NULL AS APPROVALEXPIRATIONDATE,
	'' AS LOCATION,
	'' AS GLOBALENTITYID,
	1 AS AVAILINCAP,
	1 AS AVAILINCAPCONTACTS,
	CAINVOICE.CAINVOICEID AS CASERECORDID,
	CAINVOICE.INVOICENUMBER AS CASENUMBER,
	'' AS CASETYPEID,
	'' AS CASETYPE,
	0 AS CASEMODULE,
	'' AS CASEWORKCLASSID,
	'' AS CASEWORKCLASS,
	'' AS ASSIGNEDUSER,
	NULL AS CASEDESCRIPTION,
    CAINVOICE.INVOICEDATE AS INVOICEDATE,
	CAINVOICE.INVOICETOTAL AS TOTAL,
	'' AS PROJECTNAME,
	NULL AS APPLYDATE,
	NULL AS ISSUEDATE,
	NULL AS FINALIZEDATE,
	NULL AS COMPLETEDATE,
	'' AS ADDRESS,
	'' AS DBA,
	'' AS COMPANY							
	FROM CAINVOICE 
	INNER JOIN  CASTATUS on CASTATUS.CASTATUSID = CAINVOICE.CASTATUSID
	INNER JOIN CAINVOICECONTACT ON CAINVOICECONTACT.CAINVOICEID = CAINVOICE.CAINVOICEID
	WHERE @INVOICEOPTION=1 AND ISNULL(@GLOBAL_ENTITY_ID,'')!='' AND ( CAINVOICECONTACT.GLOBALENTITYID = @GLOBAL_ENTITY_ID  AND CAINVOICE.CASTATUSID NOT IN (4,5,9,10) 	
	AND [dbo].[CSS_INVOICE_DUE_AMOUNT](CAINVOICE.CAINVOICEID, CAINVOICE.CASTATUSID, CAINVOICE.INVOICETOTAL) > 0 
	--AND (CAINVOICE.CASTATUSID in (1,3,6) ) OR CAINVOICE.CASTATUSID in (2,7,8))
	AND CAINVOICE.INVOICEDUEDATE >= @START_DATE AND CAINVOICE.INVOICEDUEDATE < @END_DATE)

	UNION
	SELECT 8 AS CALENDAROPTION,
	'' AS EVENTID,
    BLLICENSE.LICENSENUMBER AS EVENTNAME,
	'' AS SUBJECT,
    BLLICENSESTATUS.NAME AS STATUS,
	'' AS COMMENTS,
	BLLICENSE.EXPIRATIONDATE AS STARTDATE,
    DATEADD(MINUTE,30,BLLICENSE.EXPIRATIONDATE) AS ENDDATE,
	NULL AS EXPIRATIONDATE,
	NULL AS APPROVALEXPIRATIONDATE,
	'' AS LOCATION,
	'' AS GLOBALENTITYID,
	1 AS AVAILINCAP,
	1 AS AVAILINCAPCONTACTS,
	BLLICENSE.BLLICENSEID  AS CASERECORDID,
	BLLICENSE.LICENSENUMBER AS CASENUMBER,
	BLLICENSETYPE.BLLICENSETYPEID AS CASETYPEID,
	BLLICENSETYPE.NAME AS CASETYPE,
	0 AS CASEMODULE,
	BLLICENSECLASS.BLLICENSECLASSID AS CASEWORKCLASSID,
	BLLICENSECLASS.NAME AS CASEWORKCLASS,
	'' AS ASSIGNEDUSER,
	BLLICENSE.DESCRIPTION AS CASEDESCRIPTION,
	NULL AS INVOICEDATE,
	0 AS TOTAL,
	'' AS PROJECTNAME,
	BLLICENSE.APPLIEDDATE AS APPLYDATE,
	BLLICENSE.ISSUEDDATE AS ISSUEDATE,
	NULL AS FINALIZEDATE,
	NULL AS COMPLETEDATE,
	ISNULL(MAILINGADDRESS.ADDRESSLINE1, '') + ' ' + 
		ISNULL(MAILINGADDRESS.ADDRESSLINE2, '') + ' ' + 
		ISNULL(MAILINGADDRESS.STREETTYPE, '') + ' ' + 
		ISNULL(MAILINGADDRESS.CITY, '') + ' ' + 
		ISNULL(MAILINGADDRESS.STATE, '') + ' ' + 
		ISNULL(MAILINGADDRESS.POSTALCODE, '') AS ADDRESS,
	BLGLOBALENTITYEXTENSION.DBA AS DBA,
	GLOBALENTITY.GLOBALENTITYNAME AS COMPANY
    FROM BLLICENSE
	INNER JOIN BLLICENSETYPE ON BLLICENSETYPE.BLLICENSETYPEID = BLLICENSE.BLLICENSETYPEID
	INNER JOIN BLLICENSESTATUS ON BLLICENSESTATUS.BLLICENSESTATUSID = BLLICENSE.BLLICENSESTATUSID
	INNER JOIN BLLICENSECLASS ON BLLICENSECLASS.BLLICENSECLASSID = BLLICENSE.BLLICENSECLASSID
	LEFT OUTER JOIN BLLICENSEADDRESS ON BLLICENSE.BLLICENSEID = BLLICENSEADDRESS.BLLICENSEID AND BLLICENSEADDRESS.MAIN = 1
	LEFT OUTER JOIN MAILINGADDRESS ON BLLICENSEADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
	LEFT OUTER JOIN  BLGLOBALENTITYEXTENSION ON BLGLOBALENTITYEXTENSION.BLGLOBALENTITYEXTENSIONID = BLLICENSE.BLGLOBALENTITYEXTENSIONID
	LEFT OUTER JOIN  GLOBALENTITY AS GLOBALENTITY ON GLOBALENTITY.GLOBALENTITYID = BLGLOBALENTITYEXTENSION.GLOBALENTITYID 
	WHERE @BUSINESSLICENSEOPTION=1 AND ISNULL(@GLOBAL_ENTITY_ID,'')!='' AND  EXISTS(SELECT * FROM BLLICENSECONTACT WHERE BLLICENSECONTACT.GLOBALENTITYID = @GLOBAL_ENTITY_ID AND BLLICENSECONTACT.BLLICENSEID = BLLICENSE.BLLICENSEID)
	AND BLLICENSE.EXPIRATIONDATE  >= @START_DATE AND BLLICENSE.EXPIRATIONDATE < @END_DATE

	UNION
	SELECT 9 AS CALENDAROPTION,
	'' AS EVENTID,
    ILLICENSE.LICENSENUMBER AS EVENTNAME,
	'' AS SUBJECT,
    ILLICENSESTATUS.NAME AS STATUS,
	'' AS COMMENTS,
	ILLICENSE.EXPIRATIONDATE AS STARTDATE,
    DATEADD(MINUTE,30,ILLICENSE.EXPIRATIONDATE) AS ENDDATE,
	NULL AS EXPIRATIONDATE,
	NULL AS APPROVALEXPIRATIONDATE,
	'' AS LOCATION,--
	'' AS GLOBALENTITYID,
	1 AS AVAILINCAP,
	1 AS AVAILINCAPCONTACTS,
	ILLICENSE.ILLICENSEID  AS CASERECORDID,
	ILLICENSE.LICENSENUMBER AS CASENUMBER,
	ILLICENSETYPE.ILLICENSETYPEID AS CASETYPEID,
	ILLICENSETYPE.NAME AS CASETYPE,
	0 AS CASEMODULE,
	ILLICENSECLASSIFICATION.ILLICENSECLASSIFICATIONID AS CASEWORKCLASSID,
	ILLICENSECLASSIFICATION.NAME AS CASEWORKCLASS,
	'' AS ASSIGNEDUSER,
	ILLICENSE.DESCRIPTION AS CASEDESCRIPTION,
	NULL AS INVOICEDATE,
	0 AS TOTAL,
	'' AS PROJECTNAME,
	ILLICENSE.APPLIEDDATE AS APPLYDATE,
	ILLICENSE.ISSUEDATE AS ISSUEDATE,
	NULL AS FINALIZEDATE,
	NULL AS COMPLETEDATE,
	ISNULL(MAILINGADDRESS.ADDRESSLINE1, '') + ' ' + 
		ISNULL(MAILINGADDRESS.ADDRESSLINE2, '') + ' ' + 
		ISNULL(MAILINGADDRESS.STREETTYPE, '') + ' ' + 
		ISNULL(MAILINGADDRESS.CITY, '') + ' ' + 
		ISNULL(MAILINGADDRESS.STATE, '') + ' ' + 
		ISNULL(MAILINGADDRESS.POSTALCODE, '') AS ADDRESS,
	'' AS DBA,
	'' AS COMPANY
    FROM ILLICENSE
	INNER JOIN ILLICENSETYPE ON ILLICENSETYPE.ILLICENSETYPEID = ILLICENSE.ILLICENSETYPEID
	INNER JOIN ILLICENSESTATUS ON ILLICENSESTATUS.ILLICENSESTATUSID = ILLICENSE.ILLICENSESTATUSID
	INNER JOIN ILLICENSECLASSIFICATION ON ILLICENSECLASSIFICATION.ILLICENSECLASSIFICATIONID = ILLICENSE.ILLICENSECLASSIFICATIONID
	LEFT OUTER JOIN ILLICENSEADDRESS ON ILLICENSE.ILLICENSEID = ILLICENSEADDRESS.ILLICENSEID AND ILLICENSEADDRESS.MAIN = 1
	LEFT OUTER JOIN MAILINGADDRESS ON ILLICENSEADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
	WHERE  @PROFLICENSEOPTION=1 
	AND ISNULL(@GLOBAL_ENTITY_ID,'')!=''
	AND  ( ILLICENSE.GLOBALENTITYID = @GLOBAL_ENTITY_ID
			OR EXISTS(SELECT * FROM ILLICENSECONTACT WHERE ILLICENSECONTACT.GLOBALENTITYID = @GLOBAL_ENTITY_ID AND ILLICENSECONTACT.ILLICENSEID = ILLICENSE.ILLICENSEID))
	AND ILLICENSE.EXPIRATIONDATE  >= @START_DATE AND ILLICENSE.EXPIRATIONDATE < @END_DATE
	) AS EVENTCALENDAR
END
