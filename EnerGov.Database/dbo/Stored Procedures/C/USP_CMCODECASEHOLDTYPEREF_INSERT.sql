﻿CREATE PROCEDURE [dbo].[USP_CMCODECASEHOLDTYPEREF_INSERT]
(
	@CMCODECASEHOLDTYPEID CHAR(36),
	@CMCASETYPEID CHAR(36),
	@HOLDSETUPID CHAR(36)
)
AS
BEGIN

INSERT INTO [dbo].[CMCODECASEHOLDTYPEREF](	
	[CMCODECASEHOLDTYPEID],
	[CMCASETYPEID],
	[HOLDSETUPID]
)

VALUES
(
	@CMCODECASEHOLDTYPEID,
	@CMCASETYPEID,
	@HOLDSETUPID
)

END