﻿
CREATE PROCEDURE [dbo].[USP_PMCONTACTTYPEREF_DELETE]
(
@CONTACTTYPEEXTID CHAR(36)
)
AS
DELETE FROM [dbo].[PMCONTACTTYPEREF]
WHERE
	[CONTACTTYPEEXTID] = @CONTACTTYPEEXTID