﻿CREATE PROCEDURE [managemyreview].[USP_PLITEMREVIEW_GETBYASSIGNEDUSERS_FACETS_COMPLETEDDATE]
(
	@ITEMREVIEWLIST RecordIDs READONLY,
	@LAST30DAYS DATE = NULL,
	@LASTWEEKFIRSTDAY DATE = NULL,
	@LASTWEEKLASTDAY DATE = NULL,
	@THISWEEKFIRSTDAY DATE = NULL,
	@THISWEEKLASTDAY DATE = NULL,
	@THISWEEKLABEL VARCHAR(30) = NULL,
	@LASTWEEKLABEL VARCHAR(30) = NULL,
	@LAST30DAYSLABEL VARCHAR(30) = NULL	
)
AS
BEGIN
SET NOCOUNT ON;

IF (@THISWEEKLABEL IS NULL OR @THISWEEKLABEL = '')
	SET @THISWEEKLABEL = 'This Week'
IF (@LASTWEEKLABEL IS NULL OR @LASTWEEKLABEL = '')
	SET @LASTWEEKLABEL = 'Last Week'
IF (@LAST30DAYSLABEL IS NULL OR @LAST30DAYSLABEL = '')
	SET @LAST30DAYSLABEL = 'Last 30 Days'

SELECT		@THISWEEKLABEL AS ID
			, @THISWEEKLABEL AS NAME
			, COUNT(*) COUNT
FROM		PLITEMREVIEW
INNER JOIN	@ITEMREVIEWLIST ON PLITEMREVIEW.PLITEMREVIEWID = RECORDID
WHERE		COMPLETEDATE >= @THISWEEKFIRSTDAY AND COMPLETEDATE < @THISWEEKLASTDAY
UNION ALL
SELECT		@LASTWEEKLABEL AS ID
			, @LASTWEEKLABEL AS NAME
			, COUNT(*) COUNT
FROM		PLITEMREVIEW
INNER JOIN	@ITEMREVIEWLIST ON PLITEMREVIEW.PLITEMREVIEWID = RECORDID
WHERE		COMPLETEDATE >= @LASTWEEKFIRSTDAY AND COMPLETEDATE < @LASTWEEKLASTDAY
UNION ALL
SELECT		@LAST30DAYSLABEL AS ID
			, @LAST30DAYSLABEL AS NAME
			, COUNT(*) COUNT
FROM		PLITEMREVIEW
INNER JOIN	@ITEMREVIEWLIST ON PLITEMREVIEW.PLITEMREVIEWID = RECORDID
WHERE		COMPLETEDATE >= @LAST30DAYS
ORDER BY COUNT(*) DESC, ID, NAME

END