CREATE FUNCTION [dbo].[UFN_GET_DAY_OF_WEEK_NAME]
(
	@DayOfWeekNumber int
)
RETURNS nvarchar(10)
AS
BEGIN		
	DECLARE @DayOfWeekName nvarchar(10)
	
	SET @DayOfWeekName = CASE @DayOfWeekNumber 
		WHEN 1 THEN  'Monday'
		WHEN 2 THEN 'Tuesday'
		WHEN 3 THEN 'Wednesday'
		WHEN 4 THEN 'Thursday'
		WHEN 5 THEN 'Friday'
		WHEN 6 THEN 'Saturday'
		ELSE 'Sunday'
		END
	
	RETURN @DayOfWeekName						
END