CREATE PROCEDURE [dbo].[LINKED_RENEWAL_CASES]
	@ENTITY_ID as char(36),
	@MODULE_TYPE as char(36),
	@FROM INT = 0,
	@TO INT,
	@PAGE_SIZE INT = 20,
	@SORT_FIELD VARCHAR(36),
	@IS_ASC BIT = 1,
	@USER_ID as CHAR(36)
AS
declare @DATA TABLE 
(
	PMRENEWALCASEID char(36)
)
	IF (@MODULE_TYPE = 'PermitManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDRENEWALCASEFROMPERMIT(@ENTITY_ID,@USER_ID)
	END
	IF (@MODULE_TYPE = 'ContactManagement')
	BEGIN
		INSERT INTO @DATA
		SELECT * FROM DBO.LINKEDRENEWALCASEFROMCONTACT(@ENTITY_ID,@USER_ID)
	END
BEGIN
	WITH LinkedRenewalCases AS (select renewalCase.PMRENEWALCASEID,renewalCase.NUMBER,  caseType.NAME as CASETYPE, renewalCase.DESCRIPTION, 
	renewalCase.NEXTRENEWALDATE, renewalCase.NEXTINVOICEDATE, COUNT(1) OVER() AS TOTAL_ROWS from PMRENEWALCASE renewalCase
	INNER JOIN  PMRENEWALCASETYPE caseType on renewalCase.PMRENEWALCASETYPEID = caseType.PMRENEWALCASETYPEID  
	where PMRENEWALCASEID in (select PMRENEWALCASEID from @DATA)),
	 NUMBEREDDATA as (SELECT PMRENEWALCASEID, NUMBER, CASETYPE, DESCRIPTION, 
				  NEXTRENEWALDATE, NEXTINVOICEDATE, ROW_NUMBER() OVER(ORDER BY 
                        case when @is_asc = 1 AND @SORT_FIELD = 'NUMBER' then NUMBER END ASC, 
                        case when @is_asc = 0 AND @SORT_FIELD = 'NUMBER' then NUMBER END DESC, 
                        case when @is_asc = 1 AND @SORT_FIELD = 'CASETYPE' then CASETYPE END ASC, 
                        case when @is_asc = 0 AND @SORT_FIELD = 'CASETYPE' then CASETYPE END DESC, 
                        case when @is_asc = 1 AND @SORT_FIELD = 'DESCRIPTION' then DESCRIPTION END ASC, 
                        case when @is_asc = 0 AND @SORT_FIELD = 'DESCRIPTION' then DESCRIPTION END DESC, 
                        case when @is_asc = 1 AND @Sort_Field = 'NEXTRENEWALDATE' then NEXTRENEWALDATE END ASC, 
                        case when @is_asc = 0 AND @Sort_Field = 'NEXTRENEWALDATE' then NEXTRENEWALDATE END DESC, 
                        case when @is_asc = 1 AND @Sort_Field = 'NEXTINVOICEDATE' then NEXTINVOICEDATE END ASC, 
                        case when @is_asc = 0 AND @Sort_Field = 'NEXTINVOICEDATE' then NEXTINVOICEDATE END DESC) 
                        AS ROWNUMBER, COUNT(1) OVER() AS TOTAL_ROWS from LinkedRenewalCases) 
                        select * from NUMBEREDDATA WHERE ROWNUMBER > @FROM AND ROWNUMBER <= @TO
END