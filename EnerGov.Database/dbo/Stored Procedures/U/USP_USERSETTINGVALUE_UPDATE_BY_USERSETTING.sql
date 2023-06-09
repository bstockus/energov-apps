﻿CREATE PROCEDURE [dbo].[USP_USERSETTINGVALUE_UPDATE_BY_USERSETTING]
(
	@USERSETTINGIDLIST RecordIDs READONLY,
	@STRINGVALUE NVARCHAR(MAX)
)
AS
UPDATE [dbo].[USERSETTINGVALUE] SET
	   [STRINGVALUE] = @STRINGVALUE
WHERE USERSETTINGID IN (SELECT RECORDID FROM @USERSETTINGIDLIST)