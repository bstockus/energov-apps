﻿CREATE PROCEDURE [dbo].[USP_ROLESSETTING_GETBYROLEID]
(
  @ROLEID AS CHAR(36)
)
AS
BEGIN

SELECT @ROLEID
EXEC [dbo].[USP_ROLESROLESSETTING_GETBYROLEID] @ROLEID
EXEC [dbo].[USP_COHIDDENCONTACTTYPE_GETBYROLEID] @ROLEID
END