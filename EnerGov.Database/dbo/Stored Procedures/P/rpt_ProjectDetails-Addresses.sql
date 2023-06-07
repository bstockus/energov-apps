
-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <10/1/2010>
-- Description:	<Created as a script to pull all Addresses for a project;
-- Report(s) using this query:
-- ProjectDetails.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_ProjectDetails-Addresses]
AS
BEGIN
	SET NOCOUNT ON;
-- Address Info	
SELECT PRProjectID, PRProjectAddressID, Main AS IsMainProject, AddressType, AddressLine1, PreDirection, AddressLine2, StreetType, AddressLine3, PostDirection, City, State, PostalCode
FROM PRProjectAddress 	
	LEFT OUTER JOIN MailingAddress ON PRProjectAddress.MailingAddressID = MailingAddress.MailingAddressID 
END 

