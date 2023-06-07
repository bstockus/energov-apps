




create PROCEDURE [dbo].[rpt_Contacts-Billing]
--8/30/2010 - Kyong Hwangbo
--Created to show Global Contact's "BILLING" address


AS
BEGIN

	SET NOCOUNT ON;

SELECT     GlobalEntity.GlobalEntityID, GlobalEntity.GlobalEntityName, 
                      GlobalEntity.FirstName AS GlobalEntityFName, GlobalEntity.LastName AS GlobalEntityLName, 
                      MailingAddress.AddressLine1, MailingAddress.PreDirection, MailingAddress.AddressLine2, MailingAddress.StreetType, 
                      MailingAddress.PostDirection, MailingAddress.AddressLine3, MailingAddress.City, MailingAddress.State, 
                      MailingAddress.PostalCode 
FROM			GlobalEntity 
				LEFT OUTER JOIN GlobalEntityMailingAddress
						ON GlobalEntity.GlobalEntityID = GlobalEntityMailingAddress.GlobalEntityID
				LEFT OUTER JOIN MailingAddress
						ON GlobalEntityMailingAddress.MailingAddressID = MailingAddress.MailingAddressID
						
WHERE MailingAddress.AddressType = 'Billing'
--ORDER BY AddressType


END





