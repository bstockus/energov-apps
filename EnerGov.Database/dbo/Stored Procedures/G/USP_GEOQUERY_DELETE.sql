﻿CREATE PROCEDURE [dbo].[USP_GEOQUERY_DELETE]
(
	@GEOQUERYID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[GEOQUERY]
WHERE
	[GEOQUERYID] = @GEOQUERYID AND 
	[ROWVERSION]= @ROWVERSION