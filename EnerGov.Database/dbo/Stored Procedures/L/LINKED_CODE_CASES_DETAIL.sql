﻿CREATE PROCEDURE [dbo].LINKED_CODE_CASES_DETAIL
	@ENTITY_ID AS CHAR(36),
	@MODULE_TYPE as VARCHAR(36),
	@FROM INT = 1,
	@TO INT,
	@PAGE_SIZE INT = 20,
	@SORT_FIELD VARCHAR(36),
	@IS_ASC BIT = 1,
	@USER_ID as char(36)
AS
declare @DATA TABLE 
(
	CMCODECASEID char(36),
	ISCHILD BIT,
	ISPARENT BIT
)
	IF (@MODULE_TYPE = 'PermitManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDCODECASEFROMPERMIT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'PlanManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDCODECASEFROMPLAN(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'CodeManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDCODECASEFROMCODECASE(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'BusinessLicenseManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDCODECASEFROMBUSINESSLICENSE(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'BusinessLicenseEntity')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDCODECASEFROMBUSINESS(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ContactManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDCODECASEFROMCONTACT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ProjectManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDCODECASEFROMPROJECT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'PropertyManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDCODECASEFROMPROPERTYMANAGEMENT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'IndividualLicense')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDCODECASEFROMPROFESSIONALLICENSE(@ENTITY_ID, @USER_ID)
	END
BEGIN
WITH LINKEDCODECASES AS(select CMCODECASEID, ISCHILD,ISPARENT FROM @DATA), 
ALLCODECASEDETAILS AS (
SELECT CMCODECASE.CMCODECASEID, CMCODECASE.CASENUMBER, CMCODECASE.CMCASETYPEID,
CMCASETYPE.NAME AS CASETYPE, CMCODECASESTATUS.NAME AS CASESTATUS, USERS.LNAME, USERS.FNAME,
USERS.MIDDLENAME, CMCODECASE.OPENEDDATE, CMCODECASE.CLOSEDDATE,CMCODECASE.DESCRIPTION, MAILINGADDRESS.UNITORSUITE, MAILINGADDRESS.ADDRESSLINE1,
MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.PREDIRECTION,MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.STREETTYPE, PRPROJECT.NAME AS PROJECTNAME 
FROM CMCODECASE
INNER JOIN CMCASETYPE ON CMCODECASE.CMCASETYPEID = CMCASETYPE.CMCASETYPEID
INNER JOIN CMCODECASESTATUS ON CMCODECASE.CMCODECASESTATUSID = CMCODECASESTATUS.CMCODECASESTATUSID
LEFT JOIN USERS ON CMCODECASE.ASSIGNEDTO = USERS.SUSERGUID
LEFT JOIN CMCODECASEADDRESS ON CMCODECASEADDRESS.CMCODECASEID = CMCODECASE.CMCODECASEID
AND CMCODECASEADDRESS.MAIN = 1 LEFT JOIN MAILINGADDRESS
ON MAILINGADDRESS.MAILINGADDRESSID = CMCODECASEADDRESS.MAILINGADDRESSID
LEFT JOIN PRPROJECTCODECASE ON PRPROJECTCODECASE.CMCODECASEID = CMCODECASE.CMCODECASEID
LEFT JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTCODECASE.PRPROJECTID
WHERE CMCODECASE.CMCODECASEID IN (SELECT CMCODECASEID FROM LINKEDCODECASES)),
NUMBEREDDATA AS (
SELECT CASENUMBER,CMCASETYPEID,ALLCODECASEDETAILS.CMCODECASEID,CASETYPE,CASESTATUS,LNAME,FNAME,
MIDDLENAME,OPENEDDATE,CLOSEDDATE,DESCRIPTION,UNITORSUITE,ADDRESSLINE1,ADDRESSLINE2,PREDIRECTION,
POSTDIRECTION,STREETTYPE,PROJECTNAME,LINKEDCODECASES.ISCHILD,LINKEDCODECASES.ISPARENT,
ROW_NUMBER() OVER(
ORDER BY
case when @is_asc = 1 AND @Sort_Field = 'CASENUMBER' then CASENUMBER END ASC, 
case when @is_asc = 0 AND @Sort_Field = 'CASENUMBER' then CASENUMBER END DESC,
case when @is_asc = 1 AND @Sort_Field = 'CASESTATUS' then CASESTATUS END ASC, 
case when @is_asc = 0 AND @Sort_Field = 'CASESTATUS' then CASESTATUS END DESC, 
case when @is_asc = 1 AND @Sort_Field = 'CASETYPE' then CASETYPE END ASC, 
case when @is_asc = 0 AND @Sort_Field = 'CASETYPE' then CASETYPE END DESC,
case when @is_asc = 1 AND @Sort_Field = 'OPENEDDATE' then OPENEDDATE END ASC, 
case when @is_asc = 0 AND @Sort_Field = 'OPENEDDATE' then OPENEDDATE END DESC,
case when @is_asc = 1 AND @Sort_Field = 'CLOSEDDATE' then CLOSEDDATE END ASC, 
case when @is_asc = 0 AND @Sort_Field = 'CLOSEDDATE' then CLOSEDDATE END DESC,
case when @is_asc = 1 AND @Sort_Field = 'ASSIGNEDTO' then LNAME END ASC, 
case when @is_asc = 0 AND @Sort_Field = 'ASSIGNEDTO' then LNAME END DESC,
case when @is_asc = 1 AND @Sort_Field = 'ASSIGNEDTO' then FNAME END ASC, 
case when @is_asc = 0 AND @Sort_Field = 'ASSIGNEDTO' then FNAME END DESC,
case when @is_asc = 1 AND @Sort_Field = 'ASSIGNEDTO' then MIDDLENAME END ASC, 
case when @is_asc = 0 AND @Sort_Field = 'ASSIGNEDTO' then MIDDLENAME END DESC,
case when @is_asc = 1 AND @Sort_Field = 'DESCRIPTION' then DESCRIPTION END ASC, 
case when @is_asc = 0 AND @Sort_Field = 'DESCRIPTION' then DESCRIPTION END DESC,
case when @is_asc = 1 AND @Sort_Field = 'UNITORSUITE' then UNITORSUITE END ASC, 
case when @is_asc = 0 AND @Sort_Field = 'UNITORSUITE' then UNITORSUITE END DESC,
case when @is_asc = 1 AND @Sort_Field = 'ADDRESSLINE1' then ADDRESSLINE1 END ASC, 
case when @is_asc = 0 AND @Sort_Field = 'ADDRESSLINE1' then ADDRESSLINE1 END DESC,
case when @is_asc = 1 AND @Sort_Field = 'PROJECTNAME' then PROJECTNAME END ASC,
case when @is_asc = 0 AND @Sort_Field = 'PROJECTNAME' then PROJECTNAME END DESC)
AS ROWNUMBER , COUNT(1) OVER() AS TOTAL_ROWS
from ALLCODECASEDETAILS INNER JOIN LINKEDCODECASES on ALLCODECASEDETAILS.CMCODECASEID = LINKEDCODECASES.CMCODECASEID)
select * from NUMBEREDDATA WHERE ROWNUMBER > @From AND ROWNUMBER <= @To

 END