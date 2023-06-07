﻿CREATE PROCEDURE [globalsearch].[USP_INVOICE_MISCELLANEOUS_FEE_SEARCH]
	@FEE_NAME nvarchar(100),
	@FEE_DATE datetime,
	@FEE_ID char(36),
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10
AS
		BEGIN

		WITH RAW_DATA AS (
			SELECT 
				[dbo].[CAFEE].CAFEEID, 
				[dbo].[CAFEE].NAME, 
				[dbo].[CAFEE].DESCRIPTION, 
				[dbo].[CAFEE].ISTAXFEE, 
				[dbo].[CAFEE].ISARFEE, 
				[dbo].[CAFEE].ACTIVE, 
				[dbo].[CAFEE].CACOMPUTATIONTYPEID, 
				[dbo].[CAFEESETUP].AMOUNT, 
				[dbo].CASCHEDULE.NAME FEESCHEDULENAME,
				[dbo].[CAFEESETUP].CAFEESETUPID,
				[dbo].[CAFEESETUP].COMPUTATIONVALUENAME,	
				ROW_NUMBER() OVER(ORDER BY [CAFEE].NAME) As RowNumber, 
				COUNT(1) OVER() AS TotalRows FROM [dbo].[CAFEE]
				JOIN [dbo].[CAMODULEFEEXREF] ON [dbo].[CAFEE].CAFEEID = [dbo].[CAMODULEFEEXREF].CAFEEID
				JOIN [dbo].[CAFEESETUP] ON [dbo].[CAFEE].CAFEEID = [dbo].[CAFEESETUP].CAFEEID
				JOIN (SELECT [dbo].[CAFEE].CAFEEID, count(*) AS Total FROM [dbo].[CAFEE]
					JOIN [dbo].[CAFEESETUP] ON [dbo].[CAFEE].CAFEEID = [dbo].[CAFEESETUP].CAFEEID
					JOIN CAMODULEFEEXREF ON [dbo].[CAFEE].CAFEEID = [dbo].CAMODULEFEEXREF.CAFEEID
					LEFT JOIN [dbo].CASCHEDULE ON [dbo].[CAFEESETUP].CASCHEDULEID = [dbo].CASCHEDULE.CASCHEDULEID
					WHERE [dbo].[CAFEE].ACTIVE = 1 AND [dbo].CAMODULEFEEXREF.CAMODULEID = 4 -- active and cashier module fees
					GROUP BY [dbo].[CAFEE].CAFEEID) CAFees ON CAFEE.CAFEEID = CAFees.CAFEEID
				LEFT JOIN [dbo].[CASCHEDULE] ON [dbo].[CAFEESETUP].CASCHEDULEID = [dbo].[CASCHEDULE].CASCHEDULEID
				WHERE [dbo].[CAFEE].ACTIVE = 1 AND [dbo].[CAMODULEFEEXREF].CAMODULEID = 4 AND -- active and cashier module fees
					([dbo].[CASCHEDULE].CASCHEDULEID IS NULL OR (@FEE_DATE >= [dbo].[CASCHEDULE].STARTDATE AND @FEE_DATE <= [dbo].[CASCHEDULE].ENDDATE)) AND
					(@FEE_NAME is null OR @FEE_NAME = '' OR [dbo].[CAFEE].NAME like '%' + @FEE_NAME + '%') AND
					(@FEE_ID IS NULL OR @FEE_ID = '' OR [dbo].[CAFEE].CAFEEID = @FEE_ID) AND
					(CAFees.Total = 1 OR ([dbo].CASCHEDULE.CASCHEDULEID IS NOT NULL AND CAFees.Total > 1))
		)

		SELECT 
			CAFEEID, 
			NAME, 
			DESCRIPTION, 
			ISTAXFEE, 
			ISARFEE, 
			ACTIVE, 
			CACOMPUTATIONTYPEID, 
			AMOUNT, 
			FEESCHEDULENAME, 
			CAFEESETUPID, 
			COMPUTATIONVALUENAME,
			RowNumber, 
			TotalRows
		FROM RAW_DATA
		WHERE
			RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
			RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
		ORDER BY RowNumber
	END