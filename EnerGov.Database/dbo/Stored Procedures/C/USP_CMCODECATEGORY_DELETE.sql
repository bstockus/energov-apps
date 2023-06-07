﻿CREATE PROCEDURE [dbo].[USP_CMCODECATEGORY_DELETE]
(
	@CMCODECATEGORYID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[CMCODECATEGORY]
WHERE
	[CMCODECATEGORYID] = @CMCODECATEGORYID AND 
	[ROWVERSION]= @ROWVERSION