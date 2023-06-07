

CREATE PROCEDURE [dbo].[rpt_Contact_Detail_Report_Addresses]
@GLOBALENTITYID as varchar(36)
AS
SELECT     MailingAddress.AddressLine1, MailingAddress.AddressLine2, MailingAddress.AddressLine3, MailingAddress.City, MailingAddress.State, MailingAddress.PostalCode, 
                      MailingAddress.StreetType, MailingAddress.PostDirection, MailingAddress.PreDirection, MailingAddress.UnitOrSuite, MailingAddress.AddressType, MailingAddress.Country,
                      GlobalEntityMailingAddress.MailingAddressID
FROM         MailingAddress INNER JOIN
                      GlobalEntityMailingAddress ON MailingAddress.MailingAddressID = GlobalEntityMailingAddress.MailingAddressID
WHERE GlobalEntityMailingAddress.GlobalEntityID = @GLOBALENTITYID

