﻿CREATE PROCEDURE [dbo].[usp_ADVANCEDSEARCHCRITERIA_GetById]
(
	@ID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[ADVANCEDSEARCHCRITERIAID],
	[NAME],
	[DESCRIPTION],
	[USERID],
	[SHARED],
	[SEARCHMODULE],
	[PAGESIZE],
	[PAGENUMBER],
	[CREATEDON],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION],
	[CHILDMODULEPATH]
FROM [dbo].[ADVANCEDSEARCHCRITERIA]
WHERE
	[ADVANCEDSEARCHCRITERIAID] = @ID  

	EXEC USP_ADVANCEDSEARCHCRITERIASEARCHFIELD_GETBYPARENTID @ID

	EXEC USP_ADVANCEDSEARCHOUTPUTFIELD_GETBYPARENTID @ID

	EXEC USP_ADVANCEDSEARCHSORTFIELD_GETBYPARENTID @ID
END