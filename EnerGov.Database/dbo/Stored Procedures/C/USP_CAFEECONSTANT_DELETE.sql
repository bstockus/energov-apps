﻿CREATE PROCEDURE [dbo].[USP_CAFEECONSTANT_DELETE]
(
	@CAFEECONSTANTID CHAR(36),
	@ROWVERSION INT
)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM CAFEETEMPLATEFEEINPUT WITH (NOLOCK) WHERE INPUTVALUE = @CAFEECONSTANTID)
	BEGIN
		SET NOCOUNT ON

		EXEC [USP_CAFEECONSTANTVALUE_DELETE_BYPARENTID] @CAFEECONSTANTID

		SET NOCOUNT OFF

		DELETE FROM [dbo].[CAFEECONSTANT]
		WHERE
			[CAFEECONSTANTID] = @CAFEECONSTANTID AND 
			[ROWVERSION]= @ROWVERSION
		RETURN
	END

	RAISERROR ('The DELETE statement conflicted with the REFERENCE constraint. The conflict occurred in table "dbo.CAFEETEMPLATEFEEINPUT", column ''INPUTVALUE''.', 16, 0)
END