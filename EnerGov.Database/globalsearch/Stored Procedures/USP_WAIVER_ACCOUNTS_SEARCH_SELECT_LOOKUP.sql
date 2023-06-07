﻿CREATE PROCEDURE [globalsearch].[USP_WAIVER_ACCOUNTS_SEARCH_SELECT_LOOKUP]
(
	@SEARCH AS NVARCHAR(MAX) = '',
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10,
	@ISACTIVE AS BIT = NULL,-- NULL => ALL |  1 => ACTIVE | 0=>INACTIVE
	@EXISTINGACCOUNTWAIVERIDS RECORDIDS READONLY -- Existing Accounts Waiver IDS
)
AS
BEGIN
SET NOCOUNT ON;

WITH RAW_DATA AS(
	SELECT [dbo].[GLOBALENTITYACCOUNTWAIVER].[GLOBALENTITYACCOUNTWAIVERID],
			[dbo].[GLOBALENTITYACCOUNT].[GLOBALENTITYACCOUNTID],
			[dbo].[GLOBALENTITYACCOUNT].[NAME],
			[dbo].[GLOBALENTITYACCOUNT].[ACCOUNTNUMBER],
			[dbo].[GLOBALENTITYACCOUNT].[DESCRIPTION],
			[dbo].[GLOBALENTITYACCOUNT].[ACTIVE],
			[dbo].[GLOBALENTITYACCOUNT].[ROWVERSION] AS ACCOUNTROWVERSION,
			[dbo].[GLOBALENTITYACCOUNT].[GLOBALENTITYACCOUNTTYPEID],
			[dbo].[GLOBALENTITYACCOUNTTYPE].[TYPENAME],
			[dbo].[GLOBALENTITYACCOUNTWAIVER].[APPROVEDWAIVERAMOUNT],
			[dbo].[GLOBALENTITYACCOUNTWAIVER].[CREDITSTODATE],
			[dbo].[GLOBALENTITYACCOUNTWAIVER].[EXPIRATIONDATE],
			[dbo].[GLOBALENTITYACCOUNTWAIVER].[APPLYTOAPPLICATIONFEES],
			[dbo].[GLOBALENTITYACCOUNTWAIVER].[APPLYTOBUSINESSLICENSEFEES],
			[dbo].[GLOBALENTITYACCOUNTWAIVER].[APPLYTOPERMITFEES],
			[dbo].[GLOBALENTITYACCOUNTWAIVER].[APPLYTOPLANFEES],
			[dbo].[GLOBALENTITYACCOUNTWAIVER].[APPLYTOPROJECTFEES],
			[dbo].[GLOBALENTITYACCOUNTWAIVER].[ROWVERSION] AS WAIVERROWVERSION

	FROM  [dbo].[GLOBALENTITYACCOUNTWAIVER] WITH (NOLOCK)
	INNER JOIN [dbo].[GLOBALENTITYACCOUNT] WITH (NOLOCK) ON [dbo].[GLOBALENTITYACCOUNTWAIVER].[GLOBALENTITYACCOUNTID] = [dbo].[GLOBALENTITYACCOUNT].[GLOBALENTITYACCOUNTID]
	INNER JOIN GLOBALENTITYACCOUNTTYPE WITH (NOLOCK) ON [dbo].[GLOBALENTITYACCOUNT].[GLOBALENTITYACCOUNTTYPEID] = [dbo].[GLOBALENTITYACCOUNTTYPE].[GLOBALENTITYACCOUNTTYPEID]
	LEFT JOIN @EXISTINGACCOUNTWAIVERIDS EXISTINGACCOUNTWAIVERIDLIST ON [dbo].[GLOBALENTITYACCOUNTWAIVER].[GLOBALENTITYACCOUNTWAIVERID] = [EXISTINGACCOUNTWAIVERIDLIST].[RECORDID]
	WHERE [dbo].[GLOBALENTITYACCOUNTTYPE].[ISFEEWAIVERACCOUNT] = 1
	AND ([dbo].[GLOBALENTITYACCOUNT].[NAME] LIKE '%'+ @SEARCH +'%'
		OR [dbo].[GLOBALENTITYACCOUNT].[ACCOUNTNUMBER] LIKE '%'+ @SEARCH +'%'
		OR [dbo].[GLOBALENTITYACCOUNT].[DESCRIPTION] LIKE '%'+ @SEARCH +'%'
		OR [dbo].[GLOBALENTITYACCOUNTTYPE].[TYPENAME] LIKE '%'+ @SEARCH +'%'
		)
	AND (@ISACTIVE IS NULL OR (@ISACTIVE IS NOT NULL AND [dbo].[GLOBALENTITYACCOUNT].[ACTIVE] = @ISACTIVE))
	AND [EXISTINGACCOUNTWAIVERIDLIST].[RECORDID] IS NULL
	)
	SELECT *,
		ROW_NUMBER() OVER(ORDER BY [NAME]) RowNumber,
		COUNT(1) OVER() AS TotalRows
	INTO #RESULT_DATA 
		FROM RAW_DATA;

SELECT * FROM #RESULT_DATA
WHERE
		RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
		RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY 
		RowNumber
END