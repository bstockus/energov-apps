  
CREATE  PROCEDURE [systemsettingsmanager].[USP_TEAM_INSERT]    
-- Add the parameters for the stored procedure here    
@TEAMID CHAR(36),   
@NAME VARCHAR(200),  
@USERID CHAR(36),  
@TEAMIMAGE VARCHAR(MAX)  
AS    
BEGIN      
 INSERT INTO [dbo].[TEAM]      
 (    
[TEAM].[TEAMID],  
[TEAM].[NAME],  
[TEAM].[USERID],  
[TEAM].[TEAMIMAGE]  
 )    
 VALUES(    
@TEAMID,  
@NAME,  
@USERID,  
@TEAMIMAGE  
 )      
END