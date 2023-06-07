﻿CREATE PROCEDURE [managemyreview].[USP_PLITEMREVIEW_GETBYASSIGNEDUSERS_FACETS_REVIEWTYPE]
(
		@ITEMREVIEWLIST RecordIDs READONLY
)
AS
BEGIN
SET NOCOUNT ON;

SELECT		PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID AS ID
			, PLITEMREVIEWTYPE.NAME
			, COUNT(*) COUNT
FROM		PLITEMREVIEW
INNER JOIN	@ITEMREVIEWLIST ON PLITEMREVIEW.PLITEMREVIEWID = RECORDID
INNER JOIN	PLITEMREVIEWTYPE ON PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID = PLITEMREVIEW.PLITEMREVIEWTYPEID
GROUP BY PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID, PLITEMREVIEWTYPE.NAME
ORDER BY COUNT(*) DESC, ID, NAME

END