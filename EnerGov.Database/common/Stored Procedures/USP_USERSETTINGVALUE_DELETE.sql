﻿CREATE PROCEDURE [common].[USP_USERSETTINGVALUE_DELETE]
	@USERSETTINGVALUEID CHAR(36)
AS

	DELETE FROM	USERSETTINGVALUE
	WHERE	USERSETTINGVALUEID = @USERSETTINGVALUEID