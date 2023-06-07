﻿CREATE PROCEDURE [systemsettingsmanager].[USP_RECENTHISTORYSYSTEMSETUP_UPDATEORINSERT]    
(
@RECENTHISTORYMODULEID AS INT,
@ENTITYID AS CHAR(36),
@USERID AS CHAR(36)
)
AS    
BEGIN
DECLARE @CURRENTLOGGEDDATEONLY AS DATETIME = CONVERT(VARCHAR(10), GETDATE(), 121) -- Getting the Current Date Only
DECLARE @CURRENTLOGGEDDATETIME AS DATETIME = GETDATE()

 IF EXISTS(SELECT 1 FROM RECENTHISTORYSYSTEMSETUP WHERE ENTITYID = @ENTITYID AND USERID = @USERID AND RECENTHISTORYMODULEID = @RECENTHISTORYMODULEID)
 BEGIN
	UPDATE RECENTHISTORYSYSTEMSETUP SET LOGGEDDATETIME = @CURRENTLOGGEDDATETIME, LOGGEDDATEONLY = @CURRENTLOGGEDDATEONLY WHERE ENTITYID = @ENTITYID AND USERID = @USERID AND RECENTHISTORYMODULEID = @RECENTHISTORYMODULEID
 END
 ELSE
 BEGIN
	DELETE FROM RECENTHISTORYSYSTEMSETUP WHERE USERID = @USERID AND RECENTHISTORYMODULEID = @RECENTHISTORYMODULEID AND ENTITYID NOT IN (SELECT TOP 14 ENTITYID FROM RECENTHISTORYSYSTEMSETUP WHERE USERID = @USERID ORDER BY LOGGEDDATETIME DESC)
	INSERT INTO RECENTHISTORYSYSTEMSETUP(RECENTHISTORYMODULEID, ENTITYID, LOGGEDDATETIME, LOGGEDDATEONLY, USERID, ISEDITED) VALUES (@RECENTHISTORYMODULEID, @ENTITYID, @CURRENTLOGGEDDATETIME, @CURRENTLOGGEDDATEONLY, @USERID, 0)
 END
END