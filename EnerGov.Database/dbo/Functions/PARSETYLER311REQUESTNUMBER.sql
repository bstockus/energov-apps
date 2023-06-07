CREATE FUNCTION [dbo].[PARSETYLER311REQUESTNUMBER]
(
	@Note nvarchar(500)
)
RETURNS nvarchar(100)
AS
BEGIN
		DECLARE @index1 int;
		DECLARE @index2 int;
		DECLARE @index3 int;
		DECLARE @sub nvarchar(500);
		SELECT @index1 = charindex('Incident Number:', @Note);
		IF @index1 = 0
		BEGIN
				SELECT @index1 = charindex('Request Number:', @Note);
		END
		SELECT @sub = SUBSTRING(@Note, @index1, LEN(@Note) - @index1 + 1);
		SELECT @index2 = charindex(':', @sub);
		SELECT @index3 = charindex(',', @sub);
		RETURN RTRIM(LTRIM(SUBSTRING(@sub, @index2 + 1, @index3 - @index2 - 1)));
END