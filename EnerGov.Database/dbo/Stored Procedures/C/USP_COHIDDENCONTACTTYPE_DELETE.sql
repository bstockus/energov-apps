﻿CREATE PROCEDURE [dbo].[USP_COHIDDENCONTACTTYPE_DELETE]
(
	@COHIDDENCONTACTTYPEID CHAR(36)
)
AS
	DELETE FROM [dbo].[COHIDDENCONTACTTYPE]
	WHERE [COHIDDENCONTACTTYPEID] = @COHIDDENCONTACTTYPEID