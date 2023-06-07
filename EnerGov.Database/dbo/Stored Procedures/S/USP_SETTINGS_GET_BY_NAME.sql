﻿CREATE PROCEDURE [dbo].[USP_SETTINGS_GET_BY_NAME]
	@NAMES RecordNames READONLY
AS
SELECT
	SETTINGS.NAME,
	SETTINGS.BITVALUE,
	SETTINGS.STRINGVALUE,
	SETTINGS.INTVALUE,
	SETTINGS.IMAGEVALUE
FROM SETTINGS WITH (NOLOCK)
INNER JOIN @NAMES INPUT ON INPUT.Name = SETTINGS.NAME
ORDER BY SETTINGS.NAME