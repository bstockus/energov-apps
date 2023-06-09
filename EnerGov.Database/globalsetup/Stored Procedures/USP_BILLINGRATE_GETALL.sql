﻿CREATE PROCEDURE [globalsetup].[USP_BILLINGRATE_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[BILLINGRATE].[BILLINGRATEID],
	[dbo].[BILLINGRATE].[NAME],
	[dbo].[BILLINGRATE].[DESCRIPTION],
	[dbo].[BILLINGRATE].[AMOUNT],
	[dbo].[BILLINGRATE].[ACTIVE],
	[dbo].[BILLINGRATE].[LASTCHANGEDBY],
	[dbo].[BILLINGRATE].[LASTCHANGEDON],
	[dbo].[BILLINGRATE].[ROWVERSION]
FROM [dbo].[BILLINGRATE]
ORDER BY
	[dbo].[BILLINGRATE].[NAME] ASC
END