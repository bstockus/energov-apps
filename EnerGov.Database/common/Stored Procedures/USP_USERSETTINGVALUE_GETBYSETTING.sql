﻿CREATE PROCEDURE [common].[USP_USERSETTINGVALUE_GETBYSETTING]
	@USERSETTINGNAME VARCHAR(30),
	@USERSETTINGVALUE VARCHAR(MAX)
AS
BEGIN

SET NOCOUNT ON;

SELECT USERSETTINGVALUE.USERID
FROM USERSETTINGVALUE
INNER JOIN USERSETTING ON USERSETTING.USERSETTINGID = USERSETTINGVALUE.USERSETTINGID
WHERE USERSETTINGVALUE.STRINGVALUE = @USERSETTINGVALUE
AND USERSETTING.NAME = @USERSETTINGNAME

END