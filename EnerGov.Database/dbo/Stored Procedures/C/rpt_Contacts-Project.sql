

create PROCEDURE [dbo].[rpt_Contacts-Project]
--=============================================================
-- [rpt_Contacts-Project]
--=============================================================
-- Shows all Project Listings
-- 10/14/2010 - Kyong Hwangbo
-- Report(s) using this stored proc:
-- Project Listings by Application Date.rpt

AS
BEGIN
	SET NOCOUNT ON;SELECT PRProjectContact.PRProjectID, LandManagementContactType.Name AS ModuleContactName, LandManagementContactSystemType.Name AS SystemContactName
	, GlobalEntityName, FirstName, LastName
FROM PRProjectContact 
	LEFT OUTER JOIN GlobalEntity ON PRProjectContact.GlobalEntityID = GlobalEntity.GlobalEntityID
	INNER JOIN LandManagementContactType ON PRProjectContact.LandManagementContactTypeID = LandManagementContactType.LandManagementContactTypeID
	INNER JOIN LandManagementContactSystemType ON LandManagementContactType.LandManagementContactSystemTypeID = LandManagementContactSystemType.LandManagementContactSystemTypeID 

END


