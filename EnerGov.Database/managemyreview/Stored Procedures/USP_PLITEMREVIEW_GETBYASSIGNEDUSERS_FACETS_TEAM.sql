﻿CREATE PROCEDURE [managemyreview].[USP_PLITEMREVIEW_GETBYASSIGNEDUSERS_FACETS_TEAM]
(
	@ITEMREVIEWLIST RecordIDs READONLY
)
AS
BEGIN
SET NOCOUNT ON;

SELECT	TEAM.TEAMID AS ID,
		TEAM.NAME AS TEAMNAME,
		COUNT(*) COUNT
FROM PLITEMREVIEW
JOIN @ITEMREVIEWLIST AS ITEMREVIEWLIST ON ITEMREVIEWLIST.RECORDID=PLITEMREVIEW.PLITEMREVIEWID
JOIN TEAM ON TEAM.TEAMID = PLITEMREVIEW.TEAMASSIGNEDTO
WHERE PLITEMREVIEW.ASSIGNEDUSERID IS NULL
GROUP BY TEAMID, TEAM.NAME


END