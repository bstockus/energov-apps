
CREATE FUNCTION [dbo].[GetAutoNumberWithClassName]
(
	@ClassName nvarchar(500)
)
RETURNS nvarchar(100)
AS
BEGIN		
		DECLARE @CurrentPrefix nvarchar(50)
		DECLARE @NextNumber int
		DECLARE @TotalDigits int
		DECLARE @Format nvarchar(100)
		DECLARE @IndexOfFirstDash int
		DECLARE @CurrentDate datetime
		DECLARE @YearPart nvarchar(4)
		DECLARE @MonthPart nvarchar(2)
		DECLARE @DayPart nvarchar(2)
		DECLARE @NumberPart nvarchar(50)
		--Initialize Varaibles
		SET @CurrentPrefix = NULL
		SET @NextNumber = 0
		SET @TotalDigits = 0
		SET @Format = NULL
		SET @IndexOfFirstDash = -1
		SET @CurrentDate = getdate()		
		SET @YearPart = DATEPART(YEAR, @CurrentDate)
		SET @MonthPart = DATEPART(MONTH, @CurrentDate)
		SET @DayPart = DATEPART(DAY, @CurrentDate)
		
		SELECT @NextNumber = NEXTVALUE, @TotalDigits = PADWITHZEROSTOLENGTH, @Format = FORMATSTRING
		FROM AUTONUMBERSETTINGS WHERE CLASSNAME = @ClassName

		IF @Format IS NOT NULL
		BEGIN
			SET @Format = replace(@Format, 'MM', right(REPLICATE('0',2) + CAST(@MonthPart AS varchar(2)),2))
			SET @Format = replace(@Format, 'DD', right(REPLICATE('0',2) + CAST(@DayPart AS varchar(2)),2))
			SET @Format = replace(@Format, 'YYYY', right(REPLICATE('0',4) + CAST(@YearPart AS varchar(4)),4))
			SET @Format = replace(@Format, 'YY', right(REPLICATE('0',2) + CAST(@YearPart AS varchar(4)),2))
			SET @NumberPart = @NextNumber
			WHILE LEN(@NumberPart) < @TotalDigits
			BEGIN
				SET @NumberPart = '0' + @NumberPart
			END
			SET @Format = replace(@Format,'{0}',@NumberPart)			
		END
		RETURN @Format						
END
