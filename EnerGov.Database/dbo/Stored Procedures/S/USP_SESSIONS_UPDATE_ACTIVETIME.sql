﻿CREATE PROCEDURE [dbo].[USP_SESSIONS_UPDATE_ACTIVETIME]
  @ActiveTime DATETIME,
  @SessionId CHAR(36)  
AS
BEGIN
  UPDATE SESSIONS SET ACTIVETIME = @ActiveTime WHERE SESSIONID = @SessionId
END