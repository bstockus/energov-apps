﻿CREATE PROCEDURE [dbo].[USP_TXRMTCONTACTTYPEREF_DELETE]
(
@CONTACTTYPEEXTID CHAR(36)
)
AS
DELETE FROM [dbo].[TXRMTCONTACTTYPEREF]
WHERE
	[CONTACTTYPEEXTID] = @CONTACTTYPEEXTID