﻿CREATE PROCEDURE [globalsetup].[USP_CAFEEGLACCOUNTXREF_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[CAFEEGLACCOUNTXREF].[CAFEEGLACCOUNTXREFID],
	[dbo].[CAFEEGLACCOUNTXREF].[CAFEEID],
	[dbo].[CAFEEGLACCOUNTXREF].[DEBITGLACCOUNTID],
	[dbo].[CAFEEGLACCOUNTXREF].[CREDITGLACCOUNTID],
	[dbo].[CAFEEGLACCOUNTXREF].[CAPAYMENTTYPEID],
	[dbo].[CAFEEGLACCOUNTXREF].[CAPAYMENTMETHODID],
	[dbo].[CAFEEGLACCOUNTXREF].[PERCENTAGE],
	[DEBITGLACCOUNT].[NAME] AS [DEBITGLACCOUNTNAME],
	[CREDITTGLACCOUNT].[NAME] AS [CREDITGLACCOUNTNAME],
	[dbo].[CAPAYMENTMETHOD].[NAME] AS [PAYMENTMETHODNAME]
FROM [dbo].[CAFEEGLACCOUNTXREF]
JOIN [dbo].[CAPAYMENTMETHOD] ON [dbo].[CAPAYMENTMETHOD].[CAPAYMENTMETHODID] = [dbo].[CAFEEGLACCOUNTXREF].[CAPAYMENTMETHODID]
LEFT JOIN [dbo].[GLACCOUNT] [DEBITGLACCOUNT] ON [DEBITGLACCOUNT].[GLACCOUNTID] = [dbo].[CAFEEGLACCOUNTXREF].[DEBITGLACCOUNTID]
LEFT JOIN [dbo].[GLACCOUNT] [CREDITTGLACCOUNT] ON [CREDITTGLACCOUNT].[GLACCOUNTID] = [dbo].[CAFEEGLACCOUNTXREF].[CREDITGLACCOUNTID]
WHERE
	[dbo].[CAFEEGLACCOUNTXREF].[CAFEEID] = @PARENTID 

END