﻿  
CREATE  PROCEDURE [systemsettingsmanager].[USP_RESOURCE_INSERT]    
-- Add the parameters for the stored procedure here    
@RESOURCEID CHAR(36),    
@USERID CHAR(36),    
@UNAVAILABLESTARTDATE DATETIME,    
@UNAVAILABLEENDDATE DATETIME,    
@REASON VARCHAR(MAX) = NULL,  
@DELEGATEUSERID CHAR(36) = NULL    
AS    
BEGIN      
 INSERT INTO [dbo].[RESOURCE]      
 (    
[RESOURCE].[RESOURCEID],  
[RESOURCE].[USERID],  
[RESOURCE].[UNAVAILABLESTARTDATE],  
[RESOURCE].[UNAVAILABLEENDDATE],  
[RESOURCE].[REASON],  
[RESOURCE].[DELEGATEUSERID]  
 )    
 VALUES(    
@RESOURCEID,    
@USERID,    
@UNAVAILABLESTARTDATE,    
@UNAVAILABLEENDDATE,   
@REASON,   
@DELEGATEUSERID   
 )      
END