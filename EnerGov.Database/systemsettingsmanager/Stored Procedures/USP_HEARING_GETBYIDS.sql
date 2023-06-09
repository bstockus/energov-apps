﻿CREATE PROCEDURE [systemsettingsmanager].[USP_HEARING_GETBYIDS]
(
	@RECENTHEARINGLIST RecordIDs READONLY,
	@USERID AS CHAR(36) = NULL
)
AS
BEGIN

SELECT 
	[dbo].[HEARING].[HEARINGID],
	[dbo].[HEARING].[HEARINGTYPEID],
	[dbo].[HEARINGTYPE].[NAME] AS [HEARINGTYPENAME],
	[dbo].[HEARING].[HEARINGSTATUSID],
	[dbo].[HEARINGSTATUS].[NAME] AS [HEARINGSTATUSNAME],
	[dbo].[HEARING].[SUBJECT],
	[dbo].[HEARING].[LOCATION],
	[dbo].[HEARING].[COMMENTS],
	[dbo].[HEARING].[STARTDATE],
	[dbo].[HEARING].[ENDDATE],
	[dbo].[HEARING].[ROWVERSION],
	[dbo].[HEARING].[EXCHANGEITEMID],
	[dbo].[HEARING].[SHOWONCALENDAR]
FROM [dbo].[HEARING] 
INNER JOIN @RECENTHEARINGLIST HEARINGLIST ON [dbo].[HEARING].[HEARINGID] = HEARINGLIST.RECORDID
INNER JOIN HEARINGTYPE ON [dbo].[HEARING].[HEARINGTYPEID] = [dbo].[HEARINGTYPE].[HEARINGTYPEID]
INNER JOIN HEARINGSTATUS ON [dbo].[HEARING].[HEARINGSTATUSID] = [dbo].[HEARINGSTATUS].[HEARINGSTATUSID]

END