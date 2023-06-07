﻿CREATE PROCEDURE [dbo].[USP_SESSIONS_AND_SESSIONRECORD_DELETE_BY_SESSIONID]
  @SessionId CHAR(36)
AS
BEGIN
  DELETE FROM SESSIONRECORD WHERE SESSIONID = @SessionId
  DELETE FROM SESSIONS WHERE SESSIONID = @SessionId
END