CREATE  PROCEDURE [systemsettingsmanager].[USP_TEAMRESOURCE_DELETE_BY_TEAMID]      
-- Add the parameters for the stored procedure here      
@TEAMID CHAR(36)  
AS      
BEGIN        
 DELETE FROM  [dbo].[TEAMRESOURCE]      
 WHERE [TEAMRESOURCE].[TEAMID] = @TEAMID   
END