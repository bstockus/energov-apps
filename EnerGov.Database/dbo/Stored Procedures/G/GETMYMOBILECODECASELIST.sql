﻿	--SELECT @AssignedUserID='2FB39FA9-DF43-41D7-BB8B-C91836D30987'
	--SELECT @RoleId ='A652344C-FDB0-4116-A63B-126FFCAF2B2D'
CREATE PROCEDURE GETMYMOBILECODECASELIST
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
			CMCODECASE.ROWVERSION,
			CMCODECASE. CMCODECASEID,
			CASENUMBER,
			CMCODECASE.CMCODECASESTATUSID STATUSID,
			CMCODECASESTATUS.NAME STATUSNAME,
			OPENEDDATE,
			CLOSEDDATE,
			CMCODECASE.DESCRIPTION,
			CMCODECASE.ASSIGNEDTO,
			USERS.FNAME FIRSTNAME,
			USERS.LNAME LASTNAME,
			CMCODECASE.CMCASETYPEID,
			CMCASETYPE.NAME TYPENAME,
			CMCODECASE.DISTRICTID,
			DISTRICT.NAME DISTRICTNAME,
			PRPROJECT.NAME PROJECTNAME,
			PRPROJECT.PROJECTNUMBER,
			PRPROJECT.PRPROJECTID	
		FROM CMCODECASE 
		INNER JOIN USERS ON USERS.SUSERGUID = CMCODECASE.ASSIGNEDTO	
		INNER JOIN CMCODECASESTATUS ON CMCODECASESTATUS.CMCODECASESTATUSID = CMCODECASE.CMCODECASESTATUSID
		INNER JOIN CMCASETYPE ON CMCASETYPE.CMCASETYPEID = CMCODECASE.CMCASETYPEID
		INNER JOIN DISTRICT ON DISTRICT.DISTRICTID = CMCODECASE.DISTRICTID
		--LEFT OUTER JOIN ROLERECORDTYPEXREF ON ROLERECORDTYPEXREF.RECORDTYPEID = CMCODECASE.CMCASETYPEID
		OUTER APPLY (SELECT TOP 1 ROLEID, VISIBLE FROM ROLERECORDTYPEXREF R 
				WHERE R.RECORDTYPEID = CMCODECASE.CMCASETYPEID AND R.VISIBLE = 1 AND R.ROLEID = @RoleID) ROLERECORDTYPEXREF
		LEFT JOIN PRPROJECTCODECASE ON PRPROJECTCODECASE.CMCODECASEID = CMCODECASE.CMCODECASEID
		LEFT JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTCODECASE.PRPROJECTID
		WHERE CMCODECASE.ASSIGNEDTO = @AssignedUserID	AND		       
			  (@RoleID is null OR @RoleID = '''' OR (ROLERECORDTYPEXREF.ROLEID = @RoleID AND ROLERECORDTYPEXREF.VISIBLE = 1))
			  AND  OPENEDDATE BETWEEN getdate()-@DefaultNumber AND getdate()+@DefaultNumber
			  AND (CMCODECASESTATUS.SUCCESSFLAG <> 1 OR CMCODECASESTATUS.SUCCESSFLAG = @IsAll)
			  AND (CMCODECASESTATUS.FAILUREFLAG <> 1 OR  CMCODECASESTATUS.FAILUREFLAG = @IsAll)
		ORDER BY CMCODECASE.CASENUMBER
END