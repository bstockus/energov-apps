﻿CREATE PROCEDURE [globalsearch].[USP_LANDLORDLICENSE_SEARCH_SELECT_LOOKUP]
(
    @SEARCH AS NVARCHAR(MAX) = '',
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10,
	@SORT_FIELD AS NVARCHAR(50)='',
	@IS_ASCENDING AS BIT =0
)
AS
BEGIN
SET NOCOUNT ON;
;WITH RAW_DATA
    AS(        
		SELECT 
			[RPLANDLORDLICENSE].[RPLANDLORDLICENSEID],
			[RPLANDLORDLICENSE].[LANDLORDNUMBER],
			[GLOBALENTITY].[GLOBALENTITYNAME],
			[GLOBALENTITY].[FIRSTNAME],
			[GLOBALENTITY].[LASTNAME],
			(CASE WHEN @IS_ASCENDING =1 
				 THEN 
					CASE 
						WHEN @SORT_FIELD = 'landlordNumber' THEN ROW_NUMBER() OVER(ORDER BY [dbo].[RPLANDLORDLICENSE].[LANDLORDNUMBER] ASC)
						WHEN  @SORT_FIELD = 'companyName' THEN ROW_NUMBER() OVER(ORDER BY [dbo].[GLOBALENTITY].[GLOBALENTITYNAME] ASC)
						WHEN  @SORT_FIELD = 'firstName' THEN ROW_NUMBER() OVER(ORDER BY [dbo].[GLOBALENTITY].[FIRSTNAME] ASC)
						WHEN  @SORT_FIELD = 'lastName' THEN ROW_NUMBER() OVER(ORDER BY [dbo].[GLOBALENTITY].[LASTNAME] ASC)
						ELSE ROW_NUMBER() OVER(ORDER BY [dbo].[RPLANDLORDLICENSE].[LANDLORDNUMBER] ASC) 
					END
				 WHEN @IS_ASCENDING=0
				 THEN 
					CASE 
						WHEN @SORT_FIELD = 'landlordNumber' THEN ROW_NUMBER() OVER(ORDER BY [dbo].[RPLANDLORDLICENSE].[LANDLORDNUMBER] DESC)
						WHEN  @SORT_FIELD = 'companyName' THEN ROW_NUMBER() OVER(ORDER BY [dbo].[GLOBALENTITY].[GLOBALENTITYNAME] DESC)
						WHEN  @SORT_FIELD = 'firstName' THEN ROW_NUMBER() OVER(ORDER BY [dbo].[GLOBALENTITY].[FIRSTNAME] DESC)
						WHEN  @SORT_FIELD = 'lastName' THEN ROW_NUMBER() OVER(ORDER BY [dbo].[GLOBALENTITY].[LASTNAME] DESC)
						ELSE ROW_NUMBER() OVER(ORDER BY [dbo].[RPLANDLORDLICENSE].[LANDLORDNUMBER] DESC) 
					END
				 END) AS RowNumber,
				 COUNT(1) OVER() AS TotalRows
		FROM 
			[dbo].[RPLANDLORDLICENSE]
			INNER JOIN [dbo].[GLOBALENTITY] 
				ON  [RPLANDLORDLICENSE].[GLOBALENTITYID] = [GLOBALENTITY].[GLOBALENTITYID]
			INNER JOIN [dbo].[RPLANDLORDLICENSETYPE] WITH (NOLOCK) 
				ON [RPLANDLORDLICENSE].[RPLANDLORDLICENSETYPEID] = [RPLANDLORDLICENSETYPE].[RPLANDLORDLICENSETYPEID]
			INNER JOIN [dbo].[RPLANDLORDLICENSESTATUS] WITH (NOLOCK) 
				ON [RPLANDLORDLICENSE].[RPLANDLORDLICENSESTATUSID] = [RPLANDLORDLICENSESTATUS].[RPLANDLORDLICENSESTATUSID]
		WHERE 
				[RPLANDLORDLICENSE].[LANDLORDNUMBER] LIKE '%'+@SEARCH+'%' 
			OR	[GLOBALENTITY].[GLOBALENTITYNAME] LIKE '%'+@SEARCH+'%' 
			OR  [GLOBALENTITY].[FIRSTNAME] LIKE '%'+@SEARCH+'%' 
			OR  [GLOBALENTITY].[LASTNAME] LIKE '%'+@SEARCH+'%' 
)

SELECT * 
FROM RAW_DATA
WHERE
	RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
	RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY 
	RowNumber
END