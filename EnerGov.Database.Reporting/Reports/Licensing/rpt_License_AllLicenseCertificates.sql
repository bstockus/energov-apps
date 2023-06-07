CREATE PROCEDURE [dbo].[rpt_License_AllLicenseCertificates]
	@LicenseYear int,
    @BLLICENSESTATUSID AS VARCHAR(36)
AS 

WITH Businesses AS (
    SELECT bll.BLGLOBALENTITYEXTENSIONID
    FROM [$(EnerGovDatabase)].[dbo].BLLICENSE bll
    WHERE bll.BLLICENSESTATUSID = @BLLICENSESTATUSID
      AND bll.TAXYEAR = @LicenseYear
    GROUP BY bll.BLGLOBALENTITYEXTENSIONID),
     MailingAddresses AS (
         SELECT x.MAILINGADDRESSID,
                x.ADDRESSTYPE,
                CASE
                    WHEN LEN(x.AdditionalAddressLine) > 0 AND LEN(x.SuiteOrUnitAddressLine) > 0
                        THEN x.AdditionalAddressLine
                    WHEN LEN(x.AdditionalAddressLine) > 0 AND LEN(x.SuiteOrUnitAddressLine) = 0
                        THEN x.AdditionalAddressLine
                    WHEN LEN(x.AdditionalAddressLine) = 0 AND LEN(x.SuiteOrUnitAddressLine) > 0 THEN x.StreetAddressLine
                    ELSE x.StreetAddressLine
                    END AS AddressLine1,
                CASE
                    WHEN LEN(x.AdditionalAddressLine) > 0 AND LEN(x.SuiteOrUnitAddressLine) > 0 THEN x.StreetAddressLine
                    WHEN LEN(x.AdditionalAddressLine) > 0 AND LEN(x.SuiteOrUnitAddressLine) = 0 THEN x.StreetAddressLine
                    WHEN LEN(x.AdditionalAddressLine) = 0 AND LEN(x.SuiteOrUnitAddressLine) > 0
                        THEN x.SuiteOrUnitAddressLine
                    ELSE x.CityStateZipAddressLine
                    END AS AddressLine2,
                CASE
                    WHEN LEN(x.AdditionalAddressLine) > 0 AND LEN(x.SuiteOrUnitAddressLine) > 0
                        THEN x.SuiteOrUnitAddressLine
                    WHEN LEN(x.AdditionalAddressLine) > 0 AND LEN(x.SuiteOrUnitAddressLine) = 0
                        THEN x.CityStateZipAddressLine
                    WHEN LEN(x.AdditionalAddressLine) = 0 AND LEN(x.SuiteOrUnitAddressLine) > 0
                        THEN x.CityStateZipAddressLine
                    ELSE ''
                    END AS AddressLine3,
                CASE
                    WHEN LEN(x.AdditionalAddressLine) > 0 AND LEN(x.SuiteOrUnitAddressLine) > 0
                        THEN x.CityStateZipAddressLine
                    WHEN LEN(x.AdditionalAddressLine) > 0 AND LEN(x.SuiteOrUnitAddressLine) = 0 THEN ''
                    WHEN LEN(x.AdditionalAddressLine) = 0 AND LEN(x.SuiteOrUnitAddressLine) > 0 THEN ''
                    ELSE ''
                    END AS AddressLine4
         FROM (SELECT ma.MAILINGADDRESSID,
                      ma.ADDRESSTYPE,
                      LTRIM(RTRIM(ma.ADDRESSLINE1)) +
                      IIF(LEN(ma.PREDIRECTION) > 0, ' ' + LTRIM(RTRIM(ma.PREDIRECTION)), '') + ' ' +
                      LTRIM(RTRIM(ma.ADDRESSLINE2)) + ' ' + LTRIM(RTRIM(ma.STREETTYPE)) +
                      IIF(LEN(ma.POSTDIRECTION) > 0, ' ' + LTRIM(RTRIM(ma.POSTDIRECTION)),
                          '')                                   AS StreetAddressLine,
                      LTRIM(RTRIM(ma.UNITORSUITE))              AS SuiteOrUnitAddressLine,
                      LTRIM(RTRIM(
                              REPLACE(REPLACE(REPLACE(ma.CITY, 'CITY OF ', ''), 'TOWN OF ', ''), 'VILLAGE OF ', ''))) +
                      ' ' + LTRIM(RTRIM(ma.STATE)) + ' ' +
                      LTRIM(RTRIM(IIF(LEN(ma.POSTALCODE) = 9, LEFT(ma.POSTALCODE, 5) + '-' + RIGHT(ma.POSTALCODE, 4),
                                      LEFT(ma.POSTALCODE, 5)))) AS CityStateZipAddressLine,
                      LTRIM(RTRIM(ISNULL(ma.ADDRESSLINE3, ''))) AS AdditionalAddressLine
               FROM [$(EnerGovDatabase)].[dbo].MAILINGADDRESS ma) x
     ),
     BusinessAddresses AS (
         SELECT blgee.DBA,
                blgee.REGISTRATIONID,
                ge.GLOBALENTITYNAME,
                buis.BLGLOBALENTITYEXTENSIONID,
                (SELECT COUNT(*)
                 FROM [$(EnerGovDatabase)].[dbo].MAILINGADDRESS ma
                          INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONADDRESS gema ON ma.MAILINGADDRESSID = gema.MAILINGADDRESSID
                 WHERE gema.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID
                   AND ma.ADDRESSTYPE = 'License Mailing')                               AS LicenseMailingAddressCount,
                (SELECT COUNT(*)
                 FROM [$(EnerGovDatabase)].[dbo].MAILINGADDRESS ma
                          INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONADDRESS gema ON ma.MAILINGADDRESSID = gema.MAILINGADDRESSID
                 WHERE gema.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID
                   AND ma.ADDRESSTYPE = 'Renewal Mailing')                               AS RenewalMailingAddressCount,
                (SELECT TOP 1 ma.AddressLine1
                 FROM MailingAddresses ma
                          INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONADDRESS gema ON ma.MAILINGADDRESSID = gema.MAILINGADDRESSID
                 WHERE gema.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID
                   AND ma.ADDRESSTYPE = 'License Mailing')                               AS LicenseMailingAddressLine1,
                (SELECT TOP 1 ma.AddressLine2
                 FROM MailingAddresses ma
                          INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONADDRESS gema ON ma.MAILINGADDRESSID = gema.MAILINGADDRESSID
                 WHERE gema.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID
                   AND ma.ADDRESSTYPE = 'License Mailing')                               AS LicenseMailingAddressLine2,
                (SELECT TOP 1 ma.AddressLine3
                 FROM MailingAddresses ma
                          INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONADDRESS gema ON ma.MAILINGADDRESSID = gema.MAILINGADDRESSID
                 WHERE gema.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID
                   AND ma.ADDRESSTYPE = 'License Mailing')                               AS LicenseMailingAddressLine3,
                (SELECT TOP 1 ma.AddressLine4
                 FROM MailingAddresses ma
                          INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONADDRESS gema ON ma.MAILINGADDRESSID = gema.MAILINGADDRESSID
                 WHERE gema.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID
                   AND ma.ADDRESSTYPE = 'License Mailing')                               AS LicenseMailingAddressLine4,
                (SELECT TOP 1 ma.AddressLine1
                 FROM MailingAddresses ma
                          INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONADDRESS gema ON ma.MAILINGADDRESSID = gema.MAILINGADDRESSID
                 WHERE gema.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID
                   AND ma.ADDRESSTYPE = 'Renewal Mailing')                               AS RenewalMailingAddressLine1,
                (SELECT TOP 1 ma.AddressLine2
                 FROM MailingAddresses ma
                          INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONADDRESS gema ON ma.MAILINGADDRESSID = gema.MAILINGADDRESSID
                 WHERE gema.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID
                   AND ma.ADDRESSTYPE = 'Renewal Mailing')                               AS RenewalMailingAddressLine2,
                (SELECT TOP 1 ma.AddressLine3
                 FROM MailingAddresses ma
                          INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONADDRESS gema ON ma.MAILINGADDRESSID = gema.MAILINGADDRESSID
                 WHERE gema.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID
                   AND ma.ADDRESSTYPE = 'Renewal Mailing')                               AS RenewalMailingAddressLine3,
                (SELECT TOP 1 ma.AddressLine4
                 FROM MailingAddresses ma
                          INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONADDRESS gema ON ma.MAILINGADDRESSID = gema.MAILINGADDRESSID
                 WHERE gema.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID
                   AND ma.ADDRESSTYPE = 'Renewal Mailing')                               AS RenewalMailingAddressLine4,
                (SELECT TOP 1 ma.AddressLine1
                 FROM MailingAddresses ma
                          INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONADDRESS gema ON ma.MAILINGADDRESSID = gema.MAILINGADDRESSID
                 WHERE gema.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID) AS LocationAddressLine1,
                (SELECT TOP 1 ma.AddressLine2
                 FROM MailingAddresses ma
                          INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONADDRESS gema ON ma.MAILINGADDRESSID = gema.MAILINGADDRESSID
                 WHERE gema.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID) AS LocationAddressLine2,
                (SELECT TOP 1 ma.AddressLine3
                 FROM MailingAddresses ma
                          INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONADDRESS gema ON ma.MAILINGADDRESSID = gema.MAILINGADDRESSID
                 WHERE gema.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID) AS LocationAddressLine3,
                (SELECT TOP 1 ma.AddressLine4
                 FROM MailingAddresses ma
                          INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONADDRESS gema ON ma.MAILINGADDRESSID = gema.MAILINGADDRESSID
                 WHERE gema.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID) AS LocationAddressLine4
         FROM Businesses buis
                  INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSION blgee
                             ON buis.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID
                  INNER JOIN [$(EnerGovDatabase)].[dbo].GLOBALENTITY ge ON blgee.GLOBALENTITYID = ge.GLOBALENTITYID),
     AgentsOrManagers AS (
         SELECT buis.BLGLOBALENTITYEXTENSIONID,
                (SELECT TOP 1 ge.FIRSTNAME
                 FROM [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONCONTACT blgeec
                          INNER JOIN [$(EnerGovDatabase)].[dbo].GLOBALENTITY ge ON blgeec.GLOBALENTITYID = ge.GLOBALENTITYID
                 WHERE blgeec.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
                   AND blgeec.BLCONTACTTYPEID = '1f76e1b7-7d57-41a2-a777-30bb098f01b5') AS AgentFirstName,
                (SELECT TOP 1 ge.LASTNAME
                 FROM [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONCONTACT blgeec
                          INNER JOIN [$(EnerGovDatabase)].[dbo].GLOBALENTITY ge ON blgeec.GLOBALENTITYID = ge.GLOBALENTITYID
                 WHERE blgeec.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
                   AND blgeec.BLCONTACTTYPEID = '1f76e1b7-7d57-41a2-a777-30bb098f01b5') AS AgentLastName,
                (SELECT TOP 1 ge.FIRSTNAME
                 FROM [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONCONTACT blgeec
                          INNER JOIN [$(EnerGovDatabase)].[dbo].GLOBALENTITY ge ON blgeec.GLOBALENTITYID = ge.GLOBALENTITYID
                 WHERE blgeec.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
                   AND blgeec.BLCONTACTTYPEID = 'f33af855-38af-4c5f-aada-a4aa9967d132') AS ManagerFirstName,
                (SELECT TOP 1 ge.LASTNAME
                 FROM [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONCONTACT blgeec
                          INNER JOIN [$(EnerGovDatabase)].[dbo].GLOBALENTITY ge ON blgeec.GLOBALENTITYID = ge.GLOBALENTITYID
                 WHERE blgeec.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
                   AND blgeec.BLCONTACTTYPEID = 'f33af855-38af-4c5f-aada-a4aa9967d132') AS ManagerLastName,
                (SELECT TOP 1 ge.FIRSTNAME
                 FROM [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONCONTACT blgeec
                          INNER JOIN [$(EnerGovDatabase)].[dbo].GLOBALENTITY ge ON blgeec.GLOBALENTITYID = ge.GLOBALENTITYID
                 WHERE blgeec.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
                   AND blgeec.BLCONTACTTYPEID = '102dcef5-48b6-4bc1-8d29-237e249c93b1') AS IndividualFirstName,
                (SELECT TOP 1 ge.LASTNAME
                 FROM [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONCONTACT blgeec
                          INNER JOIN [$(EnerGovDatabase)].[dbo].GLOBALENTITY ge ON blgeec.GLOBALENTITYID = ge.GLOBALENTITYID
                 WHERE blgeec.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
                   AND blgeec.BLCONTACTTYPEID = '102dcef5-48b6-4bc1-8d29-237e249c93b1') AS IndividualLastName,
                (SELECT TOP 1 ge.FIRSTNAME
                 FROM [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONCONTACT blgeec
                          INNER JOIN [$(EnerGovDatabase)].[dbo].GLOBALENTITY ge ON blgeec.GLOBALENTITYID = ge.GLOBALENTITYID
                 WHERE blgeec.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
                   AND blgeec.BLCONTACTTYPEID = '8143cbdf-c524-4e8c-a891-975f8c5458f9') AS ApplicantFirstName,
                (SELECT TOP 1 ge.LASTNAME
                 FROM [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONCONTACT blgeec
                          INNER JOIN [$(EnerGovDatabase)].[dbo].GLOBALENTITY ge ON blgeec.GLOBALENTITYID = ge.GLOBALENTITYID
                 WHERE blgeec.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
                   AND blgeec.BLCONTACTTYPEID = '8143cbdf-c524-4e8c-a891-975f8c5458f9') AS ApplicantLastName,
                (SELECT TOP 1 ge.FIRSTNAME
                 FROM [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONCONTACT blgeec
                          INNER JOIN [$(EnerGovDatabase)].[dbo].GLOBALENTITY ge ON blgeec.GLOBALENTITYID = ge.GLOBALENTITYID
                 WHERE blgeec.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
                   AND blgeec.BLCONTACTTYPEID = 'e87c4fa4-dc69-40b3-802f-9e6eba3e1808') AS OwnerFirstName,
                (SELECT TOP 1 ge.LASTNAME
                 FROM [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSIONCONTACT blgeec
                          INNER JOIN [$(EnerGovDatabase)].[dbo].GLOBALENTITY ge ON blgeec.GLOBALENTITYID = ge.GLOBALENTITYID
                 WHERE blgeec.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
                   AND blgeec.BLCONTACTTYPEID = 'e87c4fa4-dc69-40b3-802f-9e6eba3e1808') AS OwnerLastName
         FROM Businesses buis
                  INNER JOIN [$(EnerGovDatabase)].[dbo].BLGLOBALENTITYEXTENSION blgee
                             ON buis.BLGLOBALENTITYEXTENSIONID = blgee.BLGLOBALENTITYEXTENSIONID
     ), FinalAddresses AS (
SELECT ba.REGISTRATIONID                      AS BusinessNumber,
       ba.GLOBALENTITYNAME                    AS CompanyName,
       ba.DBA                                 AS DBA,
       ba.BLGLOBALENTITYEXTENSIONID           AS BusinessId,
       'ATTN: ' + IIF(aom.AgentLastName IS NOT NULL, aom.AgentFirstName + ' ' + aom.AgentLastName,
                      IIF(aom.ManagerLastName IS NOT NULL, aom.ManagerFirstName + ' ' + aom.ManagerLastName,
                          IIF(aom.IndividualLastName IS NOT NULL,
                              aom.IndividualFirstName + ' ' + aom.IndividualLastName,
                              IIF(aom.ApplicantLastName IS NOT NULL,
                                  aom.ApplicantFirstName + ' ' + aom.ApplicantLastName,
                                  IIF(aom.OwnerLastName IS NOT NULL, aom.OwnerFirstName + ' ' + aom.OwnerLastName,
                                      ''))))) AS AttentionLine,
       IIF(ba.RenewalMailingAddressCount > 0,
           ba.RenewalMailingAddressLine1,
           IIF(ba.LicenseMailingAddressCount > 0,
               ba.LicenseMailingAddressLine1,
               ba.LocationAddressLine1))      AS RenewalMailingAddressLine1,
       IIF(ba.RenewalMailingAddressCount > 0,
           ba.RenewalMailingAddressLine2,
           IIF(ba.LicenseMailingAddressCount > 0,
               ba.LicenseMailingAddressLine2,
               ba.LocationAddressLine2))      AS RenewalMailingAddressLine2,
       IIF(ba.RenewalMailingAddressCount > 0,
           ba.RenewalMailingAddressLine3,
           IIF(ba.LicenseMailingAddressCount > 0,
               ba.LicenseMailingAddressLine3,
               ba.LocationAddressLine3))      AS RenewalMailingAddressLine3,
       IIF(ba.RenewalMailingAddressCount > 0,
           ba.RenewalMailingAddressLine4,
           IIF(ba.LicenseMailingAddressCount > 0,
               ba.LicenseMailingAddressLine4,
               ba.LocationAddressLine4))      AS RenewalMailingAddressLine4,
       IIF(ba.LicenseMailingAddressCount > 0,
           ba.LicenseMailingAddressLine1,
           IIF(ba.RenewalMailingAddressCount > 0,
               ba.RenewalMailingAddressLine1,
               ba.LocationAddressLine1))      AS LicenseMailingAddressLine1,
       IIF(ba.LicenseMailingAddressCount > 0,
           ba.LicenseMailingAddressLine2,
           IIF(ba.RenewalMailingAddressCount > 0,
               ba.RenewalMailingAddressLine2,
               ba.LocationAddressLine2))      AS LicenseMailingAddressLine2,
       IIF(ba.LicenseMailingAddressCount > 0,
           ba.LicenseMailingAddressLine3,
           IIF(ba.RenewalMailingAddressCount > 0,
               ba.RenewalMailingAddressLine3,
               ba.LocationAddressLine3))      AS LicenseMailingAddressLine3,
       IIF(ba.LicenseMailingAddressCount > 0,
           ba.LicenseMailingAddressLine4,
           IIF(ba.RenewalMailingAddressCount > 0,
               ba.RenewalMailingAddressLine4,
               ba.LocationAddressLine4))      AS LicenseMailingAddressLine4
FROM BusinessAddresses ba
         INNER JOIN AgentsOrManagers aom ON ba.BLGLOBALENTITYEXTENSIONID = aom.BLGLOBALENTITYEXTENSIONID)

SELECT
    x.LicenseNumber,
    x.DBA,
    x.BuisnessNumber,
    x.CompanyNumber,
    x.Name,
    x.Email,
    x.BuisinessPhone,
    x.HomePhone,
    x.MobilePhone,
    x.OtherPhone,
    x.FaxNumber,
    x.FirstName,
    x.LastName,
    x.LicenseAddressLine1,
    x.LicenseAddressLine2,
    x.LicenseAddressLine3,
    x.LicenseCity,
    x.LicenseState,
    x.LicenseZipCode,
    x.LicensePostDirection,
    x.LicensePreDirection,
    x.LicenseStreetType,
    x.LicenseTypeName,
    x.LicenseClassName,
    x.AlcoholStoragePremise,
    x.AlcoholSalesAndServicePremise,
    x.BeerGardenDescription,
    x.IndoorCabaretDescription,
    x.OutdoorCabaretDescription,
    x.GlobalEntityId,
    x.IssuedDate,
    x.ExpirationDate,
    x.DisplayName,
    CAST(x.UseAgentName AS bit) AS UseAgentName,
    CAST(x.UseAlcoholPremiseDescription AS bit) AS UseAlcoholPremiseDescription,
    CAST(x.UseBeerGardenPremiseDescription AS bit) AS UseBeerGardenPremiseDescription,
    CAST(x.UseIndoorCabaretDescription AS bit) AS UseIndoorCabaretDescription,
    CAST(x.UseOutdoorCabaretDescription AS bit) AS UseOutdoorCabaretDescription,
    CAST(x.UseJunkDealerLogic AS bit) AS UseJunkDealerLogic,
    CAST(x.UseRecyclingFacilityLicenseSubClass AS bit) AS UseRecyclingFacilityLicenseSubClass,
    CAST(x.UseSecondhandLicenseLogic AS bit) AS UseSecondhandLicenseLogic,
    CAST(x.JunkDealer1000FootWaiver AS bit) AS JunkDealer1000FootWaiver,
    CAST(x.JunkWaiverExpirationDate AS datetime) AS JunkWaiverExpirationDate,
    CAST(x.AdditionalText AS NVARCHAR(1000)) AS AdditionalText,
    x.AgentFullName,
    x.LicenseMailingAddressLine1,
    x.LicenseMailingAddressLine2,
    x.LicenseMailingAddressLine3,
    x.LicenseMailingAddressLine4,
    x.LicenseMailingAttentionLine
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
       '' AS LicenseAddressLine1,
       '' AS LicenseAddressLine2,
       '' AS LicenseAddressLine3,
       '' AS LicenseCity,
       '' AS LicenseState,
       '' AS LicenseZipCode,
       '' AS LicensePostDirection,
       '' AS LicensePreDirection,
       '' AS LicenseStreetType,
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
       bltci.UseAgentName AS UseAgentName,
	   bltci.UseAlcoholPremiseDescription AS UseAlcoholPremiseDescription,
	   bltci.UseBeerGardenPremiseDescription AS UseBeerGardenPremiseDescription,
	   bltci.UseIndoorCabaretDescription AS UseIndoorCabaretDescription,
	   bltci.UseOutdoorCabaretDescription AS UseOutdoorCabaretDescription,
       bltci.UseJunkDealerLogic AS UseJunkDealerLogic,
       bltci.UseRecyclingFacilityLicenseSubClass AS UseRecyclingFacilityLicenseSubClass,
       bltci.UseSecondhandLicenseLogic AS UseSecondhandLicenseLogic,
       ISNULL(cslm.JunkDealer1000FootWaiver, 0) AS JunkDealer1000FootWaiver,
       cslm.JunkWaiverExpirationDate AS JunkWaiverExpirationDate,
       CAST(bltci.[AdditionalText] AS NVARCHAR(1000)) AS AdditionalText,
	   (SELECT TOP 1 agentge.FIRSTNAME + ' ' + agentge.LASTNAME AS FullName 
                FROM [$(EnerGovDatabase)].dbo.GLOBALENTITY agentge 
                INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSECONTACT bllc ON agentge.GLOBALENTITYID = bllc.GLOBALENTITYID 
                WHERE bllc.BLCONTACTTYPEID = '1f76e1b7-7d57-41a2-a777-30bb098f01b5' AND bllc.BLLICENSEID = bll.BLLICENSEID) AS AgentFullName,
       (SELECT TOP 1 
                fa.LicenseMailingAddressLine1
            FROM FinalAddresses fa
            WHERE fa.BusinessId = buis.BLGLOBALENTITYEXTENSIONID) AS LicenseMailingAddressLine1,
       (SELECT TOP 1 
                fa.LicenseMailingAddressLine2
            FROM FinalAddresses fa
            WHERE fa.BusinessId = buis.BLGLOBALENTITYEXTENSIONID) AS LicenseMailingAddressLine2,
       (SELECT TOP 1 
                fa.LicenseMailingAddressLine3
            FROM FinalAddresses fa
            WHERE fa.BusinessId = buis.BLGLOBALENTITYEXTENSIONID) AS LicenseMailingAddressLine3,
       (SELECT TOP 1 
                fa.LicenseMailingAddressLine4
            FROM FinalAddresses fa
            WHERE fa.BusinessId = buis.BLGLOBALENTITYEXTENSIONID) AS LicenseMailingAddressLine4
            ,
       (SELECT TOP 1 
                fa.AttentionLine
            FROM FinalAddresses fa
            WHERE fa.BusinessId = buis.BLGLOBALENTITYEXTENSIONID) AS LicenseMailingAttentionLine
FROM [$(EnerGovDatabase)].dbo.BLLICENSE bll
INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSETYPE bllt ON bll.BLLICENSETYPEID = bllt.BLLICENSETYPEID
INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSECLASS bllc ON bll.BLLICENSECLASSID = bllc.BLLICENSECLASSID
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERLICENSEMANAGEMENT cslm ON bll.BLLICENSEID = cslm.ID
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERLICENSEMANAGEMENTMS cslmms ON bll.BLLICENSEID = cslmms.ID
INNER JOIN [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSION buis ON bll.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.GLOBALENTITY glent ON buis.GLOBALENTITYID = glent.GLOBALENTITYID
--INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSEADDRESS blladdr ON bll.BLLICENSEID = blladdr.BLLICENSEID AND blladdr.MAIN = 1
--INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS blladdr_mailaddr ON blladdr.MAILINGADDRESSID = blladdr_mailaddr.MAILINGADDRESSID AND blladdr_mailaddr.ADDRESSTYPE = 'Location'
INNER JOIN [laxreports].[BusinessLicenseTypeClassInformation] bltci ON 
            bll.BLLICENSETYPEID = bltci.LicenseTypeId AND 
            bll.BLLICENSECLASSID = bltci.LicenseClassId AND
            (bltci.UseJunkDealerLogic = 0 OR (bltci.UseJunkDealerLogic = 1 AND cslm.JunkDealerLicenseType = bltci.PickListItemId)) AND
            (bltci.UseRecyclingFacilityLicenseSubClass = 0 OR (bltci.UseRecyclingFacilityLicenseSubClass = 1 AND cslmms.CUSTOMFIELDPICKLISTITEMID = bltci.PickListItemId)) AND
            (bltci.UseSecondhandLicenseLogic = 0 OR (bltci.UseSecondhandLicenseLogic = 1 AND cslmms.CUSTOMFIELDPICKLISTITEMID = bltci.PickListItemId))
WHERE bll.TAXYEAR = @LicenseYear AND bll.BLLICENSESTATUSID = @BLLICENSESTATUSID

	UNION ALL

SELECT
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
       (SELECT TOP 1 blladdr_mailaddr.ADDRESSLINE1
            FROM [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSIONADDRESS blladdr
            INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS blladdr_mailaddr ON
                blladdr.MAILINGADDRESSID = blladdr_mailaddr.MAILINGADDRESSID AND 
                blladdr_mailaddr.ADDRESSTYPE = 'Location'
           WHERE blladdr.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID AND blladdr.MAIN = 1) AS LicenseAddressLine1,
       (SELECT TOP 1 blladdr_mailaddr.ADDRESSLINE2
            FROM [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSIONADDRESS blladdr
            INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS blladdr_mailaddr ON
                blladdr.MAILINGADDRESSID = blladdr_mailaddr.MAILINGADDRESSID AND 
                blladdr_mailaddr.ADDRESSTYPE = 'Location'
           WHERE blladdr.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID AND blladdr.MAIN = 1) AS LicenseAddressLine2,
       (SELECT TOP 1 blladdr_mailaddr.ADDRESSLINE3
            FROM [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSIONADDRESS blladdr
            INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS blladdr_mailaddr ON
                blladdr.MAILINGADDRESSID = blladdr_mailaddr.MAILINGADDRESSID AND 
                blladdr_mailaddr.ADDRESSTYPE = 'Location'
           WHERE blladdr.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID AND blladdr.MAIN = 1) AS LicenseAddressLine3,
       (SELECT TOP 1 blladdr_mailaddr.CITY
            FROM [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSIONADDRESS blladdr
            INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS blladdr_mailaddr ON
                blladdr.MAILINGADDRESSID = blladdr_mailaddr.MAILINGADDRESSID AND 
                blladdr_mailaddr.ADDRESSTYPE = 'Location'
           WHERE blladdr.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID AND blladdr.MAIN = 1) AS LicenseCity,
       (SELECT TOP 1 blladdr_mailaddr.STATE
            FROM [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSIONADDRESS blladdr
            INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS blladdr_mailaddr ON
                blladdr.MAILINGADDRESSID = blladdr_mailaddr.MAILINGADDRESSID AND 
                blladdr_mailaddr.ADDRESSTYPE = 'Location'
           WHERE blladdr.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID AND blladdr.MAIN = 1) AS LicenseState,
       (SELECT TOP 1 blladdr_mailaddr.POSTALCODE
            FROM [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSIONADDRESS blladdr
            INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS blladdr_mailaddr ON
                blladdr.MAILINGADDRESSID = blladdr_mailaddr.MAILINGADDRESSID AND 
                blladdr_mailaddr.ADDRESSTYPE = 'Location'
           WHERE blladdr.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID AND blladdr.MAIN = 1) AS LicenseZipCode,
       (SELECT TOP 1 blladdr_mailaddr.POSTDIRECTION
            FROM [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSIONADDRESS blladdr
            INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS blladdr_mailaddr ON
                blladdr.MAILINGADDRESSID = blladdr_mailaddr.MAILINGADDRESSID AND 
                blladdr_mailaddr.ADDRESSTYPE = 'Location'
           WHERE blladdr.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID AND blladdr.MAIN = 1) AS LicensePostDirection,
       (SELECT TOP 1 blladdr_mailaddr.PREDIRECTION
            FROM [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSIONADDRESS blladdr
            INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS blladdr_mailaddr ON
                blladdr.MAILINGADDRESSID = blladdr_mailaddr.MAILINGADDRESSID AND 
                blladdr_mailaddr.ADDRESSTYPE = 'Location'
           WHERE blladdr.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID AND blladdr.MAIN = 1) AS LicensePreDirection,
       (SELECT TOP 1 blladdr_mailaddr.STREETTYPE
            FROM [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSIONADDRESS blladdr
            INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS blladdr_mailaddr ON
                blladdr.MAILINGADDRESSID = blladdr_mailaddr.MAILINGADDRESSID AND 
                blladdr_mailaddr.ADDRESSTYPE = 'Location'
           WHERE blladdr.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID AND blladdr.MAIN = 1) AS LicenseStreetType,
       '' AS LicenseTypeName,
       '' AS LicenseClassName,
       '' AS AlcoholStoragePremise,
       '' AS AlcoholSalesAndServicePremise,
       '' AS BeerGardenDescription,
       '' AS IndoorCabaretDescription,
       '' AS OutdoorCabaretDescription,
	   glent.GLOBALENTITYID AS GlobalEntityId,
	   NULL AS IssuedDate,
	   NULL AS ExpirationDate,
	   '' AS DisplayName,
       0 AS UseAgentName,
	   0 AS UseAlcoholPremiseDescription,
	   0 AS UseBeerGardenPremiseDescription,
	   0 AS UseIndoorCabaretDescription,
	   0 AS UseOutdoorCabaretDescription,
       0 AS UseJunkDealerLogic,
       0 AS UseRecyclingFacilityLicenseSubClass,
       0 AS UseSecondhandLicenseLogic,
       0 AS JunkDealer1000FootWaiver,
       NULL AS JunkWaiverExpirationDate,
       CAST('' AS NVARCHAR(1000)) AS AdditionalText,
	   '' AS AgentFullName,
       (SELECT TOP 1 
                fa.LicenseMailingAddressLine1
            FROM FinalAddresses fa
            WHERE fa.BusinessId = buis.BLGLOBALENTITYEXTENSIONID) AS LicenseMailingAddressLine1,
       (SELECT TOP 1 
                fa.LicenseMailingAddressLine2
            FROM FinalAddresses fa
            WHERE fa.BusinessId = buis.BLGLOBALENTITYEXTENSIONID) AS LicenseMailingAddressLine2,
       (SELECT TOP 1 
                fa.LicenseMailingAddressLine3
            FROM FinalAddresses fa
            WHERE fa.BusinessId = buis.BLGLOBALENTITYEXTENSIONID) AS LicenseMailingAddressLine3,
       (SELECT TOP 1 
                fa.LicenseMailingAddressLine4
            FROM FinalAddresses fa
            WHERE fa.BusinessId = buis.BLGLOBALENTITYEXTENSIONID) AS LicenseMailingAddressLine4
            ,
       (SELECT TOP 1 
                fa.AttentionLine
            FROM FinalAddresses fa
            WHERE fa.BusinessId = buis.BLGLOBALENTITYEXTENSIONID) AS LicenseMailingAttentionLine
FROM [$(EnerGovDatabase)].dbo.BLLICENSE bll
INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSETYPE bllt ON bll.BLLICENSETYPEID = bllt.BLLICENSETYPEID
INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSECLASS bllc ON bll.BLLICENSECLASSID = bllc.BLLICENSECLASSID
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERLICENSEMANAGEMENT cslm ON bll.BLLICENSEID = cslm.ID
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.CUSTOMSAVERLICENSEMANAGEMENTMS cslmms ON bll.BLLICENSEID = cslmms.ID
INNER JOIN [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSION buis ON bll.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.GLOBALENTITY glent ON buis.GLOBALENTITYID = glent.GLOBALENTITYID
--INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSEADDRESS blladdr ON bll.BLLICENSEID = blladdr.BLLICENSEID AND blladdr.MAIN = 1
--INNER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS blladdr_mailaddr ON blladdr.MAILINGADDRESSID = blladdr_mailaddr.MAILINGADDRESSID AND blladdr_mailaddr.ADDRESSTYPE = 'Location'
INNER JOIN [laxreports].[BusinessLicenseTypeClassInformation] bltci ON 
            bll.BLLICENSETYPEID = bltci.LicenseTypeId AND 
            bll.BLLICENSECLASSID = bltci.LicenseClassId AND
            (bltci.UseJunkDealerLogic = 0 OR (bltci.UseJunkDealerLogic = 1 AND cslm.JunkDealerLicenseType = bltci.PickListItemId)) AND
            (bltci.UseRecyclingFacilityLicenseSubClass = 0 OR (bltci.UseRecyclingFacilityLicenseSubClass = 1 AND cslmms.CUSTOMFIELDPICKLISTITEMID = bltci.PickListItemId)) AND
            (bltci.UseSecondhandLicenseLogic = 0 OR (bltci.UseSecondhandLicenseLogic = 1 AND cslmms.CUSTOMFIELDPICKLISTITEMID = bltci.PickListItemId))
WHERE bll.TAXYEAR = @LicenseYear AND bll.BLLICENSESTATUSID = @BLLICENSESTATUSID) x
GROUP BY x.LicenseNumber, x.DBA, x.BuisnessNumber, x.CompanyNumber, x.Name, x.Email, x.BuisinessPhone, x.HomePhone, x.MobilePhone, x.OtherPhone, x.FaxNumber, x.FirstName, x.LastName,
            x.LicenseAddressLine1, x.LicenseAddressLine2, x.LicenseAddressLine3, x.LicenseCity, x.LicenseState, x.LicenseZipCode, x.LicensePostDirection, x.LicensePreDirection,
            x.LicenseStreetType, x.LicenseTypeName, x.LicenseClassName, x.AlcoholStoragePremise, x.AlcoholSalesAndServicePremise, x.BeerGardenDescription, x.IndoorCabaretDescription,
            x.OutdoorCabaretDescription, x.GlobalEntityId, x.IssuedDate, x.ExpirationDate, x.DisplayName, x.UseAgentName, x.UseAlcoholPremiseDescription, x.UseBeerGardenPremiseDescription, 
            x.UseIndoorCabaretDescription, x.UseOutdoorCabaretDescription, x.UseJunkDealerLogic, x.UseRecyclingFacilityLicenseSubClass, x.UseSecondhandLicenseLogic, 
            x.JunkDealer1000FootWaiver, x.JunkWaiverExpirationDate, x.AgentFullName, x.LicenseMailingAddressLine1, x.LicenseMailingAddressLine2, x.LicenseMailingAddressLine3, x.LicenseMailingAddressLine4,
            x.LicenseMailingAttentionLine, x.AdditionalText
ORDER BY x.Name, x.DBA, x.BuisnessNumber, x.LicenseNumber