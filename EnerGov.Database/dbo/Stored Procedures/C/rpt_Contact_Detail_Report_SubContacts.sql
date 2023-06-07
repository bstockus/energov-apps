

CREATE PROCEDURE [dbo].[rpt_Contact_Detail_Report_SubContacts]
@GLOBALENTITYID as varchar(36)
AS
SELECT     FirstName, MiddleName, LastName, GlobalEntityName, GlobalEntityID
FROM         GlobalEntity
WHERE GlobalEntity.ParentGlobalEntityID = @GLOBALENTITYID

