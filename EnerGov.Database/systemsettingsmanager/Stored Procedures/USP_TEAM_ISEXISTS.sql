CREATE  PROCEDURE [systemsettingsmanager].[USP_TEAM_ISEXISTS]
-- Add the parameters for the stored procedure here
@NAME VARCHAR(200)
AS
BEGIN
SET NOCOUNT ON;
 SELECT CASE WHEN (
                SELECT COUNT(1) -- For performance
                FROM TEAM  WHERE  [TEAM].[NAME]=@NAME) = 0 THEN CAST(0 AS BIT)
            ELSE CAST(1 AS BIT)
        END ISEXISTS
END