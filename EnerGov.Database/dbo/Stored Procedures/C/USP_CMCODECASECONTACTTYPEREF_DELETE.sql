﻿CREATE PROCEDURE [dbo].[USP_CMCODECASECONTACTTYPEREF_DELETE]
(
@CONTACTTYPEEXTID CHAR(36)
)
AS
DELETE FROM [dbo].[CMCODECASECONTACTTYPEREF]
WHERE
	[CONTACTTYPEEXTID] = @CONTACTTYPEEXTID