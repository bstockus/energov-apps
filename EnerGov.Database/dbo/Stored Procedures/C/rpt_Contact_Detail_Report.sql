

CREATE PROCEDURE [dbo].[rpt_Contact_Detail_Report]
@GLOBALENTITYID as varchar(36)
AS
SELECT     IsCompany, IsContact, Manufacturer, Vendor, Shipper, EMail, Website, BusinessPhone, HomePhone, MobilePhone, OtherPhone, Fax, FirstName, LastName, 
                      MiddleName, Title, GlobalEntityName, GlobalEntityID
FROM         GlobalEntity
WHERE GlobalEntity.GlobalEntityID = @GLOBALENTITYID

