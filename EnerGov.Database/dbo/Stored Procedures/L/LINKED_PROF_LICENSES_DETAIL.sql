﻿CREATE PROCEDURE [dbo].[LINKED_PROF_LICENSES_DETAIL]
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
	ILLICENSEID char(36)
)
	IF (@MODULE_TYPE = 'PermitManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPROFLICENSEFROMPERMIT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'PlanManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPROFLICENSEFROMPLAN(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'CodeManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPROFLICENSEFROMCODECASE(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ContactManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPROFLICENSEFROMCONTACT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'PropertyManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDPROFLICENSEFROMPROPERTYMANAGEMENT(@ENTITY_ID, @USER_ID)
	END
BEGIN
		
		with LINKEDPROFLICENSES AS( select ILLICENSEID FROM @DATA), 
		ALLPROFLICENSES as (select ILLICENSEID, LICENSENUMBER, typeName.NAME as TYPENAME, classify.NAME  
		as CLASSIFICATION,status.NAME as STATUS, FIRSTNAME, LASTNAME, GLOBALENTITYNAME, LICENSEYEAR, APPLIEDDATE from ILLICENSE il  
		INNER JOIN ILLICENSETYPE typeNAME on il.ILLICENSETYPEID = typeNAME.ILLICENSETYPEID  
		INNER JOIN ILLICENSESTATUS status on il.ILLICENSESTATUSID = status.ILLICENSESTATUSID  
		INNER JOIN GLOBALENTITY holder on il.GLOBALENTITYID = holder.GLOBALENTITYID  
		INNER JOIN ILLICENSECLASSIFICATION classify on il.ILLICENSECLASSIFICATIONID = classify.ILLICENSECLASSIFICATIONID  
		where il.ILLICENSEID in (SELECT ILLICENSEID from LINKEDPROFLICENSES)),  
		NUMBEREDDATA as (select LINKEDPROFLICENSES.ILLICENSEID, LICENSENUMBER, TYPENAME, CLASSIFICATION, STATUS, FIRSTNAME, LASTNAME, GLOBALENTITYNAME, LICENSEYEAR, APPLIEDDATE,  
		ROW_NUMBER() OVER(ORDER BY  
		case when @is_asc = 1 AND @Sort_Field = 'LICENSENUMBER' then LICENSENUMBER END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'LICENSENUMBER' then LICENSENUMBER END DESC,  
		case when @is_asc = 1 AND @Sort_Field = 'TYPENAME' then TYPENAME END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'TYPENAME' then TYPENAME END DESC,  
		case when @is_asc = 1 AND @Sort_Field = 'CLASSIFICATION' then CLASSIFICATION END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'CLASSIFICATION' then CLASSIFICATION END DESC,  
		case when @is_asc = 1 AND @Sort_Field = 'STATUS' then STATUS END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'STATUS' then STATUS END DESC,  
		case when @is_asc = 1 AND @Sort_Field = 'FIRSTNAME' then FIRSTNAME END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'FIRSTNAME' then FIRSTNAME END DESC,  
		case when @is_asc = 1 AND @Sort_Field = 'LICENSEYEAR' then LICENSEYEAR END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'LICENSEYEAR' then LICENSEYEAR END DESC,  
		case when @is_asc = 1 AND @Sort_Field = 'APPLIEDDATE' then APPLIEDDATE END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'APPLIEDDATE' then APPLIEDDATE END DESC)  
		AS ROWNUMBER, COUNT(1) OVER() AS TOTAL_ROWS from ALLPROFLICENSES  
		INNER JOIN LINKEDPROFLICENSES on ALLPROFLICENSES.ILLICENSEID = LINKEDPROFLICENSES.ILLICENSEID)  
		select * from NUMBEREDDATA WHERE ROWNUMBER > @From AND ROWNUMBER <= @To 
END