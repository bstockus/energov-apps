CREATE PROCEDURE [dbo].[rpt_License_LicenseCertificate]
	@GLOBALENTITYID AS VARCHAR(36),
	@LICENSEYEAR AS INT
AS SELECT
    *
FROM (
	SELECT 
       bll.LICENSENUMBER AS LicenseNumber,
       buis.DBA AS DBA,
       buis.REGISTRATIONID AS BuisnessNumber,
       ISNULL(glent.CONTACTID, buis.REGISTRATIONID) AS CompanyNumber,
       ISNULL(glent.GLOBALENTITYNAME, buis.COMPANYNAME) AS Name,
       ISNULL(glent.EMAIL, buis.EMAIL) AS Email,
       ISNULL(glent.BUSINESSPHONE, buis.BUSINESSPHONE) AS BuisinessPhone,
       glent.HOMEPHONE AS HomePhone,
       glent.MOBILEPHONE AS MobilePhone,
       glent.OTHERPHONE AS OtherPhone,
       glent.FAX AS FaxNumber,
       glent.FIRSTNAME AS FirstName,
       glent.LASTNAME AS LastName,
       blladdr_mailaddr.ADDRESSLINE1 AS LicenseAddressLine1,
       blladdr_mailaddr.ADDRESSLINE2 AS LicenseAddressLine2,
       blladdr_mailaddr.ADDRESSLINE3 AS LicenseAddressLine3,
       blladdr_mailaddr.CITY AS LicenseCity,
       blladdr_mailaddr.STATE AS LicenseState,
       blladdr_mailaddr.POSTALCODE AS LicenseZipCode,
       blladdr_mailaddr.POSTDIRECTION AS LicensePostDirection,
       blladdr_mailaddr.PREDIRECTION AS LicensePreDirection,
       blladdr_mailaddr.STREETTYPE AS LicenseStreetType,
       bllt.NAME AS LicenseTypeName,
       bllc.NAME AS LicenseClassName,
       ISNULL(cslm.PremiseDescriptionStorageQuestion, '') AS AlcoholStoragePremise,
       ISNULL(cslm.PremiseDescriptionQuestion, '') AS AlcoholSalesAndServicePremise,
       ISNULL(cslm.BeerGardenDescription, '') AS BeerGardenDescription,
       ISNULL(cslm.IndoorCabaretDescription, '') AS IndoorCabaretDescription,
       ISNULL(cslm.OutdoorCabaretDescription, '') AS OutdoorCabaretDescription,
	   glent.GLOBALENTITYID AS GlobalEntityId,
	   bll.ISSUEDDATE AS IssuedDate,
	   bll.EXPIRATIONDATE AS ExpirationDate,
	   bltci.DisplayName AS DisplayName,
	   bltci.UseAlcoholPremiseDescription AS UseAlcoholPremiseDescription,
	   bltci.UseBeerGardenPremiseDescription AS UseBeerGardenPremiseDescription,
	   bltci.UseIndoorCabaretDescription AS UseIndoorCabaretDescription,
	   bltci.UseOutdoorCabaretDescription AS UseOutdoorCabaretDescription,
       bltci.UseJunkDealerLogic AS UseJunkDealerLogic,
       bltci.UseRecyclingFacilityLicenseSubClass AS UseRecyclingFacilityLicenseSubClass,
       bltci.UseSecondhandLicenseLogic AS UseSecondhandLicenseLogic,
       cslm.JunkWaiverExpirationDate AS JunkWaiverExpirationDate,
       bltci.[AdditionalText] AS AdditionalText,
       ISNULL(cslm.JunkDealer1000FootWaiver, 0) AS JunkDealer1000FootWaiver,
	   (SELECT TOP 1 agentge.FIRSTNAME + ' ' + agentge.LASTNAME AS FullName 
                FROM [$(EnerGovDatabase)].dbo.GLOBALENTITY agentge 
                INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSECONTACT bllc ON agentge.GLOBALENTITYID = bllc.GLOBALENTITYID 
                WHERE bllc.BLCONTACTTYPEID = '1f76e1b7-7d57-41a2-a777-30bb098f01b5' AND bllc.BLLICENSEID = bll.BLLICENSEID) AS AgentFullName
FROM [$(EnerGovDatabase)].dbo.BLLICENSE bll
INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSETYPE bllt ON bll.BLLICENSETYPEID = bllt.BLLICENSETYPEID
INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSECLASS bllc ON bll.BLLICENSECLASSID = bllc.BLLICENSECLASSID
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERLICENSEMANAGEMENT cslm ON bll.BLLICENSEID = cslm.ID
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERLICENSEMANAGEMENTMS cslmms ON bll.BLLICENSEID = cslmms.ID
INNER JOIN [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSION buis ON bll.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.GLOBALENTITY glent ON buis.GLOBALENTITYID = glent.GLOBALENTITYID
INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSEADDRESS blladdr ON bll.BLLICENSEID = blladdr.BLLICENSEID AND blladdr.MAIN = 1
INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS blladdr_mailaddr ON blladdr.MAILINGADDRESSID = blladdr_mailaddr.MAILINGADDRESSID AND blladdr_mailaddr.ADDRESSTYPE = 'Location'
INNER JOIN [laxreports].[BusinessLicenseTypeClassInformation] bltci ON 
            bll.BLLICENSETYPEID = bltci.LicenseTypeId AND 
            bll.BLLICENSECLASSID = bltci.LicenseClassId AND
            (bltci.UseJunkDealerLogic = 0 OR (bltci.UseJunkDealerLogic = 1 AND cslm.JunkDealerLicenseType = bltci.PickListItemId)) AND
            (bltci.UseRecyclingFacilityLicenseSubClass = 0 OR (bltci.UseRecyclingFacilityLicenseSubClass = 1 AND cslmms.CUSTOMFIELDPICKLISTITEMID = bltci.PickListItemId)) AND
            (bltci.UseSecondhandLicenseLogic = 0 OR (bltci.UseSecondhandLicenseLogic = 1 AND cslmms.CUSTOMFIELDPICKLISTITEMID = bltci.PickListItemId))
WHERE buis.BLGLOBALENTITYEXTENSIONID = @GLOBALENTITYID AND bll.TAXYEAR = @LICENSEYEAR

	UNION ALL

SELECT TOP 1
	   '' AS LicenseNumber,
       buis.DBA AS DBA,
       buis.REGISTRATIONID AS BuisnessNumber,
       ISNULL(glent.CONTACTID, buis.REGISTRATIONID) AS CompanyNumber,
       ISNULL(glent.GLOBALENTITYNAME, buis.COMPANYNAME) AS Name,
       ISNULL(glent.EMAIL, buis.EMAIL) AS Email,
       ISNULL(glent.BUSINESSPHONE, buis.BUSINESSPHONE) AS BuisinessPhone,
       glent.HOMEPHONE AS HomePhone,
       glent.MOBILEPHONE AS MobilePhone,
       glent.OTHERPHONE AS OtherPhone,
       glent.FAX AS FaxNumber,
       glent.FIRSTNAME AS FirstName,
       glent.LASTNAME AS LastName,
       blladdr_mailaddr.ADDRESSLINE1 AS LicenseAddressLine1,
       blladdr_mailaddr.ADDRESSLINE2 AS LicenseAddressLine2,
       blladdr_mailaddr.ADDRESSLINE3 AS LicenseAddressLine3,
       blladdr_mailaddr.CITY AS LicenseCity,
       blladdr_mailaddr.STATE AS LicenseState,
       blladdr_mailaddr.POSTALCODE AS LicenseZipCode,
       blladdr_mailaddr.POSTDIRECTION AS LicensePostDirection,
       blladdr_mailaddr.PREDIRECTION AS LicensePreDirection,
       blladdr_mailaddr.STREETTYPE AS LicenseStreetType,
       bllt.NAME AS LicenseTypeName,
       bllc.NAME AS LicenseClassName,
       ISNULL(cslm.PremiseDescriptionStorageQuestion, '') AS AlcoholStoragePremise,
       ISNULL(cslm.PremiseDescriptionQuestion, '') AS AlcoholSalesAndServicePremise,
       ISNULL(cslm.BeerGardenDescription, '') AS BeerGardenDescription,
       ISNULL(cslm.IndoorCabaretDescription, '') AS IndoorCabaretDescription,
       ISNULL(cslm.OutdoorCabaretDescription, '') AS OutdoorCabaretDescription,
	   glent.GLOBALENTITYID AS GlobalEntityId,
	   bll.ISSUEDDATE AS IssuedDate,
	   bll.EXPIRATIONDATE AS ExpirationDate,
	   bltci.DisplayName AS DisplayName,
	   bltci.UseAlcoholPremiseDescription AS UseAlcoholPremiseDescription,
	   bltci.UseBeerGardenPremiseDescription AS UseBeerGardenPremiseDescription,
	   bltci.UseIndoorCabaretDescription AS UseIndoorCabaretDescription,
	   bltci.UseOutdoorCabaretDescription AS UseOutdoorCabaretDescription,
       bltci.UseJunkDealerLogic AS UseJunkDealerLogic,
       bltci.UseRecyclingFacilityLicenseSubClass AS UseRecyclingFacilityLicenseSubClass,
       bltci.UseSecondhandLicenseLogic AS UseSecondhandLicenseLogic,
       
       cslm.JunkWaiverExpirationDate AS JunkWaiverExpirationDate,
       bltci.[AdditionalText] AS AdditionalText,
       ISNULL(cslm.JunkDealer1000FootWaiver, 0) AS JunkDealer1000FootWaiver,
	   (SELECT TOP 1 agentge.FIRSTNAME + ' ' + agentge.LASTNAME AS FullName 
                FROM [$(EnerGovDatabase)].dbo.GLOBALENTITY agentge 
                INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSECONTACT bllc ON agentge.GLOBALENTITYID = bllc.GLOBALENTITYID 
                WHERE bllc.BLCONTACTTYPEID = '1f76e1b7-7d57-41a2-a777-30bb098f01b5' AND bllc.BLLICENSEID = bll.BLLICENSEID) AS AgentFullName
FROM [$(EnerGovDatabase)].dbo.BLLICENSE bll
INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSETYPE bllt ON bll.BLLICENSETYPEID = bllt.BLLICENSETYPEID
INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSECLASS bllc ON bll.BLLICENSECLASSID = bllc.BLLICENSECLASSID
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERLICENSEMANAGEMENT cslm ON bll.BLLICENSEID = cslm.ID
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERLICENSEMANAGEMENTMS cslmms ON bll.BLLICENSEID = cslmms.ID
INNER JOIN [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSION buis ON bll.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.GLOBALENTITY glent ON buis.GLOBALENTITYID = glent.GLOBALENTITYID
INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSEADDRESS blladdr ON bll.BLLICENSEID = blladdr.BLLICENSEID AND blladdr.MAIN = 1
INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS blladdr_mailaddr ON blladdr.MAILINGADDRESSID = blladdr_mailaddr.MAILINGADDRESSID AND blladdr_mailaddr.ADDRESSTYPE = 'Location'
INNER JOIN [laxreports].[BusinessLicenseTypeClassInformation] bltci ON 
            bll.BLLICENSETYPEID = bltci.LicenseTypeId AND 
            bll.BLLICENSECLASSID = bltci.LicenseClassId AND
            (bltci.UseJunkDealerLogic = 0 OR (bltci.UseJunkDealerLogic = 1 AND cslm.JunkDealerLicenseType = bltci.PickListItemId)) AND
            (bltci.UseRecyclingFacilityLicenseSubClass = 0 OR (bltci.UseRecyclingFacilityLicenseSubClass = 1 AND cslmms.CUSTOMFIELDPICKLISTITEMID = bltci.PickListItemId)) AND
            (bltci.UseSecondhandLicenseLogic = 0 OR (bltci.UseSecondhandLicenseLogic = 1 AND cslmms.CUSTOMFIELDPICKLISTITEMID = bltci.PickListItemId))
WHERE buis.BLGLOBALENTITYEXTENSIONID = @GLOBALENTITYID AND bll.TAXYEAR = @LICENSEYEAR) x
GROUP BY x.LicenseNumber, x.DBA, x.BuisnessNumber, x.CompanyNumber, x.Name, x.Email, x.BuisinessPhone, x.HomePhone, x.MobilePhone, x.OtherPhone, x.FaxNumber, x.FirstName, x.LastName,
            x.LicenseAddressLine1, x.LicenseAddressLine2, x.LicenseAddressLine3, x.LicenseCity, x.LicenseState, x.LicenseZipCode, x.LicensePostDirection, x.LicensePreDirection,
            x.LicenseStreetType, x.LicenseTypeName, x.LicenseClassName, x.AlcoholStoragePremise, x.AlcoholSalesAndServicePremise, x.BeerGardenDescription, x.IndoorCabaretDescription,
            x.OutdoorCabaretDescription, x.GlobalEntityId, x.IssuedDate, x.ExpirationDate, x.DisplayName, x.UseAlcoholPremiseDescription, x.UseBeerGardenPremiseDescription, 
            x.UseIndoorCabaretDescription, x.UseOutdoorCabaretDescription, x.UseJunkDealerLogic, x.UseRecyclingFacilityLicenseSubClass, x.UseSecondhandLicenseLogic, 
            x.JunkDealer1000FootWaiver, x.AgentFullName, x.JunkWaiverExpirationDate, x.AdditionalText