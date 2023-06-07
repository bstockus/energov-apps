
CREATE PROCEDURE [osdba].[usp_RebuildIndexesCreateListOfSchemas]
   
WITH EXECUTE AS CALLER
AS
BEGIN

   DECLARE @SEVERITY  INTEGER,
           @ERROR     VARCHAR(MAX),
           @STATE     INTEGER;

BEGIN TRY
   SET NOCOUNT ON;
   ----------------------------------------------------------------------
   -- Stored procedure stub for now
   -- In a future version, the extended properties of available schemas
   -- will be queried for a specific tag to identify Munis schemas.
   -- Also clients will be able to add their schemas to our rebuild
   -- index process.
   -- The name of the schema will be appended to a table named
   -- osdba.QueueIndexRebuildListOfSchemas
   ----------------------------------------------------------------------

END TRY
   BEGIN CATCH
      SET @SEVERITY  = ISNULL (ERROR_SEVERITY(), 0)
      SET @ERROR     = ISNULL (ERROR_MESSAGE(), ' ')
      SET @STATE     = ISNULL (ERROR_STATE(), 0)

      INSERT INTO [osdba].[QueueIndexRebuildErrorLog] ([Schema], [ObjectName], [IndexName], [Severity], [Error], [State])
                                               VALUES ('-',      '-',          '-',         @SEVERITY,  @ERROR,  @STATE);
      RAISERROR(@ERROR, @SEVERITY, @STATE);
   END CATCH
END
