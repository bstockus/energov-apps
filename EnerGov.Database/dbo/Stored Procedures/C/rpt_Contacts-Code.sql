




-- =============================================
-- Author:		Kyong Hwangbo, EnerGov Solutions
-- Create date: 9/29/2010
-- Description:	This stored procedure pulls all Code Contacts for a Code case, as well as their addresses
-- Report using this stored proc:  
-- "Notice of Violation"
-- =============================================
CREATE PROCEDURE [dbo].[rpt_Contacts-Code] 

AS
BEGIN

	SET NOCOUNT ON;

SELECT CMCodeCaseContact.CMCodeCaseID, CMCodeCaseContactType.Name AS ModuleContactType, CMContactTypeSystem.Name AS SystemContactType
	, GlobalEntity.GlobalEntityName, GlobalEntity.FirstName, GlobalEntity.LastName, GlobalEntity.BusinessPhone, GlobalEntity.MobilePhone
	, MailingAddress.AddressType 
	, MailingAddress.AddressLine1, MailingAddress.PreDirection, MailingAddress.AddressLine2, MailingAddress.StreetType, MailingAddress.PostDirection
	, MailingAddress.AddressLine3, MailingAddress.City, MailingAddress.State, MailingAddress.PostalCode

FROM CMCodeCaseContact  
LEFT OUTER JOIN CMCodeCaseContactType ON CMCodeCaseContact.CMCodeCaseContactTypeID = CMCodeCaseContactType.CMCodeCaseContactTypeID
LEFT OUTER JOIN CMContactTypeSystem ON CMCodeCaseContactType.CMContactTypeSystemID = CMContactTypeSystem.CMContactTypeSystemID
LEFT OUTER JOIN GlobalEntity ON CMCodeCaseContact.GlobalEntityID = GlobalEntity.GlobalEntityID 
LEFT OUTER JOIN GlobalEntityMailingAddress ON GlobalEntity.GlobalEntityID = GlobalEntityMailingAddress.GlobalEntityID
LEFT OUTER JOIN MailingAddress ON GlobalEntityMailingAddress.MailingAddressID = MailingAddress.MailingAddressID
LEFT OUTER JOIN MailingAddressType ON MailingAddress.AddressType = MailingAddressType.MailingAddressTypeID





    
END





