﻿CREATE PROCEDURE [energovnotifications].[USP_HEARING_GETBYID]
(
	@HEARINGID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT  
	[dbo].[HEARING].[HEARINGID], 
	[dbo].[HEARING].[HEARINGTYPEID], 
	[dbo].[HEARING].[SUBJECT], 
	[dbo].[HEARING].[LOCATION], 
	[dbo].[HEARING].[COMMENTS], 
	[dbo].[HEARING].[STARTDATE], 
	[dbo].[HEARING].[ENDDATE], 
	[dbo].[HEARING].[HEARINGSTATUSID],
	[dbo].[HEARING].[LASTCHANGEDBY],
	[dbo].[HEARING].[LASTCHANGEDON],
	[dbo].[HEARING].[ROWVERSION],
	CAST(CASE WHEN [dbo].[HEARINGTYPE].[RECURRENCEID] IS NULL THEN 0 ELSE 1 END AS BIT) AS ISRECURRENCE
FROM 
	[dbo].[HEARING] INNER JOIN [dbo].[HEARINGTYPE] 
	ON [dbo].[HEARING].[HEARINGTYPEID] = [dbo].[HEARINGTYPE].[HEARINGTYPEID]
WHERE 
	[dbo].[HEARING].[HEARINGID] = @HEARINGID
	EXEC [energovnotifications].[USP_HEARING_ASSOCIATECASES_GETBYID] @HEARINGID
END