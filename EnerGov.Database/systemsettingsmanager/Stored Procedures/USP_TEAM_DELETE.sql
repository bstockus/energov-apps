CREATE  PROCEDURE [SystemSettingsManager].[USP_TEAM_DELETE]        
@TEAMID CHAR(36)     
AS        
BEGIN      
SET NOCOUNT ON;   
	exec [systemsettingsmanager].[USP_TEAMRESOURCE_DELETE_BY_TEAMID] @TEAMID   

SET NOCOUNT OFF;
	 DELETE FROM  [dbo].[TEAM]        
	 WHERE [TEAM].[TEAMID] = @TEAMID      
END