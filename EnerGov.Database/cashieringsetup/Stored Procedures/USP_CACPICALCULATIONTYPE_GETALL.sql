﻿CREATE PROCEDURE [cashieringsetup].[USP_CACPICALCULATIONTYPE_GETALL]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT 
		[dbo].[CACPICALCULATIONTYPE].[CACPICALCULATIONTYPEID],
		[dbo].[CACPICALCULATIONTYPE].[NAME]		
	 FROM [dbo].[CACPICALCULATIONTYPE] 
END