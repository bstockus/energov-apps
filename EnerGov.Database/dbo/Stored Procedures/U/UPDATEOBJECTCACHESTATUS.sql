﻿CREATE PROCEDURE [dbo].[UPDATEOBJECTCACHESTATUS]
	
AS

BEGIN
    IF EXISTS(SELECT 1 FROM OBJECTCACHESTATUS WHERE REMAININGCACHEREBUILD >0 )

		BEGIN
		    UPDATE OBJECTCACHESTATUS SET REMAININGCACHEREBUILD = REMAININGCACHEREBUILD - 1
			SELECT REMAININGCACHEREBUILD FROM OBJECTCACHESTATUS
		END
	
	
END