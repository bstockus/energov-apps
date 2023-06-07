CREATE PROCEDURE [dbo].[USP_SESSIONS_INSERT_SESSIONS]
  @SessionId CHAR(36),
  @ActiveTime DATETIME,
  @LicenseSuite NVARCHAR(MAX),
  @UserGuid NVARCHAR(36)
AS
BEGIN
  INSERT INTO SESSIONS VALUES (@SessionId, @ActiveTime, @LicenseSuite, @UserGuid)
END