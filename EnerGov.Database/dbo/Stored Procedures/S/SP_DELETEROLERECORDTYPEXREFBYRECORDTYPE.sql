﻿CREATE PROCEDURE [dbo].[SP_DELETEROLERECORDTYPEXREFBYRECORDTYPE]
	@RECORDTYPEID char(36)	
AS
BEGIN		
	DELETE FROM ROLERECORDTYPEXREF WHERE RECORDTYPEID = @RECORDTYPEID   	
END