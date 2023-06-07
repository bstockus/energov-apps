﻿CREATE PROCEDURE [dbo].[USP_IPUNITTYPE_DELETE]
(
	@IPUNITTYPEID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[IPUNITTYPE]
WHERE
	[IPUNITTYPEID] = @IPUNITTYPEID AND 
	[ROWVERSION]= @ROWVERSION