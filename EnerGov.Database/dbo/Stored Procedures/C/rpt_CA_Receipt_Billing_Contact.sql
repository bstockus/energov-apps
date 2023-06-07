


CREATE PROCEDURE [dbo].[rpt_CA_Receipt_Billing_Contact]
@GLOBALENTITYID AS VARCHAR(36)
AS
SELECT GlobalEntity.GlobalEntityName, GlobalEntity.FirstName, GlobalEntity.LastName, MailingAddress.AddressLine1, MailingAddress.AddressLine2, 
       MailingAddress.AddressLine3, MailingAddress.City, MailingAddress.State, MailingAddress.PostalCode, MailingAddress.PostDirection, MailingAddress.PreDirection, 
       MailingAddress.StreetType, MailingAddress.UnitOrSuite
FROM GlobalEntity
LEFT OUTER JOIN GlobalEntityMailingAddress ON GlobalEntityMailingAddress.GlobalEntityID = GlobalEntity.GlobalEntityID
LEFT OUTER JOIN MailingAddress ON MailingAddress.MailingAddressID = GlobalEntityMailingAddress.MailingAddressID 
WHERE GlobalEntity.GlobalEntityID = @GLOBALENTITYID



