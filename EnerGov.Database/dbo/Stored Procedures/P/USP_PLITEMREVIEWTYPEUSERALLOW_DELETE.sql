﻿CREATE PROCEDURE [dbo].[USP_PLITEMREVIEWTYPEUSERALLOW_DELETE]
(
@PLITEMREVIEWTYPEUSERALLOWID CHAR(36)
)
AS
DELETE FROM [dbo].[PLITEMREVIEWTYPEUSERALLOW]
WHERE
	[PLITEMREVIEWTYPEUSERALLOWID] = @PLITEMREVIEWTYPEUSERALLOWID