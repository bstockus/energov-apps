﻿CREATE PROCEDURE [dbo].[LINKED_IMPACT_CASES]
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
	IPCASEID char(36)	
)
	IF (@MODULE_TYPE = 'PermitManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDIMPACTCASESFROMPERMIT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'PlanManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDIMPACTCASESFROMPLAN(@ENTITY_ID, @USER_ID)
	END	
	IF (@MODULE_TYPE = 'ContactManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDIMPACTCASESFROMCONTACT(@ENTITY_ID, @USER_ID)
	END	
BEGIN
		with LINKEDIMPACTCASES AS(select IPCASEID FROM @DATA), 
		ALLIMPACTCASES as (Select IPCASEID, CASENUMBER,IPCASETYPE.NAME as TYPENAME, IPCASESTATUS.NAME as STATUS, CREATEDDATE, APPROVALDATE, APPROVALEXPIREDDATE  FROM IPCASE  
		INNER JOIN IPCASESTATUS on IPCASE.IPCASESTATUSID = IPCASESTATUS.IPCASESTATUSID
		INNER JOIN IPCASETYPE on IPCASE.IPCASETYPEID = IPCASETYPE.IPCASETYPEID
		WHERE IPCASE.IPCASEID in (SELECT IPCASEID FROM LINKEDIMPACTCASES)), 
		NUMBEREDDATA as ( select ALLIMPACTCASES.IPCASEID, CASENUMBER,TYPENAME, STATUS, CREATEDDATE, APPROVALDATE, APPROVALEXPIREDDATE, ROW_NUMBER() OVER(ORDER BY  
		case when @is_asc = 1 AND @Sort_Field = 'CASENUMBER' then CASENUMBER END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'CASENUMBER' then CASENUMBER END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'TYPENAME' then TYPENAME END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'TYPENAME' then TYPENAME END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'STATUS' then STATUS END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'STATUS' then STATUS END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'CREATEDDATE' then CREATEDDATE END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'CREATEDDATE' then CREATEDDATE END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'APPROVALDATE' then APPROVALDATE END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'APPROVALDATE' then APPROVALDATE END DESC, 
		case when @is_asc = 1 AND @Sort_Field = 'APPROVALEXPIREDDATE' then APPROVALEXPIREDDATE END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'APPROVALEXPIREDDATE' then APPROVALEXPIREDDATE END DESC) 
		AS ROWNUMBER, COUNT(1) OVER() AS TOTAL_ROWS from ALLIMPACTCASES INNER JOIN LINKEDIMPACTCASES on ALLIMPACTCASES.IPCASEID = LINKEDIMPACTCASES.IPCASEID)  
		select * from NUMBEREDDATA WHERE ROWNUMBER > @From AND ROWNUMBER <= @To
END