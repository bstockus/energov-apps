
CREATE PROCEDURE [osdba].[usp_RebuildIndexesDoWork]
   @adtmStopTime [DATETIME],
   @astrThresholdType [CHAR](2),
   @asintAgeOut [SMALLINT],
   @aintMemoryThresholdMB [INT],
   @astrTimePeriod [CHAR](2)
WITH EXECUTE AS CALLER
AS
BEGIN

   DECLARE @RebuiltIndexObjects AS
     TABLE ([Schema]      SYSNAME,
            [ObjectName]  SYSNAME);

   DECLARE @bintSerialId        BIGINT,
           @strSchema           SYSNAME,
           @strObjectName       SYSNAME,
           @strIndexName        SYSNAME,
           @sintFillFactor      SMALLINT,
           @intSizeMB           INTEGER,
           @sintAge             SMALLINT;

   DECLARE @dtmRebuildStart     DATETIME,
           @dtmRebuildEnd       DATETIME,
           @intRebuildSeconds   INTEGER,
           @intMemUsedMB        INTEGER,
           @strTemp             NVARCHAR (2048);


   DECLARE @SEVERITY  INTEGER,
           @ERROR     VARCHAR(MAX),
           @STATE     INTEGER;

BEGIN TRY
   SET NOCOUNT ON;

   SET @intMemUsedMB = 0;

   DECLARE cursor_QueueIndexRebuild
    CURSOR FOR
        SELECT SerialId,
             [Schema],
             ObjectName,
             IndexName,
             [FillFactor],
             SizeMB,
             Age
        FROM osdba.QueueIndexRebuild
       WHERE TimePeriod = @astrTimePeriod
    ORDER BY Age     DESC,
             SizeMB  DESC;

   OPEN cursor_QueueIndexRebuild
   WHILE (1 = 1)
   BEGIN
      FETCH NEXT FROM cursor_QueueIndexRebuild
             INTO @bintSerialId,
                  @strSchema,
                  @strObjectName,
                  @strIndexName,
                  @sintFillFactor,
                  @intSizeMB,
                  @sintAge
      ----------------------------------------------------
      -- Has the threshold for the constaint been reached?
      -- Time or Memory
      ----------------------------------------------------
      IF NOT (@@FETCH_STATUS = 0)
        BREAK;
      IF (@astrThresholdType = 'TM' AND CURRENT_TIMESTAMP >= @adtmStopTime)
         BREAK;
      IF (@astrThresholdType = 'MM' AND @intMemUsedMB >= @aintMemoryThresholdMB)
         BREAK;
      IF ((@astrThresholdType = 'MM' AND ((@intMemUsedMB + @intSizeMB  ) >  @aintMemoryThresholdMB)) AND NOT (@sintAge >= @asintAgeOut))
         CONTINUE;


      SET @intMemUsedMB = @intMemUsedMB + @intSizeMB;
      SET @dtmRebuildStart = CURRENT_TIMESTAMP;
      ----------------------------------------------------------------
      -- Start a transaction so we can rollback if there's an error
      -- If the index exists, attempt to rebuild it. If it can't
      -- then log the error and skip it, thus keeping it the queue
      -- for the next run AND keep the existing index structure.
      -- If it is rebuilt, log some metrics for it, delete it
      -- from the queue and commit the transction AND rebuilt index.
      -- But first, update the statistics for all non-indexed columns
      -- for the applicable object.
      ----------------------------------------------------------------
      BEGIN TRANSACTION;
      BEGIN TRY
         ----------------------------------------------------------------
         -- Append the name of the table/object to table valued variable.
         -- With it and after indexes are rebuilt, the statistics
         -- for the non-indexed columns will be updated.
         -----------------------------------------------------------------
         INSERT INTO @RebuiltIndexObjects ([Schema], ObjectName) VALUES (@strSchema, @strObjectName);
         SET @strTemp = 'ALTER INDEX '   + QUOTENAME (@strIndexName) + ' ON ' + QUOTENAME (@strSchema) + '.' +  QUOTENAME (@strObjectName)  + ' REBUILD WITH (FILLFACTOR = '  + cast (@sintFillFactor as char (3))  + ' ) '
         EXEC (@strTemp);

      END TRY
      BEGIN CATCH
         ROLLBACK TRANSACTION
         SET @SEVERITY  = ISNULL (ERROR_SEVERITY(), 0)
         SET @ERROR     = ISNULL (ERROR_MESSAGE(), ' ')
         SET @STATE     = ISNULL (ERROR_STATE(), 0)
         INSERT INTO [osdba].[QueueIndexRebuildErrorLog] ([Schema],   [ObjectName],   [IndexName],   [Severity], [Error], [State])
                                                   VALUES (@strSchema, @strObjectName, @strIndexName, @SEVERITY,  @ERROR,  @STATE);
         CONTINUE
      END CATCH

      SET @dtmRebuildEnd     = CURRENT_TIMESTAMP;
      SET @intRebuildSeconds = DATEDIFF (ss, @dtmRebuildStart, @dtmRebuildEnd);
      UPDATE [osdba].QueueIndexRebuildLog
         SET RebuildStart   = @dtmRebuildStart,
               RebuildEnd     = @dtmRebuildEnd,
               RebuildSeconds = @intRebuildSeconds
         WHERE [Schema]     = @strSchema
         AND [ObjectName] = @strObjectName
         AND IndexName    = @strIndexName;

      DELETE FROM [osdba].QueueIndexRebuild WHERE SerialId = @bintSerialId;
      COMMIT TRANSACTION;
   END
   CLOSE cursor_QueueIndexRebuild;
   DEALLOCATE cursor_QueueIndexRebuild;

   ------------------------------------------------
   -- Update statistics for non-indexed columns now
   ------------------------------------------------
   DECLARE cursor_QueueIndexUpdateStatistics
   CURSOR FOR
     SELECT DISTINCT
            [Schema],
            ObjectName
      FROM @RebuiltIndexObjects

   OPEN cursor_QueueIndexUpdateStatistics
   WHILE (1 = 1)
   BEGIN
      FETCH NEXT FROM cursor_QueueIndexUpdateStatistics
               INTO @strSchema,
                  @strObjectName;
      IF NOT (@@FETCH_STATUS = 0)
        BREAK;
      BEGIN TRANSACTION;
         BEGIN TRY
            SET @strTemp = 'UPDATE STATISTICS ' + QUOTENAME (@strSchema) + '.' + QUOTENAME (@strObjectName)  +  ' WITH COLUMNS ';
            EXEC (@strTemp);
         END TRY
         BEGIN CATCH
            ROLLBACK TRANSACTION
            SET @SEVERITY  = ISNULL (ERROR_SEVERITY(), 0)
            SET @ERROR     = ISNULL (ERROR_MESSAGE(), ' ')
            SET @STATE     = ISNULL (ERROR_STATE(), 0)
            INSERT INTO [osdba].[QueueIndexRebuildErrorLog] ([Schema],   [ObjectName],   [IndexName],   [Severity], [Error], [State])
                                                      VALUES (@strSchema, @strObjectName, '-',           @SEVERITY,  @ERROR,  @STATE);
            CONTINUE
         END CATCH
      COMMIT TRANSACTION;
   END
   CLOSE cursor_QueueIndexUpdateStatistics;
   DEALLOCATE cursor_QueueIndexUpdateStatistics;
   --------------------------------------------
   -- Keep the QueueIndexRebuild tables healthy
   --------------------------------------------
   ALTER INDEX ALL ON osdba.QueueIndexRebuildConfiguration          REBUILD WITH (FILLFACTOR = 100);
   ALTER INDEX ALL ON osdba.QueueIndexRebuild                       REBUILD WITH (FILLFACTOR = 100);
   ALTER INDEX ALL ON osdba.QueueIndexRebuildErrorLog               REBUILD WITH (FILLFACTOR = 100);
   ALTER INDEX ALL ON osdba.QueueIndexRebuildLog                    REBUILD WITH (FILLFACTOR = 100);
   ALTER INDEX ALL ON osdba.QueueIndexRebuildDiscriminateObjects    REBUILD WITH (FILLFACTOR = 100);
   ALTER INDEX ALL ON osdba.QueueIndexRebuildListOfSchemas          REBUILD WITH (FILLFACTOR = 100);


END TRY
   BEGIN CATCH
      IF (CURSOR_STATUS('global', 'cursor_QueueIndexRebuild') >= 0)
      BEGIN
         CLOSE cursor_QueueIndexRebuild;
         DEALLOCATE cursor_QueueIndexRebuild;
      END
      IF (CURSOR_STATUS('global', 'cursor_QueueIndexUpdateStatistics') >= 0)
      BEGIN
         CLOSE cursor_QueueIndexUpdateStatistics;
         DEALLOCATE cursor_QueueIndexUpdateStatistics;
      END
      SET @SEVERITY  = ISNULL (ERROR_SEVERITY(), 0)
      SET @ERROR     = ISNULL (ERROR_MESSAGE(), ' ')
      SET @STATE     = ISNULL (ERROR_STATE(), 0)

      INSERT INTO [osdba].[QueueIndexRebuildErrorLog] ([Schema], [ObjectName], [IndexName], [Severity], [Error], [State])
                                               VALUES ('-',      '-',          '-',         @SEVERITY,  @ERROR,  @STATE);
      RAISERROR(@ERROR, @SEVERITY, @STATE);
   END CATCH
END
