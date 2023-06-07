﻿CREATE PROCEDURE [systemsettingsmanager].[USP_TEAMRESOURCE_ISEXISTS]
    @TEAMID CHAR(36),
    @USERID CHAR(36),
    @RESOURCETYPEID CHAR(36)
AS
BEGIN
SET NOCOUNT ON;
SELECT CASE WHEN (
            SELECT COUNT(1) -- For performance
                FROM TEAMRESOURCE WHERE [TEAMRESOURCE].[TEAMID]=@TEAMID
                                        AND [TEAMRESOURCE].[USERID]=@USERID
                                        AND [TEAMRESOURCE].[RESOURCETYPEID]=@RESOURCETYPEID) =0 THEN CAST(0 AS BIT)
            ELSE CAST(1 AS BIT)
        END;
END