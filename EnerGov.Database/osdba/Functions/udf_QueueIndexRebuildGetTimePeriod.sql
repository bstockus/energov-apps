
CREATE FUNCTION [osdba].[udf_QueueIndexRebuildGetTimePeriod] (@adtmCurrentTimeStamp [DATETIME])
RETURNS [CHAR](2)
WITH EXECUTE AS CALLER
AS
BEGIN
   DECLARE @strTimePeriod  char (2),
           @strDayOfWeek   char (2);
   --
   -- Determine the day of week and with it, query the applicable configuration
   -- settings.
   --
   SET @strDayOfWeek  = (SELECT UPPER (LEFT (datename (dw, @adtmCurrentTimeStamp), 2)))
   SET @strTimePeriod = (SELECT CASE @strDayOfWeek
                                   WHEN 'MO' THEN 'WD'
                                   WHEN 'TU' THEN 'WD'
                                   WHEN 'WE' THEN 'WD'
                                   WHEN 'TH' THEN 'WD'
                                   WHEN 'FR' THEN 'WE'
                                   WHEN 'SA' THEN 'WE'
                                   WHEN 'SU' THEN 'WD'
                                END)
   RETURN @strTimePeriod
END
