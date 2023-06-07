
CREATE PROCEDURE [osdba].[usp_RebuildIndexesGetThresholds]
   @adtmCurrentTimeStamp [DATETIME],
   @adtmStopTime [DATETIME] OUTPUT,
   @astrThresholdType [CHAR](2) OUTPUT,
   @asintAgeOut [SMALLINT] OUTPUT,
   @aintMemoryThresholdMB [INT] OUTPUT,
   @astrTimePeriod [CHAR](2) OUTPUT
WITH EXECUTE AS CALLER
AS
BEGIN
   DECLARE @strRunType                  char (2),
           @sintConstraintTime          smallint,
           @intConstraintMaxMemory      integer,
           @sintConstraintServerMemory  smallint,
           @strConstraintPreference     char (2)

   DECLARE @strDayOfWeek  char (2);

   DECLARE @SEVERITY  INTEGER,
           @ERROR     VARCHAR(MAX),
           @STATE     INTEGER;

BEGIN TRY

   SET NOCOUNT ON;

   ------------------------------------------------------------------
   -- Query the configuration table for thresolds or limits for an
   -- index rebuild. With these values calculate, where necessary,
   -- the thresolds, either for time or memory.
   ------------------------------------------------------------------


   --
   -- Initialize the return variables
   --
   SET @adtmStopTime          = @adtmCurrentTimeStamp;
   SET @astrThresholdType     = '  ';
   SET @asintAgeOut           = 0;
   SET @aintMemoryThresholdMB = 0;

   --
   -- Determine the day of week and with it, query the applicable configuration
   -- settings.
   --
   EXEC @astrTimePeriod = osdba.udf_QueueIndexRebuildGetTimePeriod @adtmCurrentTimeStamp;

   SELECT @strRunType                  = RunType,
          @asintAgeOut                 = AgeOut,
          @sintConstraintTime          = ConstraintTime,
          @intConstraintMaxMemory      = ConstraintMaxMemory,
          @sintConstraintServerMemory  = ConstraintServerMemory,
          @strConstraintPreference     = ConstraintPreference
       FROM osdba.QueueIndexRebuildConfiguration
      WHERE RunType = @astrTimePeriod;
   --
   -- Calculate the threshold type and it's threshold value
   -- Constraint Preference
   -- MM-> Max Memory      scalar expressed in megabytes
   -- SM-> Server Memory   percentage of server memory, resulting scalar expressed in megabytes
   -- TM-> Time            setting, expressed in minutes, is added to the time the index rebuild starts
   --
   IF (@strConstraintPreference = 'MM')
   BEGIN
      SET @astrThresholdType     = 'MM'
      SET @aintMemoryThresholdMB = @intConstraintMaxMemory;
   END

   IF (@strConstraintPreference = 'SM')
   BEGIN
      SET @astrThresholdType     = 'MM'
      SELECT @aintMemoryThresholdMB = CAST (CAST (value_in_use  AS INTEGER) * (@sintConstraintServerMemory / 100.0) AS INTEGER)
        FROM sys.configurations
       WHERE name = 'max server memory (MB)'
   END

   IF (@strConstraintPreference = 'TM')
   BEGIN
      SET @astrThresholdType = 'TM'
      SET @adtmStopTime      = DATEADD (mi, @sintConstraintTime, @adtmCurrentTimeStamp);
   END

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
