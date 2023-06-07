﻿CREATE PROCEDURE [managemyreview].[USP_PLITEMREVIEW_GETBYID_FORILLICENSE]
(
	 @ID	CHAR(36)
)
AS
BEGIN

SELECT		PLITEMREVIEW.PLITEMREVIEWID				
			, PLITEMREVIEW.PLSUBMITTALID			
			, PLITEMREVIEW.ASSIGNEDUSERID 
			, PLITEMREVIEW.COMPLETEDATE 
			, PLITEMREVIEW.COMPLETED 
			, PLITEMREVIEW.NOTREQUIRED 
			, PLITEMREVIEW.DUEDATE 
			, ILLICENSE.ILLICENSEID AS ENTITYID
			, ILLICENSE.LICENSENUMBER AS ENTITYNUMBER
			, ILLICENSETYPE.ILLICENSETYPEID AS ENTITYTYPEID
			, ILLICENSETYPE.NAME AS ENTITYTYPENAME
			, ILLICENSECLASSIFICATION.ILLICENSECLASSIFICATIONID AS ENTITYCLASSID
			, ILLICENSECLASSIFICATION.NAME AS ENTITYCLASSNAME
			, ILLICENSE.DESCRIPTION AS ENTITYDESCRIPTION
			, ILLICENSE.APPLIEDDATE AS APPLIEDDATE
			, 4 AS MODULEID
			, PLSUBMITTALTYPE.PLSUBMITTALTYPEID AS SUBMITTALTYPEID
			, PLSUBMITTALTYPE.TYPENAME AS SUBMITTALTYPENAME
			, PLITEMREVIEWSTATUS.PLITEMREVIEWSTATUSID AS ITEMREVIEWSTATUSID
			, PLITEMREVIEWSTATUS.NAME AS ITEMREVIEWSTATUS
			, PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID AS ITEMREVIEWTYPEID
			, PLITEMREVIEWTYPE.NAME AS ITEMREVIEWTYPE
			, ILLICENSEWFACTIONSTEP.VERSIONNUMBER AS VERSIONNUMBER
			, ILLICENSEADDRESS.ILLICENSEADDRESSID AS MAINADDRESSID
			, NULL AS PROJECTID
			, NULL AS PROJECTNAME
			, ERENTITYSESSION.ERENTITYSESSIONID AS SESSIONID
			, CAST(0 AS DECIMAL) AS SQUAREFEET
			, CAST(0 AS DECIMAL) AS VALUATIONVALUE
			, CAST(0 AS BIT) AS ISSUEDFLAG
			, CAST(0 AS BIT) AS COMPLETEDFLAG
			, CASEASSIGNEDTO.EMAIL AS CASEASSIGNEDTOEMAIL
			, CASEASSIGNEDTO.FNAME AS CASEASSIGNEDTOFIRSTNAME
			, CASEASSIGNEDTO.LNAME AS CASEASSIGNEDTOLASTNAME
			, NULL AS BUSINESSNAME
			, GLOBALENTITY.FIRSTNAME  AS LICENSEHOLDERFIRSTNAME
			, GLOBALENTITY.LASTNAME  AS LICENSEHOLDERLASTNAME
			, ILLICENSE.EXPIRATIONDATE
			, ILLICENSE.LASTRENEWALDATE
			, ILLICENSE.LICENSEYEAR AS LICENSEYEAR
			, ILLICENSETYPE.NAME AS LICENSETYPE
			, ILLICENSESTATUS.NAME AS LICENSESTATUS
			, NULL AS ZONEID
			, NULL AS ZONENAME
			, NULL AS ZONECODE
			, NULL AS ZONEDESCRIPTION
			, ILLICENSEADDRESS.ILLICENSEADDRESSID AS PARENTADDRESSID
			, USERS.FNAME AS ASSIGNEDUSERFIRSTNAME
			, USERS.LNAME AS ASSIGNEDUSERLASTNAME
			, ILLICENSEWFACTIONSTEP.ILLICENSEWFSTEPID AS ILLICENSEWFSTEPID
			, ERENTITYSESSION.SESSIONSTATUSID AS SESSIONSTATUSID
			, PLITEMREVIEWTYPE.CODENAME AS CODENAME
			, PLITEMREVIEWTYPE.CODEURL AS CODEURL
			, NULL as LICENSETYPEMODULEID 
FROM		PLITEMREVIEW 
INNER JOIN	PLSUBMITTAL ON PLITEMREVIEW.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
INNER JOIN	PLITEMREVIEWSTATUS ON PLITEMREVIEWSTATUS.PLITEMREVIEWSTATUSID = PLITEMREVIEW.PLITEMREVIEWSTATUSID
INNER JOIN	PLSUBMITTALTYPE ON PLSUBMITTAL.PLSUBMITTALTYPEID = PLSUBMITTALTYPE.PLSUBMITTALTYPEID
INNER JOIN	PLSUBMITTALSTATUS ON PLSUBMITTALSTATUS.PLSUBMITTALSTATUSID = PLSUBMITTAL.PLSUBMITTALSTATUSID
INNER JOIN	PLITEMREVIEWTYPE ON PLITEMREVIEW.PLITEMREVIEWTYPEID = PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID
INNER JOIN	ILLICENSEWFACTIONSTEP ON ILLICENSEWFACTIONSTEP.ILLICENSEWFACTIONSTEPID = PLSUBMITTAL.ILLICENSEWFACTIONSTEPID
INNER JOIN	ILLICENSE ON ILLICENSE.ILLICENSEID = PLSUBMITTAL.ILLICENSEID
INNER JOIN	ILLICENSETYPE ON ILLICENSE.ILLICENSETYPEID = ILLICENSETYPE.ILLICENSETYPEID
INNER JOIN	ILLICENSESTATUS ON ILLICENSE.ILLICENSESTATUSID = ILLICENSESTATUS.ILLICENSESTATUSID
INNER JOIN	ILLICENSECLASSIFICATION ON ILLICENSE.ILLICENSECLASSIFICATIONID = ILLICENSECLASSIFICATION.ILLICENSECLASSIFICATIONID
LEFT JOIN	ILLICENSEADDRESS ON ILLICENSE.ILLICENSEID = ILLICENSEADDRESS.ILLICENSEID AND ILLICENSEADDRESS.MAIN = 1
INNER JOIN	USERS ON USERS.SUSERGUID = PLITEMREVIEW.ASSIGNEDUSERID
LEFT JOIN  USERS AS CASEASSIGNEDTO ON CASEASSIGNEDTO.SUSERGUID = ILLICENSE.ISSUEDBY 
INNER JOIN	GLOBALENTITY ON GLOBALENTITY.GLOBALENTITYID = ILLICENSE.GLOBALENTITYID
LEFT JOIN	ERENTITYSESSION ON ERENTITYSESSION.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID		
WHERE		PLITEMREVIEW.PLITEMREVIEWID = @ID

END