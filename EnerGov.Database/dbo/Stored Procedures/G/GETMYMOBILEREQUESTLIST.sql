﻿ CREATE PROCEDURE [dbo].[GETMYMOBILEREQUESTLIST]
	-- Add the parameters for the stored procedure here
	@AssignedUserID char(36),
	@RoleID char(36),
	@IsAll bit
	AS

	DECLARE @KEY VARCHAR(MAX) = 'DefaultDaysOfInboxDataForCcaseAndReq'
	DECLARE @DefaultNumber INT = 15
	IF EXISTS(SELECT * FROM SETTINGS WHERE NAME=@KEY)
	BEGIN
	  SELECT @DefaultNumber=ISNULL(INTVALUE,15) FROM SETTINGS WHERE NAME=@KEY
	END

	BEGIN	
		SELECT 
			CITIZENREQUEST.CITIZENREQUESTID, REQUESTNUMBER,IDREQUESTNUMBER, 
			CITIZENREQUEST.CITIZENREQUESTTYPEID,
			CITIZENREQUESTTYPE.NAME TYPENAME,
			CITIZENREQUEST.DESCRIPTION,
			DATEFILED,
			CITIZENREQUEST.CITIZENREQUESTSTATUSID,
			CITIZENREQUESTSTATUS.STATUS STATUSNAME,
			CITIZENREQUEST.CITIZENREQUESTPRIORITYID,
			CITIZENREQUESTPRIORITY.NAME PRIORITYNAME,
			ENTEREDBYUSER,
			ASSIGNEDTOUSER,
			USERS.FNAME FIRSTNAME,
			USERS.LNAME LASTNAME,
			COMPDEADLINE,
			COMPCOMPLETE,
			EMERGENCY,
			RESOLVED,
			CITIZENREQUEST.CITIZENREQUESTSOURCEID,
			CITIZENREQUESTSOURCE.NAME SOURCENAME,
			REVIEWED,
			DISTRICT.DISTRICTID,
			DISTRICT.NAME DISTRICTNAME,
			PRPROJECT.NAME PROJECTNAME,
			PRPROJECT.PROJECTNUMBER,
			PRPROJECT.PRPROJECTID	,
			CITIZENREQUEST.ROWVERSION
		 FROM CITIZENREQUEST
		 INNER JOIN USERS ON USERS.SUSERGUID = CITIZENREQUEST.ASSIGNEDTOUSER	
		 INNER JOIN DISTRICT ON DISTRICT.DISTRICTID = CITIZENREQUEST.DISTRICTID
		 INNER JOIN CITIZENREQUESTTYPE ON CITIZENREQUESTTYPE.CITIZENREQUESTTYPEID = CITIZENREQUEST.CITIZENREQUESTTYPEID
		 INNER JOIN CITIZENREQUESTSTATUS ON CITIZENREQUESTSTATUS.CITIZENREQUESTSTATUSID = CITIZENREQUEST.CITIZENREQUESTSTATUSID
		 INNER JOIN CITIZENREQUESTSOURCE ON CITIZENREQUESTSOURCE.CITIZENREQUESTSOURCEID =CITIZENREQUEST.CITIZENREQUESTSOURCEID
		 LEFT JOIN CITIZENREQUESTPRIORITY ON CITIZENREQUESTPRIORITY.CITIZENREQUESTPRIORITYID = CITIZENREQUEST.CITIZENREQUESTPRIORITYID
		 --LEFT OUTER JOIN ROLERECORDTYPEXREF ON ROLERECORDTYPEXREF.RECORDTYPEID = CITIZENREQUEST.CITIZENREQUESTTYPEID
		 OUTER APPLY (SELECT TOP 1 ROLEID, VISIBLE FROM ROLERECORDTYPEXREF R 
				WHERE R.RECORDTYPEID = CITIZENREQUEST.CITIZENREQUESTTYPEID AND R.VISIBLE = 1 AND R.ROLEID = @RoleID) ROLERECORDTYPEXREF
		 LEFT JOIN PRPROJECTCITIZENREQUEST ON PRPROJECTCITIZENREQUEST.CITIZENREQUESTID = CITIZENREQUEST.CITIZENREQUESTID
		 LEFT JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTCITIZENREQUEST.PRPROJECTID
		WHERE CITIZENREQUEST.ASSIGNEDTOUSER = @AssignedUserID	AND		       
			  (@RoleID is null OR @RoleID = '''' OR (ROLERECORDTYPEXREF.ROLEID = @RoleID AND ROLERECORDTYPEXREF.VISIBLE = 1)) 
			  AND  COMPDEADLINE BETWEEN getdate()-@DefaultNumber AND getdate()+@DefaultNumber
			  AND (CITIZENREQUESTSTATUS.RESOLVEDFLAG <> 1 OR CITIZENREQUESTSTATUS.RESOLVEDFLAG = @IsAll)
		ORDER BY CITIZENREQUEST.REQUESTNUMBER
END