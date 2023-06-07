﻿CREATE PROCEDURE [dbo].[USP_CMCODECASEHOLDTYPECONTACTTYPEREF_DELETE_BYPARENTIDS]
(
	@PARENTIDS RECORDIDS READONLY
)
AS
BEGIN

DELETE FROM [dbo].[CMCODECASEHOLDTYPECONTACTTYPEREF]
WHERE [CMCODECASEHOLDTYPEID] IN (SELECT RECORDID FROM  @PARENTIDS)  

END