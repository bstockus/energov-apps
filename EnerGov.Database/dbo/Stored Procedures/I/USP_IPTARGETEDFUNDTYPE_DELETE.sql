﻿CREATE PROCEDURE [dbo].[USP_IPTARGETEDFUNDTYPE_DELETE]
(
	@IPTARGETEDFUNDTYPEID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[IPTARGETEDFUNDTYPE]
WHERE
	[IPTARGETEDFUNDTYPEID] = @IPTARGETEDFUNDTYPEID AND 
	[ROWVERSION]= @ROWVERSION