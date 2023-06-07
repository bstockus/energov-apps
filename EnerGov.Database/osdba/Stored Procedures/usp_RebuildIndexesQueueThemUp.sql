
CREATE PROCEDURE [osdba].[usp_RebuildIndexesQueueThemUp]
   @astrTimePeriod [CHAR](2),
   @astrIndexOverride [CHAR](2)
WITH EXECUTE AS CALLER
AS
BEGIN
   DECLARE @sintAgeOut SMALLINT;

   DECLARE @SEVERITY  INTEGER,
           @ERROR     VARCHAR(MAX),
           @STATE     INTEGER;
-------------------------------------------------------
-- Identify indexes that have changed (DML) and add
-- them to the queue if they are not already there.
-------------------------------------------------------
BEGIN TRY
   SET NOCOUNT ON;

   IF OBJECT_ID('tempdb..#QueueIndexRebuildChangedIndexes') IS NOT NULL
      DROP TABLE #QueueIndexRebuildChangedIndexes

   CREATE TABLE #QueueIndexRebuildChangedIndexes (
            [Schema]    VARCHAR (128) NOT NULL,
            ObjectName  VARCHAR (128) NOT NULL,
            IndexName   VARCHAR (128) NOT NULL);

   SET @sintAgeOut = 0;
   -------------------------------------------------------
   -- Identify indexes that have changed, scope
   -- this to specific schemas.
   -- Store the results of the query into a temp table
   -- with a consistent collation.
   -------------------------------------------------------
   IF @astrIndexOverride != 'ZZ'
   BEGIN
           INSERT INTO #QueueIndexRebuildChangedIndexes ([Schema], ObjectName, IndexName)
           SELECT sc.name COLLATE DATABASE_DEFAULT AS [Schema],
                  so.name COLLATE DATABASE_DEFAULT AS ObjectName,
                  si.name COLLATE DATABASE_DEFAULT AS IndexName
             FROM sys.dm_db_index_usage_stats su
       INNER JOIN sys.objects    so
               ON  so.object_id = su.object_id
       INNER JOIN sys.schemas    sc
               ON so.schema_id = sc.schema_id
       INNER JOIN osdba.QueueIndexRebuildListOfSchemas
               ON sc.name = QueueIndexRebuildListOfSchemas.[Schema]
       INNER JOIN sys.indexes     si
               ON su.object_id = si.object_id
              AND so.object_id = si.object_id
              AND su.index_id  = si.index_id
       INNER JOIN osdba.QueueIndexRebuildLog
               ON sc.name COLLATE DATABASE_DEFAULT = QueueIndexRebuildLog.[Schema]
              AND so.name COLLATE DATABASE_DEFAULT = QueueIndexRebuildLog.ObjectName
              AND si.name COLLATE DATABASE_DEFAULT = QueueIndexRebuildLog.IndexName
             WHERE so.is_ms_shipped   = 0
               AND si.is_hypothetical = 0
               AND su.database_id      = db_id ()
               AND su.last_user_update > ISNULL (QueueIndexRebuildLog.RebuildEnd, '2011-10-10 08:00:00')
   END
   ELSE
   BEGIN
         INSERT INTO #QueueIndexRebuildChangedIndexes ([Schema], ObjectName, IndexName)
         SELECT [Schema],
                ObjectName,
                IndexName
         FROM osdba.QueueIndexRebuildLog
    END

   CREATE UNIQUE CLUSTERED INDEX PK_QueueIndexRebuildChangedIndexes ON #QueueIndexRebuildChangedIndexes
   ([Schema], ObjectName, IndexName)
   WITH (FILLFACTOR = 100)

   -----------------------------------------------------------
   -- Delete indexes from the Rebuild Log that no longer exist
   -----------------------------------------------------------
        DELETE osdba.QueueIndexRebuild
          FROM osdba.QueueIndexRebuild
   INNER JOIN (SELECT [Schema],
                      ObjectName,
                      IndexName
                 FROM osdba.QueueIndexRebuild
               EXCEPT
               SELECT sc.name COLLATE DATABASE_DEFAULT AS [Schema],
                      so.name COLLATE DATABASE_DEFAULT AS ObjectName,
                      si.name COLLATE DATABASE_DEFAULT AS IndexName
                 FROM sys.objects    so
           INNER JOIN sys.schemas    sc
                   ON so.schema_id = sc.schema_id
           INNER JOIN osdba.QueueIndexRebuildListOfSchemas
                   ON sc.name = QueueIndexRebuildListOfSchemas.[Schema]
           INNER JOIN sys.indexes     si
                   ON so.object_id = si.object_id
           INNER JOIN osdba.QueueIndexRebuildLog
                   ON sc.name COLLATE DATABASE_DEFAULT = QueueIndexRebuildLog.[Schema]
                  AND so.name COLLATE DATABASE_DEFAULT = QueueIndexRebuildLog.ObjectName
                  AND si.name COLLATE DATABASE_DEFAULT = QueueIndexRebuildLog.IndexName
                WHERE so.is_ms_shipped   = 0
                  AND si.is_hypothetical = 0)
            AS DeletedIndexes
            ON DeletedIndexes.[Schema]   = QueueIndexRebuild.[Schema]
           AND DeletedIndexes.ObjectName = QueueIndexRebuild.ObjectName
           AND DeletedIndexes.IndexName  = QueueIndexRebuild.IndexName

   -------------
   -- WE Appends
   -------------
   IF @astrTimePeriod = 'WE' OR @astrIndexOverride = 'ZZ'
   BEGIN
      INSERT INTO osdba.QueueIndexRebuild ([Schema], ObjectName, IndexName, [FillFactor], TimePeriod, [RowCount], SizeMB, Age)
      SELECT QueueIndexRebuildLog.[Schema],
             QueueIndexRebuildLog.ObjectName,
             QueueIndexRebuildLog.IndexName,
             QueueIndexRebuildLog.[FillFactor],
             @astrTimePeriod,
             QueueIndexRebuildLog.[RowCount],
             QueueIndexRebuildLog.SizeMB,
             @sintAgeOut
        FROM osdba.QueueIndexRebuildLog
      INNER JOIN #QueueIndexRebuildChangedIndexes
              ON QueueIndexRebuildLog.[Schema]   = #QueueIndexRebuildChangedIndexes.[Schema]
             AND QueueIndexRebuildLog.ObjectName = #QueueIndexRebuildChangedIndexes.ObjectName
             AND QueueIndexRebuildLog.IndexName  = #QueueIndexRebuildChangedIndexes.IndexName
      INNER JOIN (SELECT [Schema],
                         ObjectName
                  FROM ( SELECT QueueIndexRebuildLog.[Schema],
                                QueueIndexRebuildLog.ObjectName
                           FROM osdba.QueueIndexRebuildLog
                     INNER JOIN osdba.QueueIndexRebuildDiscriminateObjects
                             ON QueueIndexRebuildLog.[Schema]    = QueueIndexRebuildDiscriminateObjects.[Schema]
                            AND QueueIndexRebuildLog.ObjectName  = QueueIndexRebuildDiscriminateObjects.ObjectName
                          WHERE QueueIndexRebuildDiscriminateObjects.Class = 'WE'
                        EXCEPT
                        SELECT [Schema],
                               ObjectName
                           FROM (SELECT [Schema],
                                        ObjectName
                                 FROM osdba.QueueIndexRebuild
                                 UNION
                                 SELECT [Schema],
                                        ObjectName
                                 FROM osdba.QueueIndexRebuildDiscriminateObjects
                                 WHERE [Class] = 'EX') AS ObjectsToExclude)
                 AS ObjectsOfInterest)
                 AS ObjectsOfInterest
                 ON #QueueIndexRebuildChangedIndexes.[Schema]     = ObjectsOfInterest.[Schema]
                AND #QueueIndexRebuildChangedIndexes.ObjectName   = ObjectsOfInterest.ObjectName
   END

   --------------
   -- WD Apppends
   --------------
   INSERT INTO osdba.QueueIndexRebuild ([Schema], ObjectName, IndexName, [FillFactor], TimePeriod, [RowCount], SizeMB, Age)
   SELECT QueueIndexRebuildLog.[Schema],
          QueueIndexRebuildLog.ObjectName,
          QueueIndexRebuildLog.IndexName,
          QueueIndexRebuildLog.[FillFactor],
          @astrTimePeriod,
          QueueIndexRebuildLog.[RowCount],
          QueueIndexRebuildLog.SizeMB,
          @sintAgeOut
     FROM osdba.QueueIndexRebuildLog
   INNER JOIN #QueueIndexRebuildChangedIndexes
           ON QueueIndexRebuildLog.[Schema]   = #QueueIndexRebuildChangedIndexes.[Schema]
          AND QueueIndexRebuildLog.ObjectName = #QueueIndexRebuildChangedIndexes.ObjectName
          AND QueueIndexRebuildLog.IndexName  = #QueueIndexRebuildChangedIndexes.IndexName
   INNER JOIN (SELECT [Schema],
                      ObjectName
               FROM ( SELECT [Schema],
                              ObjectName
                        FROM osdba.QueueIndexRebuildLog
                     EXCEPT
                     SELECT [Schema],
                            ObjectName
                        FROM (SELECT [Schema],
                                     ObjectName
                              FROM osdba.QueueIndexRebuild
                              UNION
                              SELECT [Schema],
                                     ObjectName
                              FROM osdba.QueueIndexRebuildDiscriminateObjects
                              WHERE [Class] = 'EX'
                              UNION
                              SELECT [Schema],
                                     ObjectName
                              FROM osdba.QueueIndexRebuildDiscriminateObjects
                              WHERE [Class] = 'WE') AS ObjectsToExclude)
              AS ObjectsOfInterest)
              AS ObjectsOfInterest
              ON #QueueIndexRebuildChangedIndexes.[Schema]     = ObjectsOfInterest.[Schema]
             AND #QueueIndexRebuildChangedIndexes.ObjectName   = ObjectsOfInterest.ObjectName

   ------------------------------------------------
   -- Age all entries by incrementing by 1
   -- For the time period they are applicable too.
   -----------------------------------------------
   UPDATE osdba.QueueIndexRebuild
     SET Age += 1
   WHERE TimePeriod = @astrTimePeriod

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
