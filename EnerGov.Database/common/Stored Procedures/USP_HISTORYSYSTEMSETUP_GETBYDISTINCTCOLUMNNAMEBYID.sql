﻿CREATE PROCEDURE [common].[USP_HISTORYSYSTEMSETUP_GETBYDISTINCTCOLUMNNAMEBYID]
(	
	@RECORDID AS CHAR(36),
	@DISTINCTBYCOLUMN AS NVARCHAR(50) = '',
	@TIMEZONE_DIFFERENCE_IN_MINUTES AS FLOAT = 0
)
AS
BEGIN
	SELECT DISTINCT
		CASE
			WHEN @DISTINCTBYCOLUMN = 'ChangedOn' THEN CONVERT(NVARCHAR(MAX), DATEADD(MINUTE, @TIMEZONE_DIFFERENCE_IN_MINUTES, [dbo].[HISTORYSYSTEMSETUP].[CHANGEDON]), 101)
			WHEN @DISTINCTBYCOLUMN = 'User' THEN [dbo].[HISTORYSYSTEMSETUP].[CHANGEDBY]			
			WHEN @DISTINCTBYCOLUMN = 'Description' THEN [dbo].[HISTORYSYSTEMSETUP].[FIELDNAME]
		END AS COLUMNVALUE,
		CASE
			WHEN @DISTINCTBYCOLUMN = 'ChangedOn' THEN CONVERT(NVARCHAR(MAX), DATEADD(MINUTE, @TIMEZONE_DIFFERENCE_IN_MINUTES, [dbo].[HISTORYSYSTEMSETUP].[CHANGEDON]), 101)
			WHEN @DISTINCTBYCOLUMN = 'User' THEN ([dbo].[USERS].[LNAME] + COALESCE(', ' + [dbo].[USERS].[FNAME], ''))
			WHEN @DISTINCTBYCOLUMN = 'Description' THEN [dbo].[HISTORYSYSTEMSETUP].[FIELDNAME]
		END AS COLUMNDATA
	FROM [dbo].[HISTORYSYSTEMSETUP]
	INNER JOIN [dbo].[USERS] ON [dbo].[USERS].[SUSERGUID] = [dbo].[HISTORYSYSTEMSETUP].[CHANGEDBY]
	WHERE [dbo].[HISTORYSYSTEMSETUP].[ID] = @RECORDID
END