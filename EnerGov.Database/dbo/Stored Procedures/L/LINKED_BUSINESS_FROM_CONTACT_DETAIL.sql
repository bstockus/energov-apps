CREATE PROCEDURE [dbo].[LINKED_BUSINESS_FROM_CONTACT_DETAIL]
	@ENTITY_ID as char(36),
	@FROM INT = 1,
	@TO INT,
	@PAGE_SIZE INT = 20,
	@SORT_FIELD char(36),
	@IS_ASC BIT = 1,
	@SUB_MODULE_TYPE INT=1

AS
declare @DATA TABLE 
(
	GlobalExtensionId char(36)
)
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDBUSSINESSFROMCONTACT(@ENTITY_ID, @SUB_MODULE_TYPE)
	END	
BEGIN		
		with  
		ALLBUSINESS as (select blx.BLGLOBALENTITYEXTENSIONID, blx.COMPANYNAME, blx.REGISTRATIONID as BUSINESSNUMBER, blx.DBA, bcType.NAME as COMPANYTYPE,
		bStatus.NAME as STATUS, blx.EINNUMBER, blx.OPENDATE, blx.CLOSEDATE
		from BLGLOBALENTITYEXTENSION blx
		INNER JOIN BLEXTCOMPANYTYPE bcType on blx.BLEXTCOMPANYTYPEID = bcType.BLEXTCOMPANYTYPEID  
		INNER JOIN BLEXTSTATUS bStatus on blx.BLEXTSTATUSID = bStatus.BLEXTSTATUSID  
		where blx.BLGLOBALENTITYEXTENSIONID in (Select GlobalExtensionId from @DATA)),  
		NUMBEREDDATA as (select BLGLOBALENTITYEXTENSIONID, COMPANYNAME, BUSINESSNUMBER,DBA, COMPANYTYPE, STATUS, EINNUMBER, OPENDATE, CLOSEDATE,  
		ROW_NUMBER() OVER(ORDER BY  
		case when @is_asc = 1 AND @Sort_Field = 'COMPANYNAME' then COMPANYNAME END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'COMPANYNAME' then COMPANYNAME END DESC,  
		case when @is_asc = 1 AND @Sort_Field = 'BUSINESSNUMBER' then BUSINESSNUMBER END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'BUSINESSNUMBER' then BUSINESSNUMBER END DESC,  
		case when @is_asc = 1 AND @Sort_Field = 'DBA' then DBA END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'DBA' then DBA END DESC,  
		case when @is_asc = 1 AND @Sort_Field = 'COMPANYTYPE' then COMPANYTYPE END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'COMPANYTYPE' then COMPANYTYPE END DESC,  
		case when @is_asc = 1 AND @Sort_Field = 'STATUS' then STATUS END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'STATUS' then STATUS END DESC,  
		case when @is_asc = 1 AND @Sort_Field = 'EINNUMBER' then EINNUMBER END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'EINNUMBER' then EINNUMBER END DESC,  
		case when @is_asc = 1 AND @Sort_Field = 'OPENDATE' then OPENDATE END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'OPENDATE' then OPENDATE END DESC,
		case when @is_asc = 1 AND @Sort_Field = 'CLOSEDATE' then CLOSEDATE END ASC,  
		case when @is_asc = 0 AND @Sort_Field = 'CLOSEDATE' then CLOSEDATE END DESC)  
		AS ROWNUMBER, COUNT(1) OVER() AS TOTAL_ROWS from ALLBUSINESS  )
		select * from NUMBEREDDATA WHERE ROWNUMBER > @From AND ROWNUMBER <= @To 
END