


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_SYS_POPUP_REPORTS]
AS

Select *
From Settings
where NAME =  'PopUpReports' and BITVALUE=0

