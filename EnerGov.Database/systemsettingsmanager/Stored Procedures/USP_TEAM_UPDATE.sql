CREATE  PROCEDURE [systemsettingsmanager].[USP_TEAM_UPDATE]    
-- Add the parameters for the stored procedure here    
@TEAMID CHAR(36),   
@NAME VARCHAR(200),  
@USERID CHAR(36),  
@TEAMIMAGE VARCHAR(MAX)  
AS    
BEGIN      
 UPDATE[dbo].[TEAM]      
 SET    
[TEAM].[NAME] = @NAME,  
[TEAM].[USERID] = @USERID,  
[TEAM].[TEAMIMAGE] = @TEAMIMAGE  
WHERE   
[TEAM].[TEAMID] = @TEAMID  
END