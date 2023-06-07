﻿CREATE PROCEDURE [managemyreview].[USP_PLITEMREVIEW_GETBYASSIGNEDUSERS_FACETS_REVIEWSTATUS]
(
	@ITEMREVIEWLIST RecordIDs READONLY
)
AS
BEGIN
SET NOCOUNT ON;

SELECT		PLITEMREVIEWSTATUS.PLITEMREVIEWSTATUSID AS ID
			, PLITEMREVIEWSTATUS.NAME AS NAME
			, COUNT(*) COUNT
FROM		PLITEMREVIEW
INNER JOIN	@ITEMREVIEWLIST ON PLITEMREVIEW.PLITEMREVIEWID = RECORDID
INNER JOIN	PLITEMREVIEWSTATUS ON PLITEMREVIEWSTATUS.PLITEMREVIEWSTATUSID = PLITEMREVIEW.PLITEMREVIEWSTATUSID
GROUP BY PLITEMREVIEWSTATUS.PLITEMREVIEWSTATUSID, PLITEMREVIEWSTATUS.NAME
ORDER BY COUNT(*) DESC, ID, NAME

END