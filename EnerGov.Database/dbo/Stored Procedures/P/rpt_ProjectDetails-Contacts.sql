
-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <10/1/2010>
-- Description:	<Created as a script to pull all CONTACTS for a project;
-- Report(s) using this query:
-- ProjectDetails.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_ProjectDetails-Contacts]
AS
BEGIN
	SET NOCOUNT ON;
-- Contact Info
SELECT PRProjectID, PRProjectContactID, IsBilling, GlobalEntity.GlobalEntityID, GlobalEntityName, FirstName, LastName
	, LandManagementContactType.Name as ModuleContactType, LandManagementContactSystemType.Name as SystemContactType
	, AddressType, AddressLine1, PreDirection, AddressLine2, StreetType, PostDirection, AddressLine3, City, State, PostalCode 
FROM PRProjectContact 
	LEFT OUTER JOIN GlobalEntity ON PRProjectContact.GlobalEntityID = GlobalEntity.GlobalEntityID 
	LEFT OUTER JOIN GlobalEntityMailingAddress ON GlobalEntity.GlobalEntityID = GlobalEntityMailingAddress.GlobalEntityID
	LEFT OUTER JOIN MailingAddress ON GlobalEntityMailingAddress.MailingAddressID = MailingAddress.MailingAddressID 
	LEFT OUTER JOIN LandManagementContactType ON PRProjectContact.LandManagementContactTypeID = LandManagementContactType.LandManagementContactTypeID 	
	LEFT OUTER JOIN LandManagementContactSystemType ON LandManagementContactType.LandManagementContactSystemTypeID = LandManagementContactSystemType.LandManagementContactSystemTypeID
END

