﻿CREATE PROCEDURE [dbo].[GETCASE]
-- Add the parameters for the stored procedure here
@CaseID char(36),
@ModuleID int
AS
BEGIN
	IF @ModuleID = 1
	BEGIN	
		SELECT	DISTINCT PLPLAN.PLPLANID AS CASEID,
				PLPLAN.PLANNUMBER AS CASENUMBER,
				PLPLANTYPE.PLANNAME AS CASETYPENAME,
				PLPLANWORKCLASS.NAME AS CASEWORKCLASSNAME,
				PLPLANSTATUS.NAME AS CASESTATUSNAME,
				PLPLAN.DESCRIPTION AS CASEDESCRIPTION,
				PRPROJECT.NAME AS PROJECTNAME,
				PRPROJECT.PRPROJECTID AS PRPROJECTID,
				DISTRICT.NAME AS DISTRICTNAME,
				PLPLAN.ASSIGNEDTO,
				ASSIGNEDUSER.FNAME,
				ASSIGNEDUSER.LNAME,
				PLPLAN.APPLICATIONDATE,
				PLPLAN.COMPLETEDATE,
				PLPLAN.EXPIREDATE,
				PLPLAN.APPROVALEXPIREDATE,
				PLPLAN.SQUAREFEET,
				PLPLAN.VALUE,
				NULL AS ISSUEDATE,
				1 AS MODULEID
		FROM PLPLAN	
		LEFT OUTER JOIN USERS AS ASSIGNEDUSER ON ASSIGNEDUSER.SUSERGUID = PLPLAN.ASSIGNEDTO
		INNER JOIN PLPLANTYPE ON PLPLANTYPE.PLPLANTYPEID = PLPLAN.PLPLANTYPEID
		LEFT OUTER JOIN PLPLANWORKCLASS ON PLPLANWORKCLASS.PLPLANWORKCLASSID = PLPLAN.PLPLANWORKCLASSID
		INNER JOIN PLPLANSTATUS ON PLPLANSTATUS.PLPLANSTATUSID = PLPLAN.PLPLANSTATUSID
		OUTER APPLY (SELECT TOP 1 PRPROJECTID FROM PRPROJECTPLAN WHERE PRPROJECTPLAN.PLPLANID = PLPLAN.PLPLANID) A
		LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = A.PRPROJECTID
		INNER JOIN DISTRICT ON DISTRICT.DISTRICTID = PLPLAN.DISTRICTID	
		WHERE (PLPLAN.PLPLANID = @CaseID)	 
	END
	ELSE IF @ModuleID = 2
	BEGIN
		SELECT	DISTINCT PMPERMIT.PMPERMITID AS CASEID,
				PMPERMIT.PERMITNUMBER AS CASENUMBER,
				PMPERMITTYPE.NAME AS CASETYPENAME,
				PMPERMITWORKCLASS.NAME AS CASEWORKCLASSNAME,
				PMPERMITSTATUS.NAME AS CASESTATUSNAME,
				PMPERMIT.DESCRIPTION AS CASEDESCRIPTION,
				PRPROJECT.NAME AS PROJECTNAME,
				PRPROJECT.PRPROJECTID AS PRPROJECTID,
				DISTRICT.NAME AS DISTRICTNAME,
				PMPERMIT.ASSIGNEDTO,
				ASSIGNEDUSER.FNAME,
				ASSIGNEDUSER.LNAME,
				PMPERMIT.APPLYDATE AS APPLICATIONDATE,
				NULL AS COMPLETEDATE,
				PMPERMIT.EXPIREDATE,
				NULL AS APPROVALEXPIREDATE,
				PMPERMIT.SQUAREFEET,
				PMPERMIT.VALUE,
				PMPERMIT.ISSUEDATE,
				2 AS MODULEID
		FROM PMPERMIT	
		LEFT OUTER JOIN USERS AS ASSIGNEDUSER ON ASSIGNEDUSER.SUSERGUID = PMPERMIT.ASSIGNEDTO
		INNER JOIN PMPERMITTYPE ON PMPERMITTYPE.PMPERMITTYPEID = PMPERMIT.PMPERMITTYPEID
		LEFT OUTER JOIN PMPERMITWORKCLASS ON PMPERMITWORKCLASS.PMPERMITWORKCLASSID = PMPERMIT.PMPERMITWORKCLASSID
		INNER JOIN PMPERMITSTATUS ON PMPERMITSTATUS.PMPERMITSTATUSID = PMPERMIT.PMPERMITSTATUSID
		OUTER APPLY (SELECT TOP 1 PRPROJECTID FROM PRPROJECTPERMIT WHERE PRPROJECTPERMIT.PMPERMITID = PMPERMIT.PMPERMITID) A
		LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = A.PRPROJECTID
		INNER JOIN DISTRICT ON DISTRICT.DISTRICTID = PMPERMIT.DISTRICTID	
		WHERE (PMPERMIT.PMPERMITID = @CaseID)	
	END	      
END