﻿CREATE PROCEDURE [examrequest].[USP_RECENTEXAMREQUEST_GETBYIDS]
(
	@EXAMREQUESTLIST RecordIDs READONLY,
	@USERID AS CHAR(36) = NULL
)
AS
BEGIN

SELECT
	EXAMREQUEST.EXAMREQUESTID,
	EXAMREQUEST.REQUESTDATE,
	EXAMREQUEST.REQUESTNUMBER,
	EXAMREQUEST.SPECIALSITTING,
	EXAMREQUEST.LOCATIONDETAILS,
	EXAMREQUEST.LINKNUMBER,
	EXAMREQUEST.ROWVERSION,
	EXAMLINK.NAME LINKTYPE,
	EXAMTYPE.NAME TYPENAME,
	EXAMLOCATION.NAME LOCATIONNAME,
	EXAMFORMATTYPE.NAME FORMATTYPENAME,
	EXAMTIMESLOT.NAME TIMESLOTNAME,
	EXAMREQUESTWFXREF.EXAMREQUESTWFXREFID AS EXAMREQUESTWFXREFID,
	[USERS].[FNAME],
    [USERS].[LNAME]
FROM EXAMREQUEST
INNER JOIN EXAMLINK ON EXAMLINK.EXAMLINKID = EXAMREQUEST.EXAMLINKID
INNER JOIN EXAMTYPE ON EXAMTYPE.EXAMTYPEID = EXAMREQUEST.EXAMTYPEID
INNER JOIN EXAMLOCATION ON EXAMLOCATION.EXAMLOCATIONID = EXAMREQUEST.EXAMLOCATIONID
INNER JOIN EXAMFORMATTYPE ON EXAMFORMATTYPE.EXAMFORMATTYPEID = EXAMREQUEST.EXAMFORMATTYPEID
INNER JOIN EXAMTIMESLOT ON EXAMTIMESLOT.EXAMTIMESLOTID = EXAMREQUEST.EXAMTIMESLOTID
INNER JOIN @EXAMREQUESTLIST EXAMREQUESTLIST ON EXAMREQUEST.EXAMREQUESTID = EXAMREQUESTLIST.RECORDID
LEFT OUTER JOIN RECENTHISTORYEXAMREQUEST ON RECENTHISTORYEXAMREQUEST.EXAMREQUESTID = EXAMREQUEST.EXAMREQUESTID AND RECENTHISTORYEXAMREQUEST.USERID = @USERID
LEFT JOIN EXAMREQUESTWFXREF ON EXAMREQUESTWFXREF.EXAMREQUESTID = EXAMREQUEST.EXAMREQUESTID
LEFT OUTER JOIN [dbo].[USERS] ON [RECENTHISTORYEXAMREQUEST].[USERID] = [USERS].[SUSERGUID] AND [RECENTHISTORYEXAMREQUEST].[USERID] = @USERID
ORDER BY RECENTHISTORYEXAMREQUEST.LOGGEDDATETIME DESC

END