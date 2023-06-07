
CREATE PROCEDURE [osdba].[usp_RebuildIndexesMaintainRebuildLog]
   
WITH EXECUTE AS CALLER
AS
BEGIN

   DECLARE @SEVERITY  INTEGER,
           @ERROR     VARCHAR(MAX),
           @STATE     INTEGER;

BEGIN TRY
   SET NOCOUNT ON;

   -----------------------------------------------------
   -- Perform maintenance on the Index Rebuild Log
   -- The contents of this table mirrors what Munis has
   -- for indexes for both tables and indexed views,
   -- plus basic metrics for the last time the index
   -- was rebuilt, including the size and number of rows.
   -- OPERATIONS
   -- DELETES: Remove rows for deleted indexes
   -- APPENDS: Newly added indexes
   -- UPDATES: Changes to the metadata for the index
   --          the number of rows and index size (MB)
   --
   -- The indexes of interest are those used by Munis.
   -- Our schemas are the following:
   --   * dbo
   --   * StateReporting
   --   * PayrollAudit
   -----------------------------------------------------

   --
   -- Store the results of the query in a temp table for a couple of reasons.
   -- First, to make sure we have the correct collation
   -- Second, well, the query will need to be run a few times
   --
   IF OBJECT_ID('tempdb..#QueueIndexRebuildIndexMetadata') IS NOT NULL
      DROP TABLE #QueueIndexRebuildIndexMetadata

     SELECT sc.name  COLLATE DATABASE_DEFAULT                                 AS [Schema],
            so.name  COLLATE DATABASE_DEFAULT                                 AS ObjectName,
            si.name  COLLATE DATABASE_DEFAULT                                 AS IndexName,
            80                                                                AS [FillFactor],   -- Default fill factor, may change in the future
            SUM (pa.rows)                                                     AS [RowCount],
            SUM (CAST ((ROUND ((a.used_pages * 8) / 1024.0, 0)) AS INTEGER))  AS SizeMB
           INTO #QueueIndexRebuildIndexMetadata
          FROM sys.objects     so
    INNER JOIN sys.indexes     si
            ON so.object_id = si.object_id
    INNER JOIN sys.schemas     sc
            ON so.schema_id = sc.schema_id
    INNER JOIN osdba.QueueIndexRebuildListOfSchemas
            ON sc.name = QueueIndexRebuildListOfSchemas.[Schema]
    INNER JOIN sys.partitions pa
            ON pa.object_id = so.object_id
           AND pa.index_id = si.index_id
    INNER JOIN sys.allocation_units a
            ON pa.partition_id = a.container_id
            --ON pa.hobt_id = a.container_id
         WHERE so.type in ('U', 'V')
           AND so.is_ms_shipped   = 0
           AND si.is_hypothetical = 0
           AND si.name IS NOT NULL
      GROUP BY sc.name,
               so.name,
               si.name,
               so.type
      ORDER BY [Schema],
               ObjectName,
               IndexName
      OPTION (MAXDOP 1)

   CREATE UNIQUE CLUSTERED INDEX PK_QueueIndexRebuildIndexMetadata ON #QueueIndexRebuildIndexMetadata
   ([Schema], ObjectName, IndexName)
   WITH (FILLFACTOR = 100);

   --------------------------------------------------
   -- Monotonic Indexes get a fill factor of 100%
   -- A monotonic index has the following properties:
   -- * Integer Data Type
   -- * Identity
   -- * Single Column Index
   -- In the future, RowVersion and Timestamp
   -- will be added.
   --------------------------------------------------
   UPDATE #QueueIndexRebuildIndexMetadata
      SET [FillFactor] = 100
     FROM #QueueIndexRebuildIndexMetadata Q
   INNER JOIN  (SELECT sc.name       AS [Schema],
                       so.name       AS ObjectName,
                       si.name       AS IndexName
                   FROM sys.objects     so
             INNER JOIN sys.indexes     si
                     ON so.object_id = si.object_id
             INNER JOIN sys.schemas     sc
                     ON so.schema_id = sc.schema_id
             INNER JOIN osdba.QueueIndexRebuildListOfSchemas
                     ON sc.name = QueueIndexRebuildListOfSchemas.[Schema]
             INNER JOIN sys.columns   scol
                     ON scol.object_id = so.object_id
             INNER JOIN sys.index_columns icol
                     ON icol.object_id = so.object_id
                    AND icol.index_id  = si.index_id
                    AND icol.column_id = scol.column_id
           LEFT JOIN sys.index_columns icol_more_than_1
                     ON icol_more_than_1.object_id          = so.object_id
                    AND icol_more_than_1.index_id           = si.index_id
                    AND icol_more_than_1.is_included_column = 0
                    AND icol_more_than_1.key_ordinal        > 1
             INNER JOIN sys.types as stypes
                     ON stypes.system_type_id = scol.system_type_id
                  WHERE so.type in ('U', 'V')
                    AND so.is_ms_shipped   = 0
                    AND si.is_hypothetical = 0
                    AND si.is_disabled     = 0
                    AND icol.is_included_column   = 0
                    AND si.name           IS NOT NULL
                    AND icol.key_ordinal         = 1
                    AND stypes.system_type_id in (52, 56, 127) -- {smallint, int, bigint}
                    AND scol.is_identity            = 1
                    AND icol_more_than_1.object_id IS NULL)
         AS MonotonicIndexes
         ON Q.[Schema]   = MonotonicIndexes.[Schema]
        AND Q.ObjectName = MonotonicIndexes.ObjectName
        AND Q.IndexName  = MonotonicIndexes.IndexName
     OPTION (MAXDOP 1)


   ---------------------------------------------------------
   -- Deletes indexes FROM log that no longer exist in Munis
   ---------------------------------------------------------
    DELETE osdba.QueueIndexRebuildLog
      FROM osdba.QueueIndexRebuildLog
