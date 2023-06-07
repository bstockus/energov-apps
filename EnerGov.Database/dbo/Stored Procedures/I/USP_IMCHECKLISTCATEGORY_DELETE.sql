﻿CREATE PROCEDURE [dbo].[USP_IMCHECKLISTCATEGORY_DELETE]
(
	@IMCHECKLISTCATEGORYID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[IMCHECKLISTCATEGORY]
WHERE
	[IMCHECKLISTCATEGORYID] = @IMCHECKLISTCATEGORYID AND 
	[ROWVERSION]= @ROWVERSION