
CREATE FUNCTION [dbo].[GETRECOMMENDAUTONUMBER]()
RETURNS nvarchar(6)
WITH EXECUTE AS CALLER
AS
BEGIN
DECLARE @FormatString nvarchar(50)
DECLARE @PadWithZerosToLength int
DECLARE @NextValue int
DECLARE @TotalDigit int
DECLARE @ReturnValue nvarchar(250)
SET @TotalDigit = 0
SELECT @FormatString = FORMATSTRING, @PadWithZerosToLength = PADWITHZEROSTOLENGTH, @NextValue = NEXTVALUE
FROM AUTONUMBERSETTINGS
WHERE CLASSNAME = 'EnerGovBusiness.PlanManagement.MyPlanRecommendation'
SET @TotalDigit = @PadWithZerosToLength
SET @ReturnValue = @NextValue
IF @TotalDigit IS NOT NULL
BEGIN
	WHILE LEN(@ReturnValue) < @TotalDigit
	BEGIN
		SET @ReturnValue = '0' + @ReturnValue		
	END		
END	
RETURN @ReturnValue	
END
