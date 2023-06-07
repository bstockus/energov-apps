
CREATE PROCEDURE [osdba].[usp_QueueIndexRebuildMaintainDiscriminateObjects]
   
WITH EXECUTE AS CALLER
AS
BEGIN

   DECLARE @SEVERITY  INTEGER,
           @ERROR     VARCHAR(MAX),
           @STATE     INTEGER;

BEGIN TRY
   SET NOCOUNT ON;

   ----------------------------------------------------------
   -- If an object (view or table) has been dropped from the
   -- database, then remove it from the objects in the
   -- Discriminate Objects table.
   ----------------------------------------------------------
   DELETE osdba.QueueIndexRebuildDiscriminateObjects
     FROM osdba.QueueIndexRebuildDiscriminateObjects
   INNER JOIN ( SELECT [Schema],
                       ObjectName
                  FROM osdba.QueueIndexRebuildDiscriminateObjects
                 EXCEPT
                 SELECT sc.name COLLATE DATABASE_DEFAULT AS [Schema],
                        so.name COLLATE DATABASE_DEFAULT AS ObjectName
                        FROM sys.objects    so
                  INNER JOIN sys.schemas    sc
                        ON so.schema_id = sc.schema_id
                  INNER JOIN osdba.QueueIndexRebuildListOfSchemas
                        ON sc.name = QueueIndexRebuildListOfSchemas.[Schema]
                  WHERE so.type in ('U', 'V'))
               AS DeletedObjects
               ON DeletedObjects.[Schema]   = QueueIndexRebuildDiscriminateObjects.[Schema]
              AND DeletedObjects.ObjectName = QueueIndexRebuildDiscriminateObjects.ObjectName

   ----------------------------------------
   -- Remove any lingering objects from the
   -- queue that were once discriminated
   ----------------------------------------
       DELETE osdba.QueueIndexRebuild
         FROM osdba.QueueIndexRebuild
   INNER JOIN (SELECT [Schema],
                      ObjectName,
                      TimePeriod
                 FROM osdba.QueueIndexRebuild where TimePeriod <> 'WD'
               EXCEPT
               SELECT [Schema],
                      ObjectName,
                      Class
                 FROM osdba.QueueIndexRebuildDiscriminateObjects)
            AS DiscrimObjectInQueue
            ON DiscrimObjectInQueue.[Schema]   = QueueIndexRebuild.[Schema]
           AND DiscrimObjectInQueue.ObjectName = QueueIndexRebuild.ObjectName
           AND DiscrimObjectInQueue.TimePeriod = QueueIndexRebuild.TimePeriod

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
