﻿CREATE PROCEDURE [dbo].[LINKED_PERMITS_DETAIL]
	@ENTITY_ID as char(36),
	@MODULE_TYPE as char(36),
	@FROM INT = 1,
	@TO INT,
	@PAGE_SIZE INT = 20,
	@SORT_FIELD char(36),
	@IS_ASC BIT = 1,
	@USER_ID as char(36)

AS
declare @DATA TABLE 
(
	PMPERMITID char(36),
	ISCHILD BIT,
	ISPARENT BIT
)
	IF (@MODULE_TYPE = 'PermitManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPERMITFROMPERMIT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'PlanManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPERMITFROMPLAN(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'CodeManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPERMITFROMCODECASE(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'BusinessLicenseManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPERMITFROMBUSINESSLICENSE(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ContactManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPERMITFROMCONTACT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ProjectManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPERMITFROMPROJECT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'PropertyManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPERMITFROMPROPERTYMANAGEMENT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'IndividualLicense')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPERMITFROMPROFESSIONALLICENSE(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ApplicationManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPERMITFROMAPPLICATION(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ImpactManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPERMITFROMIMPACTCASE(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ObjectManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPERMITFROMOBJECTCASE(@ENTITY_ID, @USER_ID)
	END
BEGIN
		with LINKEDPERMITS AS(select PMPERMITID, ISCHILD,ISPARENT FROM @DATA), 
		ALLPERMITDETAILS as (Select PMPERMIT.PERMITNUMBER, PMPERMITSTATUS.NAME AS PERMITSTATUS, PMPERMIT.PMPERMITTYPEID,  
		PMPERMITTYPE.NAME AS PERMITTYPE, PMPERMITWORKCLASS.NAME AS WORKCLASS, PMPERMIT.APPLYDATE, PMPERMIT.EXPIREDATE, PMPERMIT.FINALIZEDATE,  
		PMPERMIT.PMPERMITID, PMPERMIT.DESCRIPTION, MAILINGADDRESS.UNITORSUITE,  
		MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.STREETTYPE,  
		PRPROJECT.NAME AS PROJECTNAME FROM PMPERMIT  
		INNER JOIN PMPERMITSTATUS ON PMPERMIT.PMPERMITSTATUSID = PMPERMITSTATUS.PMPERMITSTATUSID  
		INNER JOIN PMPERMITTYPE ON PMPERMIT.PMPERMITTYPEID = PMPERMITTYPE.PMPERMITTYPEID  
		INNER JOIN PMPERMITWORKCLASS ON PMPERMIT.PMPERMITWORKCLASSID = PMPERMITWORKCLASS.PMPERMITWORKCLASSID  
		LEFT JOIN PMPERMITADDRESS ON PMPERMITADDRESS.PMPERMITID = PMPERMIT.PMPERMITID AND PMPERMITADDRESS.MAIN = 1  
		LEFT JOIN MAILINGADDRESS ON MAILINGADDRESS.MAILINGADDRESSID = PMPERMITADDRESS.MAILINGADDRESSID  
		LEFT JOIN PRPROJECTPERMIT ON PRPROJECTPERMIT.PMPERMITID = PMPERMIT.PMPERMITID  
		LEFT JOIN PRPROJECT ON PRPROJECT.PRPROJECTID = PRPROJECTPERMIT.PRPROJECTID  
		WHERE PMPERMIT.PMPERMITID in (SELECT PMPERMITID FROM LINKEDPERMITS)), 
		NUMBEREDDATA as ( select PERMITNUMBER, PERMITSTATUS, PMPERMITTYPEID, PERMITTYPE, WORKCLASS, APPLYDATE, EXPIREDATE, FINALIZEDATE, LINKEDPERMITS.PMPERMITID, LINKEDPERMITS.ISCHILD,LINKEDPERMITS.ISPARENT,  
		DESCRIPTION, UNITORSUITE, ADDRESSLINE1, ADDRESSLINE2, PREDIRECTION, POSTDIRECTION, STREETTYPE, PROJECTNAME, ROW_NUMBER() OVER(ORDER BY  
		case when @is_asc = 1 AND @Sort_Field = 'PERMITNUMBER' then PERMITNUMBER END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'PERMITNUMBER' then PERMITNUMBER END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'PERMITSTATUS' then PERMITSTATUS END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'PERMITSTATUS' then PERMITSTATUS END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'PERMITTYPE' then PERMITTYPE END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'PERMITTYPE' then PERMITTYPE END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'WORKCLASS' then WORKCLASS END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'WORKCLASS' then WORKCLASS END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'APPLYDATE' then APPLYDATE END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'APPLYDATE' then APPLYDATE END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'EXPIREDATE' then EXPIREDATE END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'EXPIREDATE' then EXPIREDATE END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'FINALIZEDATE' then FINALIZEDATE END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'FINALIZEDATE' then FINALIZEDATE END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'DESCRIPTION' then DESCRIPTION END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'DESCRIPTION' then DESCRIPTION END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'UNITORSUITE' then UNITORSUITE END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'UNITORSUITE' then UNITORSUITE END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'ADDRESSLINE1' then ADDRESSLINE1 END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'ADDRESSLINE1' then ADDRESSLINE1 END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'PROJECTNAME' then PROJECTNAME END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'PROJECTNAME' then PROJECTNAME END DESC) 
		AS ROWNUMBER, COUNT(1) OVER() AS TOTAL_ROWS from ALLPERMITDETAILS INNER JOIN LINKEDPERMITS on ALLPERMITDETAILS.PMPERMITID = LINKEDPERMITS.PMPERMITID)  
		select * from NUMBEREDDATA WHERE ROWNUMBER > @From AND ROWNUMBER <= @To
END