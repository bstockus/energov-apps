﻿CREATE PROCEDURE [dbo].[USP_USERNOTIFICATION_GET_COUNT_OF_NOT_READ_OF_USER]
  @UserId CHAR(36)
AS
BEGIN
  SELECT COUNT(NOTIFICATIONSID) 
    FROM [USERNOTIFICATION]
   WHERE [USERID] = @UserId 
     AND [DATEREAD] IS NULL
END