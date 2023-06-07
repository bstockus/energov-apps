
CREATE PROCEDURE [osdba].[usp_RebuildIndexes]
   @achrWeekEndDayIndicator [CHAR](2),
   @aintHoursLimit [INT]
WITH EXECUTE AS CALLER
AS
BEGIN

DECLARE  @dtmCurrentTimeStamp      DATETIME ,
         @dtmStopTime              DATETIME ,
         @strThresholdType         CHAR (2),
         @sintAgeOut               SMALLINT,
         @intMemoryThresholdMB     INTEGER,
         @intLockTimeout           INTEGER,
         @strTimePeriod            CHAR (2),
         @strIndexOverride         CHAR (3); -- If WeekEndDayIndicator is ZZ the all indexes are to be rebuilt

   DECLARE @SEVERITY  INTEGER,
           @ERROR     VARCHAR(MAX),
           @STATE     INTEGER;

BEGIN TRY

SET @dtmCurrentTimeStamp = CURRENT_TIMESTAMP
EXECUTE osdba.usp_RebuildIndexesGetThresholds   @dtmCurrentTimeStamp,
                                                @dtmStopTime           OUTPUT,
                                                @strThresholdType      OUTPUT,
                                                @sintAgeOut            OUTPUT,
                                                @intMemoryThresholdMB  OUTPUT,
                                                @strTimePeriod         OUTPUT

SET LOCK_TIMEOUT 5000;

---------------------------------------------
-- Delete error log data more the 90 days old
---------------------------------------------
DELETE FROM [osdba].QueueIndexRebuildErrorLog
 WHERE BummerDate < DATEADD (dd, -90, CURRENT_TIMESTAMP);

-----------------------------------------------------
-- Create a list of schemas that will queried for
-- indexes and store in a temp table.
-----------------------------------------------------
EXECUTE osdba.usp_RebuildIndexesCreateListOfSchemas

---------------------------------------------------------
-- If there are changes to the object to be discriminated
-- propagate those changes to the necessary tables.
---------------------------------------------------------
EXECUTE osdba.usp_QueueIndexRebuildMaintainDiscriminateObjects

-----------------------------------------------------
-- Perform maintenance on the Index Rebuild Log
-- The contents of this table mirrors what Munis has
-- for indexes for both tables and indexed views,
-- plus basic metrics for the last time the index
-- was rebuilt, including the size and number of rows
-----------------------------------------------------
EXECUTE osdba.usp_RebuildIndexesMaintainRebuildLog

-------------------------------------------------------
-- LJC 2014-09-09 IndexOverride
-- If  IndexOverride is ZZ then all indexes will be
-- queued up for rebuilding, but the time/space constraint
-- still stands.
--
-- Queue up indexes in need of rebuilding by ordering
-- indexes from largest to smallest.
-- For Weekends, the larger tables are appended,
-- followed by the Weekday tables.
-------------------------------------------------------
IF @achrWeekEndDayIndicator = 'ZZ'
   SET @strIndexOverride = @achrWeekEndDayIndicator
ELSE
   SET @strIndexOverride = '';
EXECUTE osdba.usp_RebuildIndexesQueueThemUp    @strTimePeriod, @strIndexOverride

-------------------------------------------------------
-- Traverse QueueIndexRebuild for indexes in need of
-- rebuilding.  If an index has been 'aged out', it will
-- be rebuilt first.  If there are any indexes that were not
-- built in the previous run, they will be rebuilt first,
-- if this index cannot be rebuilt within the defined constaints.
-- It will be aged the process is run.
-- After the index is rebuilt, the log entry for it
-- (QueueIndexRebuildLog) will be updated and
-- the queued index row will be deleted.
-------------------------------------------------------
EXECUTE osdba.usp_RebuildIndexesDoWork @dtmStopTime,
                                       @strThresholdType,
                                       @sintAgeOut,
                                       @intMemoryThresholdMB,
                                       @strTimePeriod

END TRY
   BEGIN CATCH
      SET @SEVERITY  = ISNULL (ERROR_SEVERITY(), 0)
      SET @ERROR     = ISNULL (ERROR_MESSAGE(), ' ')
      SET @STATE     = ISNULL (ERROR_STATE(), 0)

      IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

      INSERT INTO [osdba].[QueueIndexRebuildErrorLog] ([Schema], [ObjectName], [IndexName], [Severity], [Error], [State])
                                               VALUES ('-',      '-',          '-',         @SEVERITY,  @ERROR,  @STATE);

      RAISERROR(@ERROR, @SEVERITY, @STATE);
 END CATCH
END
