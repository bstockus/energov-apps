﻿CREATE PROCEDURE [taxremittanceaccount].[USP_REPORTPERIODDUEDATES_GETBYRPTPERIODID]
(
    @TXRPTPERIODID AS CHAR(36)
)
AS

SELECT TOP 3 [dbo].[TXBILLPERIOD].[BILLPERIODID]
	,[dbo].[TXBILLPERIOD].[PERIODNAME]
	,[dbo].[TXBILLPERIOD].[DUEDATE]
	,[RPTPERIODREF]
FROM [dbo].[TXBILLPERIOD]
WHERE [dbo].[TXBILLPERIOD].DUEDATE >= GETDATE()
	AND [dbo].[TXBILLPERIOD].RPTPERIODREF = @TXRPTPERIODID
ORDER BY [dbo].[TXBILLPERIOD].[DUEDATE]