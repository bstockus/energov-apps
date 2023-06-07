﻿CREATE PROCEDURE [dbo].[USP_COLICTYPECLASSREF_DELETE]
(
@COLICTYPEID CHAR(36),
@CLASSIFICATIONID CHAR(36)
)
AS
DELETE FROM [dbo].[COLICTYPECLASSREF]
WHERE
	[COLICTYPEID] = @COLICTYPEID AND 
	[CLASSIFICATIONID] = @CLASSIFICATIONID