﻿CREATE PROCEDURE [dbo].[USP_RPCONTACTTYPE_DELETE]
(
	@RPCONTACTTYPEID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[RPCONTACTTYPE]
WHERE
	[RPCONTACTTYPEID] = @RPCONTACTTYPEID AND 
	[ROWVERSION]= @ROWVERSION