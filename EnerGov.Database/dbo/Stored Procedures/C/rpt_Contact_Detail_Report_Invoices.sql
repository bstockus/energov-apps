

CREATE PROCEDURE [dbo].[rpt_Contact_Detail_Report_Invoices]
@GLOBALENTITYID as varchar(36)
AS
SELECT     CAInvoice.CAInvoiceID, CAInvoice.InvoiceNumber, CAInvoice.InvoiceTotal, CAInvoice.InvoiceDate, CAInvoice.InvoiceDueDate, CAStatus.Name AS Status
FROM         CAInvoice INNER JOIN
                      CAStatus ON CAInvoice.CAStatusID = CAStatus.CAStatusID
WHERE CAInvoice.GlobalEntityID = @GLOBALENTITYID

