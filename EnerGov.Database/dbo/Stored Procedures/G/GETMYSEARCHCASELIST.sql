﻿CREATE PROCEDURE [dbo].[GETMYSEARCHCASELIST]
-- Add the parameters for the stored procedure here
@ASSIGNEDUSERGUID char(36),
@ROLEID char(36),
@ITEMREVIEWSTATUSID char(36),
@ITEMREVIEWDUEDATEFROM datetime,
@ITEMREVIEWDUEDATETO datetime,
@CASENUMBER nvarchar(50),
@MODULEID int,
@NOTREQUIRED bit,
@PROJECTNAME nvarchar(50),
@SUBMITTALTYPEID char(36),
@DEPARTMENTID char(36),
@PREDIRECTION nvarchar(30),
@ADDRESSLINE1 nvarchar(200),
@ADDRESSLINE2 nvarchar(200),	
@ADDRESSLINE3 nvarchar(200),
@STREETTYPE nvarchar(50),
@POSTDIRECTION nvarchar(30),
@UNITORSUITE nvarchar(20),
@SUBMITTALNAME nvarchar(50),
@UPLOADFOLDER nvarchar(20)		
AS
BEGIN
	IF @UPLOADFOLDER IS NOT NULL
	BEGIN
		IF @MODULEID = 1
		BEGIN
			SELECT @CASENUMBER = PLPLAN.PLANNUMBER 
			FROM PLPLAN
			INNER JOIN ERPROJECT ON ERPROJECT.PLPLANID = PLPLAN.PLPLANID
			WHERE ERPROJECT.UPLOADFOLDER = @UPLOADFOLDER
		END
		ELSE IF @MODULEID = 2
		BEGIN
			SELECT @CASENUMBER = PMPERMIT.PERMITNUMBER 
			FROM PMPERMIT
			INNER JOIN ERPROJECT ON ERPROJECT.PMPERMITID = PMPERMIT.PMPERMITID
			WHERE ERPROJECT.UPLOADFOLDER = @UPLOADFOLDER
		END
	END
	IF @MODULEID = 1
	BEGIN
		SELECT	DISTINCT PLPLAN.PLPLANID AS CASEID,
				PLPLAN.PLANNUMBER AS CASENUMBER,
				PLPLANTYPE.PLANNAME AS CASETYPENAME,
				PLPLANWORKCLASS.NAME AS CASEWORKCLASSNAME,
				PLPLANSTATUS.NAME AS CASESTATUSNAME,
				PLPLAN.DESCRIPTION AS CASEDESCRIPTION,
				PRPROJECT.NAME AS PROJECTNAME,
				DISTRICT.NAME AS DISTRICTNAME,
				ASSIGNEDUSER.FNAME,
				ASSIGNEDUSER.LNAME,
				PLPLAN.APPLICATIONDATE,
				PLPLAN.COMPLETEDATE,
				PLPLAN.EXPIREDATE,
				NULL AS ISSUEDATE,
				PLPLAN.APPROVALEXPIREDATE,
				PLPLAN.SQUAREFEET,
				PLPLAN.VALUE,
				PRPROJECT.PRPROJECTID,
				1 AS MODULEID				
		FROM PLPLAN
		INNER JOIN PLITEMREVIEW	ON PLITEMREVIEW.PLPLANID = PLPLAN.PLPLANID	
		INNER JOIN PLITEMREVIEWTYPE ON PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID = PLITEMREVIEW.PLITEMREVIEWTYPEID
		INNER JOIN DISTRICT ON DISTRICT.DISTRICTID = PLPLAN.DISTRICTID	
		INNER JOIN USERS ON USERS.SUSERGUID = PLITEMREVIEW.ASSIGNEDUSERID
		LEFT OUTER JOIN USERS AS ASSIGNEDUSER ON ASSIGNEDUSER.SUSERGUID = PLPLAN.ASSIGNEDTO
		LEFT OUTER JOIN DEPARTMENT ON DEPARTMENT.DEPARTMENTID = PLITEMREVIEWTYPE.DEPARTMENTID			
		INNER JOIN PLITEMREVIEWSTATUS ON PLITEMREVIEWSTATUS.PLITEMREVIEWSTATUSID = PLITEMREVIEW.PLITEMREVIEWSTATUSID	
		INNER JOIN PLSUBMITTAL ON PLITEMREVIEW.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
		INNER JOIN PLSUBMITTALTYPE ON PLSUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID			
		OUTER APPLY (SELECT TOP 1 PRPROJECTID FROM PRPROJECTPLAN WHERE PRPROJECTPLAN.PLPLANID = PLPLAN.PLPLANID) A
		LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = A.PRPROJECTID	
		INNER JOIN PLPLANTYPE ON PLPLANTYPE.PLPLANTYPEID = PLPLAN.PLPLANTYPEID
		INNER JOIN PLPLANSTATUS ON PLPLANSTATUS.PLPLANSTATUSID = PLPLAN.PLPLANSTATUSID	
		LEFT OUTER JOIN PLPLANWORKCLASS ON PLPLANWORKCLASS.PLPLANWORKCLASSID = PLPLAN.PLPLANWORKCLASSID
		OUTER APPLY (SELECT TOP 1 PLPLANADDRESS.MAILINGADDRESSID FROM PLPLANADDRESS WHERE PLPLANADDRESS.PLPLANID = PLPLAN.PLPLANID AND PLPLANADDRESS.MAIN = 1) B
		LEFT OUTER JOIN MAILINGADDRESS ON MAILINGADDRESS.MAILINGADDRESSID = B.MAILINGADDRESSID 
		LEFT OUTER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = PLSUBMITTAL.PLPLANWFACTIONSTEPID
		LEFT OUTER JOIN ROLERECORDTYPEXREF ON ROLERECORDTYPEXREF.RECORDTYPEID = PLPLANTYPE.PLPLANTYPEID
		WHERE (@ASSIGNEDUSERGUID is null OR @ASSIGNEDUSERGUID = '' OR PLITEMREVIEW.ASSIGNEDUSERID = @ASSIGNEDUSERGUID) AND	
				(@ITEMREVIEWSTATUSID is null OR @ITEMREVIEWSTATUSID = '' OR PLITEMREVIEW.PLITEMREVIEWSTATUSID = @ITEMREVIEWSTATUSID) AND	  
				(@DEPARTMENTID is null OR @DEPARTMENTID = '' OR DEPARTMENT.DEPARTMENTID = @DEPARTMENTID) AND
				((@ITEMREVIEWDUEDATEFROM is null AND @ITEMREVIEWDUEDATETO is null) OR 
				(PLITEMREVIEW.DUEDATE >= @ITEMREVIEWDUEDATEFROM AND  PLITEMREVIEW.DUEDATE <= @ITEMREVIEWDUEDATETO)) AND
				(@CASENUMBER is null OR @CASENUMBER = '' OR PLPLAN.PLANNUMBER LIKE ('%' + @CASENUMBER + '%')) AND
				(@PROJECTNAME is null OR @PROJECTNAME = '' OR PRPROJECT.NAME LIKE ('%' + @PROJECTNAME + '%')) AND 		  		  
				(PLITEMREVIEW.NOTREQUIRED = @NOTREQUIRED) AND
				(@SUBMITTALTYPEID is null OR @SUBMITTALTYPEID = '' OR PLSUBMITTALTYPE.PLSUBMITTALTYPEID = @SUBMITTALTYPEID) AND
				(@PREDIRECTION is null OR @PREDIRECTION = '' OR MAILINGADDRESS.PREDIRECTION = @PREDIRECTION) AND
				(@ADDRESSLINE1 is null OR @ADDRESSLINE1 = '' OR MAILINGADDRESS.ADDRESSLINE1 LIKE '%' + @ADDRESSLINE1 + '%') AND
				(@ADDRESSLINE2 is null OR @ADDRESSLINE2 = '' OR MAILINGADDRESS.ADDRESSLINE2 LIKE '%' + @ADDRESSLINE2 + '%') AND
				(@ADDRESSLINE3 is null OR @ADDRESSLINE3 = '' OR MAILINGADDRESS.ADDRESSLINE3 LIKE '%' + @ADDRESSLINE3 + '%') AND
				(@STREETTYPE is null OR @STREETTYPE = '' OR MAILINGADDRESS.STREETTYPE = @STREETTYPE) AND
				(@POSTDIRECTION is null OR @POSTDIRECTION = '' OR MAILINGADDRESS.POSTDIRECTION = @POSTDIRECTION) AND
				(@UNITORSUITE is null OR @UNITORSUITE = '' OR MAILINGADDRESS.UNITORSUITE LIKE '%' + @UNITORSUITE + '%') AND
				(@SUBMITTALNAME is null OR @SUBMITTALNAME = '' OR PLPLANWFACTIONSTEP.NAME LIKE '%' + @SUBMITTALNAME + '%') AND
				(@ROLEID is null OR @ROLEID = '' OR (ROLERECORDTYPEXREF.ROLEID = @ROLEID AND ROLERECORDTYPEXREF.VISIBLE = 1))    
	END
	ELSE IF @MODULEID = 2
	BEGIN
		SELECT	DISTINCT PMPERMIT.PMPERMITID AS CASEID,
				PMPERMIT.PERMITNUMBER AS CASENUMBER,
				PMPERMITTYPE.NAME AS CASETYPENAME,
				PMPERMITWORKCLASS.NAME AS CASEWORKCLASSNAME,
				PMPERMITSTATUS.NAME AS CASESTATUSNAME,
				PMPERMIT.DESCRIPTION AS CASEDESCRIPTION,
				PRPROJECT.NAME AS PROJECTNAME,
				DISTRICT.NAME AS DISTRICTNAME,
				ASSIGNEDUSER.FNAME,
				ASSIGNEDUSER.LNAME,
				PMPERMIT.APPLYDATE AS APPLICATIONDATE,
				NULL AS COMPLETEDATE,
				PMPERMIT.EXPIREDATE,
				PMPERMIT.ISSUEDATE,
				NULL AS APPROVALEXPIREDATE,
				PMPERMIT.SQUAREFEET,
				PMPERMIT.VALUE,
				PRPROJECT.PRPROJECTID,
				2 AS MODULEID
		FROM PMPERMIT
		INNER JOIN PLITEMREVIEW	ON PLITEMREVIEW.PMPERMITID = PMPERMIT.PMPERMITID	
		INNER JOIN PLITEMREVIEWTYPE ON PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID = PLITEMREVIEW.PLITEMREVIEWTYPEID
		INNER JOIN DISTRICT ON DISTRICT.DISTRICTID = PMPERMIT.DISTRICTID	
		INNER JOIN USERS ON USERS.SUSERGUID = PLITEMREVIEW.ASSIGNEDUSERID
		LEFT OUTER JOIN USERS AS ASSIGNEDUSER ON ASSIGNEDUSER.SUSERGUID = PMPERMIT.ASSIGNEDTO
		LEFT OUTER JOIN DEPARTMENT ON DEPARTMENT.DEPARTMENTID = PLITEMREVIEWTYPE.DEPARTMENTID			
		INNER JOIN PLITEMREVIEWSTATUS ON PLITEMREVIEWSTATUS.PLITEMREVIEWSTATUSID = PLITEMREVIEW.PLITEMREVIEWSTATUSID	
		INNER JOIN PLSUBMITTAL ON PLITEMREVIEW.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
		INNER JOIN PLSUBMITTALTYPE ON PLSUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID			
		OUTER APPLY (SELECT TOP 1 PRPROJECTID FROM PRPROJECTPERMIT WHERE PRPROJECTPERMIT.PMPERMITID = PMPERMIT.PMPERMITID) A
		LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = A.PRPROJECTID	
		INNER JOIN PMPERMITTYPE ON PMPERMITTYPE.PMPERMITTYPEID = PMPERMIT.PMPERMITTYPEID
		INNER JOIN PMPERMITSTATUS ON PMPERMITSTATUS.PMPERMITSTATUSID = PMPERMIT.PMPERMITSTATUSID	
		LEFT OUTER JOIN PMPERMITWORKCLASS ON PMPERMITWORKCLASS.PMPERMITWORKCLASSID = PMPERMIT.PMPERMITWORKCLASSID
		OUTER APPLY (SELECT TOP 1 PMPERMITADDRESS.MAILINGADDRESSID FROM PMPERMITADDRESS WHERE PMPERMITADDRESS.PMPERMITID = PMPERMIT.PMPERMITID AND PMPERMITADDRESS.MAIN = 1) B
		LEFT OUTER JOIN MAILINGADDRESS ON MAILINGADDRESS.MAILINGADDRESSID = B.MAILINGADDRESSID 
		LEFT OUTER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = PLSUBMITTAL.PMPERMITWFACTIONSTEPID
		LEFT OUTER JOIN ROLERECORDTYPEXREF ON ROLERECORDTYPEXREF.RECORDTYPEID = PMPERMITTYPE.PMPERMITTYPEID
		WHERE (@ASSIGNEDUSERGUID is null OR @ASSIGNEDUSERGUID = '' OR PLITEMREVIEW.ASSIGNEDUSERID = @ASSIGNEDUSERGUID) AND	
				(@ITEMREVIEWSTATUSID is null OR @ITEMREVIEWSTATUSID = '' OR PLITEMREVIEW.PLITEMREVIEWSTATUSID = @ITEMREVIEWSTATUSID) AND	  
				(@DEPARTMENTID is null OR @DEPARTMENTID = '' OR DEPARTMENT.DEPARTMENTID = @DEPARTMENTID) AND
				((@ITEMREVIEWDUEDATEFROM is null AND @ITEMREVIEWDUEDATETO is null) OR 
				(PLITEMREVIEW.DUEDATE >= @ITEMREVIEWDUEDATEFROM AND  PLITEMREVIEW.DUEDATE <= @ITEMREVIEWDUEDATETO)) AND
				(@CASENUMBER is null OR @CASENUMBER = '' OR PMPERMIT.PERMITNUMBER LIKE ('%' + @CASENUMBER + '%')) AND
				(@PROJECTNAME is null OR @PROJECTNAME = '' OR PRPROJECT.NAME LIKE ('%' + @PROJECTNAME + '%')) AND 		  		  
				(PLITEMREVIEW.NOTREQUIRED = @NOTREQUIRED) AND
				(@SUBMITTALTYPEID is null OR @SUBMITTALTYPEID = '' OR PLSUBMITTALTYPE.PLSUBMITTALTYPEID = @SUBMITTALTYPEID) AND
				(@PREDIRECTION is null OR @PREDIRECTION = '' OR MAILINGADDRESS.PREDIRECTION = @PREDIRECTION) AND
				(@ADDRESSLINE1 is null OR @ADDRESSLINE1 = '' OR MAILINGADDRESS.ADDRESSLINE1 LIKE '%' + @ADDRESSLINE1 + '%') AND
				(@ADDRESSLINE2 is null OR @ADDRESSLINE2 = '' OR MAILINGADDRESS.ADDRESSLINE2 LIKE '%' + @ADDRESSLINE2 + '%') AND
				(@ADDRESSLINE3 is null OR @ADDRESSLINE3 = '' OR MAILINGADDRESS.ADDRESSLINE3 LIKE '%' + @ADDRESSLINE3 + '%') AND
				(@STREETTYPE is null OR @STREETTYPE = '' OR MAILINGADDRESS.STREETTYPE = @STREETTYPE) AND
				(@POSTDIRECTION is null OR @POSTDIRECTION = '' OR MAILINGADDRESS.POSTDIRECTION = @POSTDIRECTION) AND
				(@UNITORSUITE is null OR @UNITORSUITE = '' OR MAILINGADDRESS.UNITORSUITE LIKE '%' + @UNITORSUITE + '%') AND
				(@SUBMITTALNAME is null OR @SUBMITTALNAME = '' OR PMPERMITWFACTIONSTEP.NAME LIKE '%' + @SUBMITTALNAME + '%') AND
				(@ROLEID is null OR @ROLEID = '' OR (ROLERECORDTYPEXREF.ROLEID = @ROLEID AND ROLERECORDTYPEXREF.VISIBLE = 1))    
	END  
	ELSE IF @MODULEID = 0
	BEGIN
		SELECT	DISTINCT PLPLAN.PLPLANID AS CASEID,
		PLPLAN.PLANNUMBER AS CASENUMBER,
		PLPLANTYPE.PLANNAME AS CASETYPENAME,
		PLPLANWORKCLASS.NAME AS CASEWORKCLASSNAME,
		PLPLANSTATUS.NAME AS CASESTATUSNAME,
		PLPLAN.DESCRIPTION AS CASEDESCRIPTION,
		PRPROJECT.NAME AS PROJECTNAME,
		DISTRICT.NAME AS DISTRICTNAME,
		ASSIGNEDUSER.FNAME,
		ASSIGNEDUSER.LNAME,
		PLPLAN.APPLICATIONDATE,
		PLPLAN.COMPLETEDATE,
		PLPLAN.EXPIREDATE,
		NULL AS ISSUEDATE,
		PLPLAN.APPROVALEXPIREDATE,
		PLPLAN.SQUAREFEET,
		PLPLAN.VALUE,
		PRPROJECT.PRPROJECTID,
		1 AS MODULEID				
		FROM PLPLAN
		INNER JOIN PLITEMREVIEW	ON PLITEMREVIEW.PLPLANID = PLPLAN.PLPLANID	
		INNER JOIN PLITEMREVIEWTYPE ON PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID = PLITEMREVIEW.PLITEMREVIEWTYPEID
		INNER JOIN DISTRICT ON DISTRICT.DISTRICTID = PLPLAN.DISTRICTID	
		INNER JOIN USERS ON USERS.SUSERGUID = PLITEMREVIEW.ASSIGNEDUSERID
		LEFT OUTER JOIN USERS AS ASSIGNEDUSER ON ASSIGNEDUSER.SUSERGUID = PLPLAN.ASSIGNEDTO
		LEFT OUTER JOIN DEPARTMENT ON DEPARTMENT.DEPARTMENTID = PLITEMREVIEWTYPE.DEPARTMENTID			
		INNER JOIN PLITEMREVIEWSTATUS ON PLITEMREVIEWSTATUS.PLITEMREVIEWSTATUSID = PLITEMREVIEW.PLITEMREVIEWSTATUSID	
		INNER JOIN PLSUBMITTAL ON PLITEMREVIEW.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
		INNER JOIN PLSUBMITTALTYPE ON PLSUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID			
		OUTER APPLY (SELECT TOP 1 PRPROJECTID FROM PRPROJECTPLAN WHERE PRPROJECTPLAN.PLPLANID = PLPLAN.PLPLANID) A
		LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = A.PRPROJECTID	
		INNER JOIN PLPLANTYPE ON PLPLANTYPE.PLPLANTYPEID = PLPLAN.PLPLANTYPEID
		INNER JOIN PLPLANSTATUS ON PLPLANSTATUS.PLPLANSTATUSID = PLPLAN.PLPLANSTATUSID	
		LEFT OUTER JOIN PLPLANWORKCLASS ON PLPLANWORKCLASS.PLPLANWORKCLASSID = PLPLAN.PLPLANWORKCLASSID
		OUTER APPLY (SELECT TOP 1 PLPLANADDRESS.MAILINGADDRESSID FROM PLPLANADDRESS WHERE PLPLANADDRESS.PLPLANID = PLPLAN.PLPLANID AND PLPLANADDRESS.MAIN = 1) B
		LEFT OUTER JOIN MAILINGADDRESS ON MAILINGADDRESS.MAILINGADDRESSID = B.MAILINGADDRESSID 
		LEFT OUTER JOIN PLPLANWFACTIONSTEP ON PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = PLSUBMITTAL.PLPLANWFACTIONSTEPID
		LEFT OUTER JOIN ROLERECORDTYPEXREF ON ROLERECORDTYPEXREF.RECORDTYPEID = PLPLANTYPE.PLPLANTYPEID
		WHERE (@ASSIGNEDUSERGUID is null OR @ASSIGNEDUSERGUID = '' OR PLITEMREVIEW.ASSIGNEDUSERID = @ASSIGNEDUSERGUID) AND	
				(@ITEMREVIEWSTATUSID is null OR @ITEMREVIEWSTATUSID = '' OR PLITEMREVIEW.PLITEMREVIEWSTATUSID = @ITEMREVIEWSTATUSID) AND	  
				(@DEPARTMENTID is null OR @DEPARTMENTID = '' OR DEPARTMENT.DEPARTMENTID = @DEPARTMENTID) AND
				((@ITEMREVIEWDUEDATEFROM is null AND @ITEMREVIEWDUEDATETO is null) OR 
				(PLITEMREVIEW.DUEDATE >= @ITEMREVIEWDUEDATEFROM AND  PLITEMREVIEW.DUEDATE <= @ITEMREVIEWDUEDATETO)) AND
				(@CASENUMBER is null OR @CASENUMBER = '' OR PLPLAN.PLANNUMBER LIKE ('%' + @CASENUMBER + '%')) AND
				(@PROJECTNAME is null OR @PROJECTNAME = '' OR PRPROJECT.NAME LIKE ('%' + @PROJECTNAME + '%')) AND 		  		  
				(PLITEMREVIEW.NOTREQUIRED = @NOTREQUIRED) AND
				(@SUBMITTALTYPEID is null OR @SUBMITTALTYPEID = '' OR PLSUBMITTALTYPE.PLSUBMITTALTYPEID = @SUBMITTALTYPEID) AND
				(@PREDIRECTION is null OR @PREDIRECTION = '' OR MAILINGADDRESS.PREDIRECTION = @PREDIRECTION) AND
				(@ADDRESSLINE1 is null OR @ADDRESSLINE1 = '' OR MAILINGADDRESS.ADDRESSLINE1 LIKE '%' + @ADDRESSLINE1 + '%') AND
				(@ADDRESSLINE2 is null OR @ADDRESSLINE2 = '' OR MAILINGADDRESS.ADDRESSLINE2 LIKE '%' + @ADDRESSLINE2 + '%') AND
				(@ADDRESSLINE3 is null OR @ADDRESSLINE3 = '' OR MAILINGADDRESS.ADDRESSLINE3 LIKE '%' + @ADDRESSLINE3 + '%') AND
				(@STREETTYPE is null OR @STREETTYPE = '' OR MAILINGADDRESS.STREETTYPE = @STREETTYPE) AND
				(@POSTDIRECTION is null OR @POSTDIRECTION = '' OR MAILINGADDRESS.POSTDIRECTION = @POSTDIRECTION) AND
				(@UNITORSUITE is null OR @UNITORSUITE = '' OR MAILINGADDRESS.UNITORSUITE LIKE '%' + @UNITORSUITE + '%') AND
				(@SUBMITTALNAME is null OR @SUBMITTALNAME = '' OR PLPLANWFACTIONSTEP.NAME LIKE '%' + @SUBMITTALNAME + '%') AND
				(@ROLEID is null OR @ROLEID = '' OR (ROLERECORDTYPEXREF.ROLEID = @ROLEID AND ROLERECORDTYPEXREF.VISIBLE = 1))    
		UNION
		SELECT	DISTINCT PMPERMIT.PMPERMITID AS CASEID,
				PMPERMIT.PERMITNUMBER AS CASENUMBER,
				PMPERMITTYPE.NAME AS CASETYPENAME,
				PMPERMITWORKCLASS.NAME AS CASEWORKCLASSNAME,
				PMPERMITSTATUS.NAME AS CASESTATUSNAME,
				PMPERMIT.DESCRIPTION AS CASEDESCRIPTION,
				PRPROJECT.NAME AS PROJECTNAME,
				DISTRICT.NAME AS DISTRICTNAME,
				ASSIGNEDUSER.FNAME,
				ASSIGNEDUSER.LNAME,
				PMPERMIT.APPLYDATE AS APPLICATIONDATE,
				NULL AS COMPLETEDATE,
				PMPERMIT.EXPIREDATE,
				PMPERMIT.ISSUEDATE,
				NULL AS APPROVALEXPIREDATE,
				PMPERMIT.SQUAREFEET,
				PMPERMIT.VALUE,
				PRPROJECT.PRPROJECTID,
				2 AS MODULEID
		FROM PMPERMIT
		INNER JOIN PLITEMREVIEW	ON PLITEMREVIEW.PMPERMITID = PMPERMIT.PMPERMITID	
		INNER JOIN PLITEMREVIEWTYPE ON PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID = PLITEMREVIEW.PLITEMREVIEWTYPEID
		INNER JOIN DISTRICT ON DISTRICT.DISTRICTID = PMPERMIT.DISTRICTID	
		INNER JOIN USERS ON USERS.SUSERGUID = PLITEMREVIEW.ASSIGNEDUSERID
		LEFT OUTER JOIN USERS AS ASSIGNEDUSER ON ASSIGNEDUSER.SUSERGUID = PMPERMIT.ASSIGNEDTO
		LEFT OUTER JOIN DEPARTMENT ON DEPARTMENT.DEPARTMENTID = PLITEMREVIEWTYPE.DEPARTMENTID			
		INNER JOIN PLITEMREVIEWSTATUS ON PLITEMREVIEWSTATUS.PLITEMREVIEWSTATUSID = PLITEMREVIEW.PLITEMREVIEWSTATUSID	
		INNER JOIN PLSUBMITTAL ON PLITEMREVIEW.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
		INNER JOIN PLSUBMITTALTYPE ON PLSUBMITTALTYPE.PLSUBMITTALTYPEID = PLSUBMITTAL.PLSUBMITTALTYPEID			
		OUTER APPLY (SELECT TOP 1 PRPROJECTID FROM PRPROJECTPERMIT WHERE PRPROJECTPERMIT.PMPERMITID = PMPERMIT.PMPERMITID) A
		LEFT OUTER JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = A.PRPROJECTID	
		INNER JOIN PMPERMITTYPE ON PMPERMITTYPE.PMPERMITTYPEID = PMPERMIT.PMPERMITTYPEID
		INNER JOIN PMPERMITSTATUS ON PMPERMITSTATUS.PMPERMITSTATUSID = PMPERMIT.PMPERMITSTATUSID	
		LEFT OUTER JOIN PMPERMITWORKCLASS ON PMPERMITWORKCLASS.PMPERMITWORKCLASSID = PMPERMIT.PMPERMITWORKCLASSID
		OUTER APPLY (SELECT TOP 1 PMPERMITADDRESS.MAILINGADDRESSID FROM PMPERMITADDRESS WHERE PMPERMITADDRESS.PMPERMITID = PMPERMIT.PMPERMITID AND PMPERMITADDRESS.MAIN = 1) B
		LEFT OUTER JOIN MAILINGADDRESS ON MAILINGADDRESS.MAILINGADDRESSID = B.MAILINGADDRESSID 
		LEFT OUTER JOIN PMPERMITWFACTIONSTEP ON PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID = PLSUBMITTAL.PMPERMITWFACTIONSTEPID
		LEFT OUTER JOIN ROLERECORDTYPEXREF ON ROLERECORDTYPEXREF.RECORDTYPEID = PMPERMITTYPE.PMPERMITTYPEID
		WHERE (@ASSIGNEDUSERGUID is null OR @ASSIGNEDUSERGUID = '' OR PLITEMREVIEW.ASSIGNEDUSERID = @ASSIGNEDUSERGUID) AND	
				(@ITEMREVIEWSTATUSID is null OR @ITEMREVIEWSTATUSID = '' OR PLITEMREVIEW.PLITEMREVIEWSTATUSID = @ITEMREVIEWSTATUSID) AND	  
				(@DEPARTMENTID is null OR @DEPARTMENTID = '' OR DEPARTMENT.DEPARTMENTID = @DEPARTMENTID) AND
				((@ITEMREVIEWDUEDATEFROM is null AND @ITEMREVIEWDUEDATETO is null) OR 
				(PLITEMREVIEW.DUEDATE >= @ITEMREVIEWDUEDATEFROM AND  PLITEMREVIEW.DUEDATE <= @ITEMREVIEWDUEDATETO)) AND
				(@CASENUMBER is null OR @CASENUMBER = '' OR PMPERMIT.PERMITNUMBER LIKE ('%' + @CASENUMBER + '%')) AND
				(@PROJECTNAME is null OR @PROJECTNAME = '' OR PRPROJECT.NAME LIKE ('%' + @PROJECTNAME + '%')) AND 		  		  
				(PLITEMREVIEW.NOTREQUIRED = @NOTREQUIRED) AND
				(@SUBMITTALTYPEID is null OR @SUBMITTALTYPEID = '' OR PLSUBMITTALTYPE.PLSUBMITTALTYPEID = @SUBMITTALTYPEID) AND
				(@PREDIRECTION is null OR @PREDIRECTION = '' OR MAILINGADDRESS.PREDIRECTION = @PREDIRECTION) AND
				(@ADDRESSLINE1 is null OR @ADDRESSLINE1 = '' OR MAILINGADDRESS.ADDRESSLINE1 LIKE '%' + @ADDRESSLINE1 + '%') AND
				(@ADDRESSLINE2 is null OR @ADDRESSLINE2 = '' OR MAILINGADDRESS.ADDRESSLINE2 LIKE '%' + @ADDRESSLINE2 + '%') AND
				(@ADDRESSLINE3 is null OR @ADDRESSLINE3 = '' OR MAILINGADDRESS.ADDRESSLINE3 LIKE '%' + @ADDRESSLINE3 + '%') AND
				(@STREETTYPE is null OR @STREETTYPE = '' OR MAILINGADDRESS.STREETTYPE = @STREETTYPE) AND
				(@POSTDIRECTION is null OR @POSTDIRECTION = '' OR MAILINGADDRESS.POSTDIRECTION = @POSTDIRECTION) AND
				(@UNITORSUITE is null OR @UNITORSUITE = '' OR MAILINGADDRESS.UNITORSUITE LIKE '%' + @UNITORSUITE + '%') AND
				(@SUBMITTALNAME is null OR @SUBMITTALNAME = '' OR PMPERMITWFACTIONSTEP.NAME LIKE '%' + @SUBMITTALNAME + '%') AND
				(@ROLEID is null OR @ROLEID = '' OR (ROLERECORDTYPEXREF.ROLEID = @ROLEID AND ROLERECORDTYPEXREF.VISIBLE = 1))    
	END
END