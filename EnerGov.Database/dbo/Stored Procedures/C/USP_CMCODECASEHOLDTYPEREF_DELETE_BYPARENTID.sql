﻿CREATE PROCEDURE [dbo].[USP_CMCODECASEHOLDTYPEREF_DELETE_BYPARENTID]
(
@PARENTID CHAR(36)
)
AS
BEGIN

DECLARE @PARENTIDLIST RECORDIDS
INSERT INTO @PARENTIDLIST(RECORDID)
SELECT [CMCODECASEHOLDTYPEID] FROM [dbo].[CMCODECASEHOLDTYPEREF]
WHERE [CMCASETYPEID] = @PARENTID  

EXEC [dbo].[USP_CMCODECASEHOLDTYPECONTACTTYPEREF_DELETE_BYPARENTIDS] @PARENTIDLIST

DELETE FROM [dbo].[CMCODECASEHOLDTYPEREF]
WHERE [CMCASETYPEID] = @PARENTID  

END