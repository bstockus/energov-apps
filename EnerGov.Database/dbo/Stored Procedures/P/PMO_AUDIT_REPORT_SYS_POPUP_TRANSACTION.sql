


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_SYS_POPUP_TRANSACTION]
AS

Select *
From Settings
where NAME = 'UsePopupTransactionScreenForPayNow' and BITVALUE=0

