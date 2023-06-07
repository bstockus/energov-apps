﻿CREATE FUNCTION [dbo].[IS_SETTING_ENABLED](
	@SETTING_NAME NVARCHAR(50)
)
RETURNS INT
AS
BEGIN
	DECLARE @RESULT AS BIT
	SET @RESULT = 0
	
	IF (EXISTS(SELECT 1 FROM SETTINGS
					WHERE SETTINGS.NAME= @SETTING_NAME AND SETTINGS.BITVALUE = 1))
	BEGIN
		SET @RESULT = 1
	END

	RETURN @RESULT
END