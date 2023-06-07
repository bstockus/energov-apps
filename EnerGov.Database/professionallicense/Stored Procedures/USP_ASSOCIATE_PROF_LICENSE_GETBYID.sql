﻿CREATE PROCEDURE [professionallicense].[USP_ASSOCIATE_PROF_LICENSE_GETBYID]
(
  @PROFESSIONALLICENSEID AS CHAR(36)
)
AS
BEGIN
DECLARE @PREVIOUSLICENSEID AS Char(36)
DECLARE @PROFESSIONALLICENSELIST AS RecordIDs
SELECT @PREVIOUSLICENSEID = @PROFESSIONALLICENSEID
WHILE @@ROWCOUNT > 0
BEGIN
	SELECT @PREVIOUSLICENSEID = ILLICENSE.ILLICENSEPARENTID 
	FROM ILLICENSE 
	WHERE ILLICENSEID = @PREVIOUSLICENSEID
	IF @PREVIOUSLICENSEID IS NOT NULL
	BEGIN
		INSERT INTO @PROFESSIONALLICENSELIST (RECORDID) values(@PREVIOUSLICENSEID)
	END
END

EXEC [professionallicense].[USP_GET_ASSOCIATE_PROF_LICENSE_DETAILS] @PROFESSIONALLICENSELIST
END