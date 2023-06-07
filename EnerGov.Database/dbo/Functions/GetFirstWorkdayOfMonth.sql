
--exec dbo.GetFirstWorkdayOfMonth(2013,06)


CREATE FUNCTION dbo.GetFirstWorkdayOfMonth(@Year INT, @Month INT)
RETURNS DATETIME

AS BEGIN
      
    DECLARE @firstOfMonth VARCHAR(20)
    SET @firstOfMonth = CAST(@Year AS VARCHAR(4)) + '-' + CAST(@Month AS VARCHAR) + '-25'

    DECLARE @currDate DATETIME 
    SET @currDate = CAST(@firstOfMonth as DATETIME)

    DECLARE @weekday INT
    SET @weekday = DATEPART(weekday, @currdate)

    -- 7 = saturday, 1 = sunday
    WHILE @weekday = 1 OR @weekday = 7
    BEGIN
    	SET @currDate = DATEADD(DAY, 1, @currDate)
    	SET @weekday = DATEPART(WEEKDAY, @currdate)
    END

    RETURN @currdate
END