﻿CREATE PROCEDURE [dbo].[USP_COHIDDENCONTACTTYPE_GETBYROLEID]
(
  @ROLEID AS CHAR(36)
)
AS
BEGIN

SELECT 
	[dbo].[COHIDDENCONTACTTYPE].[COHIDDENCONTACTTYPEID],
	[dbo].[COHIDDENCONTACTTYPE].[SYSTEMMODULEID], 
	[dbo].[COHIDDENCONTACTTYPE].[SROLEGUID], 
	[dbo].[COHIDDENCONTACTTYPE].[CONTACTTYPEID] 
FROM [dbo].[COHIDDENCONTACTTYPE]
WHERE [dbo].[COHIDDENCONTACTTYPE].[SROLEGUID] = @ROLEID

END