﻿CREATE PROCEDURE [systemsetup].[USP_CATRANSACTIONFEE_FILTERS_BYCRITERIA]
(
	@CATRANSACTIONID CHAR(36),
	@CACOMPUTEDFEEID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 	TOP 1
	[dbo].[CATRANSACTIONFEE].[CATRANSACTIONID],
	[dbo].[CATRANSACTIONFEE].[CACOMPUTEDFEEID],
	[dbo].[CATRANSACTION].[RECEIPTNUMBER]

FROM [dbo].[CATRANSACTIONFEE]
INNER JOIN [dbo].[CATRANSACTION] on [dbo].[CATRANSACTION].[CATRANSACTIONID] = [dbo].[CATRANSACTIONFEE].[CATRANSACTIONID]
WHERE
	[dbo].[CATRANSACTIONFEE].[CATRANSACTIONID] = @CATRANSACTIONID AND
	[dbo].[CATRANSACTIONFEE].[CACOMPUTEDFEEID] = @CACOMPUTEDFEEID
ORDER BY
	[dbo].[CATRANSACTIONFEE].[CATRANSACTIONFEEID]
END