INNER JOIN (SELECT [Schema],
                   ObjectName,
                   IndexName
              FROM osdba.[QueueIndexRebuildLog]
            EXCEPT
            SELECT [Schema],
                   ObjectName,
                   IndexName
             FROM #QueueIndexRebuildIndexMetadata)
   AS DeletedIndexes
   ON DeletedIndexes.[Schema]      = QueueIndexRebuildLog.[Schema]
  AND DeletedIndexes.ObjectName    = QueueIndexRebuildLog.ObjectName
  AND DeletedIndexes.IndexName     = QueueIndexRebuildLog.IndexName
   --------------------------------------------
   -- Append new Munis indexes to the log table
   --------------------------------------------
   INSERT INTO osdba.QueueIndexRebuildLog ([Schema], ObjectName, IndexName, [FillFactor], [RowCount], SizeMB)
       SELECT #QueueIndexRebuildIndexMetadata.[Schema],
              #QueueIndexRebuildIndexMetadata.ObjectName,
              #QueueIndexRebuildIndexMetadata.IndexName,
              #QueueIndexRebuildIndexMetadata.[FillFactor],
              #QueueIndexRebuildIndexMetadata.[RowCount],
              #QueueIndexRebuildIndexMetadata.SizeMB
         FROM #QueueIndexRebuildIndexMetadata
   INNER JOIN (SELECT [Schema],
                      ObjectName,
                      IndexName
                FROM #QueueIndexRebuildIndexMetadata
                EXCEPT
                SELECT [Schema],
                      ObjectName,
                      IndexName
                 FROM osdba.[QueueIndexRebuildLog])
      AS NewIndexes
      ON NewIndexes.[Schema]      = #QueueIndexRebuildIndexMetadata.[Schema]
     AND NewIndexes.ObjectName    = #QueueIndexRebuildIndexMetadata.ObjectName
     AND NewIndexes.IndexName     = #QueueIndexRebuildIndexMetadata.IndexName
   -----------------------------
   -- Update RowCount and SizeMB
   -----------------------------
   UPDATE osdba.QueueIndexRebuildLog
      SET [RowCount] = #QueueIndexRebuildIndexMetadata.[RowCount],
          [SizeMB]   = #QueueIndexRebuildIndexMetadata.SizeMB
   FROM osdba.QueueIndexRebuildLog
   INNER JOIN #QueueIndexRebuildIndexMetadata
           ON osdba.QueueIndexRebuildLog.[Schema]   = #QueueIndexRebuildIndexMetadata.[Schema]
          AND osdba.QueueIndexRebuildLog.ObjectName = #QueueIndexRebuildIndexMetadata.ObjectName
          AND osdba.QueueIndexRebuildLog.IndexName  = #QueueIndexRebuildIndexMetadata.IndexName

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
