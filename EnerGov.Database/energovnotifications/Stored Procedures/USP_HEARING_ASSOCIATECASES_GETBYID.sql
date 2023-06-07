﻿CREATE PROCEDURE [energovnotifications].[USP_HEARING_ASSOCIATECASES_GETBYID]
(
	@HEARINGID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
DECLARE @OBJECTLIST AS RecordIDs
DECLARE @HEARINGTYPEID AS CHAR(36)
DECLARE @STARTDATE AS DATE
SELECT 
	@HEARINGTYPEID=[dbo].[HEARING].[HEARINGTYPEID],
	@STARTDATE=[dbo].[HEARING].[STARTDATE]
FROM [dbo].[HEARING]
WHERE [dbo].[HEARING].[HEARINGID] = @HEARINGID

INSERT INTO @OBJECTLIST (RECORDID) 
	  SELECT DISTINCT [dbo].[HEARINGXREF].OBJECTID FROM [dbo].[HEARING]
       INNER JOIN [dbo].[HEARINGTYPE] ON [dbo].[HEARINGTYPE].[HEARINGTYPEID] = [dbo].[HEARING].[HEARINGTYPEID]
       INNER JOIN [dbo].[HEARINGXREF] ON [dbo].[HEARINGXREF].[HEARINGID] = [dbo].[HEARING].[HEARINGID]
	   INNER JOIN [dbo].[HEARINGATTENDEE] on [dbo].[HEARINGATTENDEE].[HEARINGID] =  [dbo].[HEARING].[HEARINGID] 
	   INNER JOIN [dbo].[USERS] on [dbo].[USERS].[SUSERGUID] = [dbo].[HEARINGATTENDEE].[ATTENDEEID] 
       WHERE [dbo].[HEARINGTYPE].[HEARINGTYPEID] =@HEARINGTYPEID AND CAST([dbo].[HEARING].[STARTDATE] AS DATE) = @STARTDATE

	EXEC [energovnotifications].[USP_ASSOCIATECASES_BYIDS] @OBJECTLIST  
END