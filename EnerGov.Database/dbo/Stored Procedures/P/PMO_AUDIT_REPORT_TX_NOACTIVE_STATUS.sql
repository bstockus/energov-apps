﻿


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_TX_NOACTIVE_STATUS]
AS

SELECT     TXREMITSTATUS.NAME AS TX_STATUS, TXREMITSTATUS.DESCRIPTION AS TX_DESCR, TXREMITSTATUSSYSTEM.NAME AS TX_SYSTEM_STATUS
FROM         TXREMITSTATUS INNER JOIN
                      TXREMITSTATUSSYSTEM ON TXREMITSTATUS.TXREMITSTATUSSYSTEMID = TXREMITSTATUSSYSTEM.TXREMITSTATUSSYSTEMID
WHERE TXREMITSTATUSSYSTEM.NAME='Active'

