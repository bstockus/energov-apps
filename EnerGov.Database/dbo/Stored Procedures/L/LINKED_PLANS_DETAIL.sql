﻿CREATE PROCEDURE [dbo].[LINKED_PLANS_DETAIL]
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
	PLPLANID char(36),
	ISCHILD BIT,
	ISPARENT BIT
)
	IF (@MODULE_TYPE = 'PermitManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPLANFROMPERMIT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'PlanManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPLANFROMPLAN(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'CodeManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPLANFROMCODECASE(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'BusinessLicenseManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPLANFROMBUSINESSLICENSE(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ContactManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPLANFROMCONTACT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ProjectManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPLANFROMPROJECT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'PropertyManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPLANFROMPROPERTYMANAGEMENT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'IndividualLicense')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPLANFROMPROFESSIONALLICENSE(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ApplicationManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPLANFROMAPPLICATION(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ImpactManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPLANFROMIMPACTCASE(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ObjectManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPLANFROMOBJECTCASE(@ENTITY_ID, @USER_ID)
	END
BEGIN
WITH LINKEDPLANS AS(select PLPLANID, ISCHILD,ISPARENT FROM @DATA), 
ALLPLANDETAILS AS (
SELECT PLPLAN.PLANNUMBER, PLPLANSTATUS.NAME AS PLANSTATUS, 
PLPLAN.PLPLANTYPEID,PLPLANTYPE.PLANNAME AS PLANTYPE, PLPLANWORKCLASS.NAME AS WORKCLASS, PLPLAN.APPLICATIONDATE,
 PLPLAN.EXPIREDATE,PLPLAN.COMPLETEDATE,PLPLAN.PLPLANID, PLPLAN.DESCRIPTION, MAILINGADDRESS.UNITORSUITE,MAILINGADDRESS.ADDRESSLINE1, 
 MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.STREETTYPE, PRPROJECT.NAME AS PROJECTNAME 
 FROM PLPLAN INNER JOIN PLPLANSTATUS ON PLPLAN.PLPLANSTATUSID = PLPLANSTATUS.PLPLANSTATUSID 
 INNER JOIN PLPLANTYPE ON PLPLAN.PLPLANTYPEID = PLPLANTYPE.PLPLANTYPEID  
 INNER JOIN PLPLANWORKCLASS ON PLPLAN.PLPLANWORKCLASSID = PLPLANWORKCLASS.PLPLANWORKCLASSID
 LEFT JOIN PLPLANADDRESS ON PLPLAN.PLPLANID = PLPLANADDRESS.PLPLANID AND PLPLANADDRESS.MAIN = 1 
 LEFT JOIN MAILINGADDRESS ON PLPLANADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID 
 LEFT JOIN PRPROJECTPLAN ON PLPLAN.PLPLANID = PRPROJECTPLAN.PLPLANID
 LEFT JOIN PRPROJECT ON PRPROJECTPLAN.PRPROJECTID = PRPROJECT.PRPROJECTID WHERE PLPLAN.PLPLANID IN
 (SELECT PLPLANID FROM LINKEDPLANS)),
 NUMBEREDDATA AS
 (SELECT PLANNUMBER,PLANSTATUS,PLPLANTYPEID,PLANTYPE,WORKCLASS,APPLICATIONDATE,EXPIREDATE,COMPLETEDATE,LINKEDPLANS.PLPLANID,
 LINKEDPLANS.ISCHILD,LINKEDPLANS.ISPARENT,DESCRIPTION,UNITORSUITE, ADDRESSLINE1, ADDRESSLINE2, PREDIRECTION, POSTDIRECTION, STREETTYPE, PROJECTNAME,
 ROW_NUMBER() OVER(ORDER BY
 case when @is_asc = 1 AND @Sort_Field = 'PLANNUMBER' then PLANNUMBER END ASC,
 case when @is_asc = 0 AND @Sort_Field = 'PLANNUMBER' then PLANNUMBER END DESC,
 case when @is_asc = 1 AND @Sort_Field = 'PLANSTATUS' then PLANSTATUS END ASC, 
 case when @is_asc = 0 AND @Sort_Field = 'PLANSTATUS' then PLANSTATUS END DESC,
 case when @is_asc = 1 AND @Sort_Field = 'PLANTYPE' then PLANTYPE END ASC, 
 case when @is_asc = 0 AND @Sort_Field = 'PLANTYPE' then PLANTYPE END DESC,
 case when @is_asc = 1 AND @Sort_Field = 'WORKCLASS' then WORKCLASS END ASC, 
 case when @is_asc = 0 AND @Sort_Field = 'WORKCLASS' then WORKCLASS END DESC,
 case when @is_asc = 1 AND @Sort_Field = 'APPLICATIONDATE' then APPLICATIONDATE END ASC, 
 case when @is_asc = 0 AND @Sort_Field = 'APPLICATIONDATE' then APPLICATIONDATE END DESC,
 case when @is_asc = 1 AND @Sort_Field = 'EXPIREDATE' then EXPIREDATE END ASC, 
 case when @is_asc = 0 AND @Sort_Field = 'EXPIREDATE' then EXPIREDATE END DESC,
 case when @is_asc = 1 AND @Sort_Field = 'COMPLETEDATE' then COMPLETEDATE END ASC, 
 case when @is_asc = 0 AND @Sort_Field = 'COMPLETEDATE' then COMPLETEDATE END DESC,
 case when @is_asc = 1 AND @Sort_Field = 'DESCRIPTION' then DESCRIPTION END ASC, 
 case when @is_asc = 0 AND @Sort_Field = 'DESCRIPTION' then DESCRIPTION END DESC,
 case when @is_asc = 1 AND @Sort_Field = 'UNITORSUITE' then UNITORSUITE END ASC, 
 case when @is_asc = 0 AND @Sort_Field = 'UNITORSUITE' then UNITORSUITE END DESC,
 case when @is_asc = 1 AND @Sort_Field = 'ADDRESSLINE1' then ADDRESSLINE1 END ASC, 
 case when @is_asc = 0 AND @Sort_Field = 'ADDRESSLINE1' then ADDRESSLINE1 END DESC,
 case when @is_asc = 1 AND @Sort_Field = 'PROJECTNAME' then PROJECTNAME END ASC,
 case when @is_asc = 0 AND @Sort_Field = 'PROJECTNAME' then PROJECTNAME END DESC)
 AS ROWNUMBER, COUNT(1) OVER() AS TOTAL_ROWS from ALLPLANDETAILS 
 INNER JOIN LINKEDPLANS on ALLPLANDETAILS.PLPLANID = LINKEDPLANS.PLPLANID)
 select * from NUMBEREDDATA WHERE ROWNUMBER > @From AND ROWNUMBER <= @To

 END