﻿CREATE PROCEDURE [dbo].[USP_CAFEETIMETRACKINGTYPEXREF_DELETE]
(
@CAFEETIMETRACKINGTYPEXREFID CHAR(36)
)
AS
DELETE FROM [dbo].[CAFEETIMETRACKINGTYPEXREF]
WHERE
	[CAFEETIMETRACKINGTYPEXREFID] = @CAFEETIMETRACKINGTYPEXREFID