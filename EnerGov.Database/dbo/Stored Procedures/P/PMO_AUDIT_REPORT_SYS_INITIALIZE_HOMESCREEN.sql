


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_SYS_INITIALIZE_HOMESCREEN]
AS

Select *
From Settings
where NAME = 'InitializeWidgetData' and BITVALUE=1

