﻿CREATE PROCEDURE [dbo].[USP_ERPROJECTFILECATEGORY_DELETE]
(
	@ERPROJECTFILECATEGORYID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[ERPROJECTFILECATEGORY]
WHERE
	[ERPROJECTFILECATEGORYID] = @ERPROJECTFILECATEGORYID AND 
	[ROWVERSION]= @ROWVERSION