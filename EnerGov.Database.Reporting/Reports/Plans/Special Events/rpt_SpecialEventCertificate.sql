CREATE PROCEDURE [dbo].[rpt_SpecialEventCertificate]
	@PLPLANID AS char(36)
AS
SELECT
    '<p>Whereas, the City of La Crosse, County of La Crosse, Wisconsin, has, upon application duly made, authorized the issuance of the license(s) indicated below to <b>' +
        x.OrganizationFullName + ' - ' + x.EventName + '</b> as defined by law, pursuant to Wisconsin State Statutes and/or local Ordinances; and</p><br>' +
        '<p>Whereas, the said applicant has paid the Treasurer the sum indicated below for the license(s) indicated as required by Wisconsin State Statutes and/or local Ordinances,' +
        ' and has complied with all the requirements necessary for obtaining such license(s);</p><br>' +
        '<p>The following license(s) for the period of <b>' + x.LicenseTimePeriod + '</b> are herby issued to said applicant for the premises located at:</p>' AS LicenseText,
    x.PLANNUMBER + ': <b>' + x.LicenseDescription + '</b> <i>' + x.LicenseSubDescription + '</i>' AS LicenseDescription,
    'Manager/Person in Charge: ' + x.ManagerFullName + '<br>Premise Description: ' + x.PremiseDescription AS LicenseDetails,
    '' AS LicenseTitle,
    x.PremiseLocation,
    x.LicenseBottomAlert,
    x.PLANNUMBER + '-TALC' AS LicenseNumber
FROM (SELECT plp.PLANNUMBER,
           cspm.EventName AS EventName,
           ISNULL((SELECT TOP 1 managerge.FIRSTNAME + ' ' + managerge.LASTNAME AS FullName
               FROM [$(EnerGovDatabase)].dbo.GLOBALENTITY managerge
               INNER JOIN [$(EnerGovDatabase)].dbo.PLPLANCONTACT plpc ON managerge.GLOBALENTITYID = plpc.GLOBALENTITYID
               WHERE plpc.LANDMANAGEMENTCONTACTTYPEID = '48d24037-d37e-b5e4-7a98-191807d09cc4' AND plpc.PLPLANID = plp.PLPLANID), '[ERROR: No Alcohol Manager contact!]') AS ManagerFullName,
           ISNULL((SELECT TOP 1 managerge.GLOBALENTITYNAME AS FullName
               FROM [$(EnerGovDatabase)].dbo.GLOBALENTITY managerge
               INNER JOIN [$(EnerGovDatabase)].dbo.PLPLANCONTACT plpc ON managerge.GLOBALENTITYID = plpc.GLOBALENTITYID
               WHERE plpc.LANDMANAGEMENTCONTACTTYPEID = '53523ba0-fb50-d70d-2633-2aef45903eb2' AND plpc.PLPLANID = plp.PLPLANID), '[ERROR: No Alcohol Organization contact!]') AS OrganizationFullName,
           ISNULL(cspm.PremiseDescriptionQuestion, '') AS PremiseDescription,
           ISNULL(cspm.PremiseDescriptionStorageQuestion, '') AS PremiseStorageDescription,
           ISNULL(cspm.TemporaryClassBTimePeriod, '') AS LicenseTimePeriod,
           CASE cspm.TemporaryClassBLicenseType
                WHEN '0effd538-695c-b8e9-8a49-16698491bd50' THEN 'Temporary Class "B" Retailer''s License'
                WHEN 'c224ea5b-a9b8-21d3-8ffc-9d3e9472fea0' THEN 'Temporary "Class B" Retailer''s License'
                WHEN 'c9c54ca6-e435-9e94-4d1e-65a090058711' THEN 'Temporary "Class B"/Class "B" Retailer''s License'
                ELSE ''
           END AS LicenseDescription,
           CASE cspm.TemporaryClassBLicenseType
                WHEN '0effd538-695c-b8e9-8a49-16698491bd50' THEN '(To sell fermented malt beverages only)'
                WHEN 'c224ea5b-a9b8-21d3-8ffc-9d3e9472fea0' THEN '(To sell wine only)'
                WHEN 'c9c54ca6-e435-9e94-4d1e-65a090058711' THEN '(To sell fermented malt beverages and wine)'
                ELSE ''
           END AS LicenseSubDescription,
           CASE cspm.TemporaryClassBLicenseType
                WHEN '0effd538-695c-b8e9-8a49-16698491bd50' THEN '**Fermented malt beverages must be purchased from a licensed wholesaler or a permitted brewery or brewpub authorized to sell directly to retailers.**'
                WHEN 'c224ea5b-a9b8-21d3-8ffc-9d3e9472fea0' THEN '**Wine must be purchased from a licensed wholesaler or a permitted brewery or brewpub authorized to sell directly to retailers.**'
                WHEN 'c9c54ca6-e435-9e94-4d1e-65a090058711' THEN '**Fermented malt beverages and wine must be purchased from a licensed wholesaler or a permitted brewery or brewpub authorized to sell directly to retailers.**'
                ELSE ''
           END AS LicenseBottomAlert,
           IIF(plpaddr_mailaddr.MAILINGADDRESSID IS NULL,
               '[ERROR: No address of type Location and marked as the main address!]',
               LTRIM(RTRIM(plpaddr_mailaddr.ADDRESSLINE1)) +
               IIF(LEN(plpaddr_mailaddr.PREDIRECTION) > 0, ' ' + LTRIM(RTRIM(plpaddr_mailaddr.PREDIRECTION)), '') + ' ' +
               LTRIM(RTRIM(plpaddr_mailaddr.ADDRESSLINE2)) + ' ' + LTRIM(RTRIM(plpaddr_mailaddr.STREETTYPE)) +
               IIF(LEN(plpaddr_mailaddr.POSTDIRECTION) > 0, ' ' + LTRIM(RTRIM(plpaddr_mailaddr.POSTDIRECTION)), '') +
               IIF(LEN(plpaddr_mailaddr.UNITORSUITE) > 0, ' ' + LTRIM(RTRIM(plpaddr_mailaddr.UNITORSUITE)), '')) AS PremiseLocation
    FROM [$(EnerGovDatabase)].[dbo].PLPLAN plp
            LEFT OUTER JOIN [$(EnerGovDatabase)].[dbo].CUSTOMSAVERPLANMANAGEMENT cspm ON cspm.ID = plp.PLPLANID
            LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.PLPLANADDRESS plpaddr ON plp.PLPLANID = plpaddr.PLPLANID AND plpaddr.MAIN = 1
            LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS plpaddr_mailaddr ON plpaddr.MAILINGADDRESSID = plpaddr_mailaddr.MAILINGADDRESSID AND plpaddr_mailaddr.ADDRESSTYPE = 'Location'
    WHERE plp.PLPLANID = @PLPLANID AND
          cspm.TemporaryClassBLicenseType IS NOT NULL AND
          cspm.TemporaryClassBLicenseType <> '6d7771eb-f48b-344b-0aca-9b5bf982e17b') x

UNION ALL
SELECT
    '<p>Whereas, the City of La Crosse, County of La Crosse, Wisconsin, has, upon application duly made, authorized the issuance of the license(s) indicated below to <b>' +
        x.OrganizationFullName + ' - ' + x.EventName + '</b> as defined by law, pursuant to Wisconsin State Statutes and/or local Ordinances; and</p><br>' +
        '<p>Whereas, the said applicant has paid the Treasurer the sum indicated below for the license(s) indicated as required by Wisconsin State Statutes and/or local Ordinances,' +
        ' and has complied with all the requirements necessary for obtaining such license(s);</p><br>' +
        '<p>The following license(s) for the period of <b>' + x.LicenseTimePeriod + '</b> are herby issued to said applicant for the premises located at:</p>' AS LicenseText,
    x.PLANNUMBER + ': <b>' + x.LicenseDescription + '</b>' AS LicenseDescription,
    'Manager/Person in Charge: ' + x.ManagerFullName + '<br>Premise Description: ' + x.PremiseDescription AS LicenseDetails,
    '' AS LicenseTitle,
    x.PremiseLocation,
    x.LicenseBottomAlert,
    x.PLANNUMBER + '-CCM' AS LicenseNumber
FROM (SELECT plp.PLANNUMBER,
           cspm.EventName AS EventName,
           ISNULL((SELECT TOP 1 managerge.FIRSTNAME + ' ' + managerge.LASTNAME AS FullName
               FROM [$(EnerGovDatabase)].dbo.GLOBALENTITY managerge
               INNER JOIN [$(EnerGovDatabase)].dbo.PLPLANCONTACT plpc ON managerge.GLOBALENTITYID = plpc.GLOBALENTITYID
               WHERE plpc.LANDMANAGEMENTCONTACTTYPEID = '0b1ec379-5d97-93a2-a7e2-e5756550abd6' AND plpc.PLPLANID = plp.PLPLANID), '[ERROR: No Carnival Manager contact!]') AS ManagerFullName,
           ISNULL((SELECT TOP 1 managerge.GLOBALENTITYNAME AS FullName
               FROM [$(EnerGovDatabase)].dbo.GLOBALENTITY managerge
               INNER JOIN [$(EnerGovDatabase)].dbo.PLPLANCONTACT plpc ON managerge.GLOBALENTITYID = plpc.GLOBALENTITYID
               WHERE plpc.LANDMANAGEMENTCONTACTTYPEID = '5e2e8a8f-2150-226b-2030-596cbcb67b80' AND plpc.PLPLANID = plp.PLPLANID), '[ERROR: No Carnival Operator contact!]') AS OrganizationFullName,
           ISNULL(cspm.CarnivalPremiseDescription, '') AS PremiseDescription,
           '' AS PremiseStorageDescription,
           ISNULL(cspm.CarnivalTimePeriod, '') AS LicenseTimePeriod,
           CASE WHEN (ISNULL(cspm.HasCarnivalPermit, 0) = 1 AND ISNULL(cspm.HasCircusPermit, 0) = 1 AND ISNULL(cspm.HasMenageriePermit, 0) = 1) THEN 'Carnival, Circus and Menagerie'
                WHEN (ISNULL(cspm.HasCarnivalPermit, 0) = 1 AND ISNULL(cspm.HasCircusPermit, 0) = 1 AND ISNULL(cspm.HasMenageriePermit, 0) = 0) THEN 'Carnival and Circus'
                WHEN (ISNULL(cspm.HasCarnivalPermit, 0) = 1 AND ISNULL(cspm.HasCircusPermit, 0) = 0 AND ISNULL(cspm.HasMenageriePermit, 0) = 1) THEN 'Carnival and Menagerie'
                WHEN (ISNULL(cspm.HasCarnivalPermit, 0) = 0 AND ISNULL(cspm.HasCircusPermit, 0) = 1 AND ISNULL(cspm.HasMenageriePermit, 0) = 1) THEN 'Circus and Menagerie'
                WHEN (ISNULL(cspm.HasCarnivalPermit, 0) = 1 AND ISNULL(cspm.HasCircusPermit, 0) = 0 AND ISNULL(cspm.HasMenageriePermit, 0) = 0) THEN 'Carnival'
                WHEN (ISNULL(cspm.HasCarnivalPermit, 0) = 0 AND ISNULL(cspm.HasCircusPermit, 0) = 1 AND ISNULL(cspm.HasMenageriePermit, 0) = 0) THEN 'Circus'
                WHEN (ISNULL(cspm.HasCarnivalPermit, 0) = 0 AND ISNULL(cspm.HasCircusPermit, 0) = 0 AND ISNULL(cspm.HasMenageriePermit, 0) = 1) THEN 'Menagerie'
                ELSE ''
           END AS LicenseDescription,
           '' AS LicenseSubDescription,
           '' AS LicenseBottomAlert,
           IIF(plpaddr_mailaddr.MAILINGADDRESSID IS NULL,
               '[ERROR: No address of type Location and marked as the main address!]',
               LTRIM(RTRIM(plpaddr_mailaddr.ADDRESSLINE1)) +
               IIF(LEN(plpaddr_mailaddr.PREDIRECTION) > 0, ' ' + LTRIM(RTRIM(plpaddr_mailaddr.PREDIRECTION)), '') + ' ' +
               LTRIM(RTRIM(plpaddr_mailaddr.ADDRESSLINE2)) + ' ' + LTRIM(RTRIM(plpaddr_mailaddr.STREETTYPE)) +
               IIF(LEN(plpaddr_mailaddr.POSTDIRECTION) > 0, ' ' + LTRIM(RTRIM(plpaddr_mailaddr.POSTDIRECTION)), '') +
               IIF(LEN(plpaddr_mailaddr.UNITORSUITE) > 0, ' ' + LTRIM(RTRIM(plpaddr_mailaddr.UNITORSUITE)), '')) AS PremiseLocation
    FROM [$(EnerGovDatabase)].[dbo].PLPLAN plp
            LEFT OUTER JOIN [$(EnerGovDatabase)].[dbo].CUSTOMSAVERPLANMANAGEMENT cspm ON cspm.ID = plp.PLPLANID
            LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.PLPLANADDRESS plpaddr ON plp.PLPLANID = plpaddr.PLPLANID AND plpaddr.MAIN = 1
            LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS plpaddr_mailaddr ON plpaddr.MAILINGADDRESSID = plpaddr_mailaddr.MAILINGADDRESSID AND plpaddr_mailaddr.ADDRESSTYPE = 'Location'
    WHERE plp.PLPLANID = @PLPLANID AND
          (cspm.HasCarnivalPermit = 1 OR cspm.HasCircusPermit = 1 OR cspm.HasMenageriePermit = 1)) x

UNION ALL
SELECT
    '<p>Whereas, the local governing body of the City of La Crosse, County of La Crosse, Wisconsin, has, upon application duly made, granted and authorized' +
        'the issuance of the expansion of license(s) for special event to <b>' + x.CompanyName + '</b> d/b/a <b>' + x.CompanyDBA + '</b> as defined by law, ' +
        'pursuant to Wisconsin State Statutes and/or local Ordinances; and</p><br>' +
        '<p>Whereas, the said applicant has paid the Treasurer for the expansion of license(s) for special event as required by Wisconsin State Statutes and/or ' +
        'local Ordinances, and has complied with all the requirements necessary for obtaining such license(s);</p><br>' +
        '<p>The expansion of the license(s) listed below is for a special event to be held on <b>' + x.LicenseTimePeriod + '</b> and is herby issued to said applicant ' +
        'for the premises described as <b>' + x.PremiseDescription + '</b> located at:' AS LicenseText,
    x.AlcoholLicenseNumber + ': <b>' + x.DisplayName + '</b>' AS LicenseDescription,
    'Agent: ' + x.AgentFullName AS LicenseDetails,
    x.LicenseDescription AS LicenseTitle,
    x.PremiseLocation,
    '' AS LicenseBottomAlert,
    x.PLANNUMBER + '-EXP' AS LicenseNumber
FROM (SELECT plp.PLANNUMBER,
           cspm.EventName AS EventName,
           ISNULL((SELECT TOP 1 agentge.FIRSTNAME + ' ' + agentge.LASTNAME AS FullName
                FROM [$(EnerGovDatabase)].dbo.GLOBALENTITY agentge
                INNER JOIN [$(EnerGovDatabase)].dbo.BLLICENSECONTACT bllc ON agentge.GLOBALENTITYID = bllc.GLOBALENTITYID
                WHERE bllc.BLCONTACTTYPEID = '1f76e1b7-7d57-41a2-a777-30bb098f01b5' AND bllc.BLLICENSEID = lic.BLLICENSEID), '[ERROR: No Agent on the Alcohol License!]') AS AgentFullName,
           ISNULL(ISNULL(glent.GLOBALENTITYNAME, buis.COMPANYNAME), '[ERROR: No matching alcohol business found for business number and license year!]') AS CompanyName,
           ISNULL(buis.DBA, '[ERROR: No matching alcohol business found for business number and license year!]') AS CompanyDBA,
           ISNULL(cspm.AlcoholExpansionPremiseDescription, '') AS PremiseDescription,
           ISNULL(cspm.AlcoholExpansionTimePeriod, '') AS LicenseTimePeriod,
           CASE cspm.AlcoholLicenseExpansionType
                WHEN '25e1e88f-7420-34f7-de78-fb6edc1d2e07' THEN 'EXPANSION OF LICENSE(S) FOR SPECIAL EVENT'+ CHAR(13)+CHAR(10) +'& STREET PRIVILEGE PERMIT'+ CHAR(13)+CHAR(10) + '(Private Property)'
                WHEN 'c224ea5b-a9b8-21d3-8ffc-9d3e9472fea0' THEN 'EXPANSION OF LICENSE(S) FOR SPECIAL EVENT'+ CHAR(13)+CHAR(10) +'& STREET PRIVILEGE PERMIT'+ CHAR(13)+CHAR(10) + '(Public Property)'
                ELSE ''
           END AS LicenseDescription,
           IIF(plpaddr_mailaddr.MAILINGADDRESSID IS NULL,
               '[ERROR: No address of type Location and marked as the main address!]',
               LTRIM(RTRIM(plpaddr_mailaddr.ADDRESSLINE1)) +
               IIF(LEN(plpaddr_mailaddr.PREDIRECTION) > 0, ' ' + LTRIM(RTRIM(plpaddr_mailaddr.PREDIRECTION)), '') + ' ' +
               LTRIM(RTRIM(plpaddr_mailaddr.ADDRESSLINE2)) + ' ' + LTRIM(RTRIM(plpaddr_mailaddr.STREETTYPE)) +
               IIF(LEN(plpaddr_mailaddr.POSTDIRECTION) > 0, ' ' + LTRIM(RTRIM(plpaddr_mailaddr.POSTDIRECTION)), '') +
               IIF(LEN(plpaddr_mailaddr.UNITORSUITE) > 0, ' ' + LTRIM(RTRIM(plpaddr_mailaddr.UNITORSUITE)), '')) AS PremiseLocation,
            bltci.DisplayName AS DisplayName,
            lic.LICENSENUMBER AS AlcoholLicenseNumber
    FROM [$(EnerGovDatabase)].[dbo].PLPLAN plp
            LEFT OUTER JOIN [$(EnerGovDatabase)].[dbo].CUSTOMSAVERPLANMANAGEMENT cspm ON cspm.ID = plp.PLPLANID
            LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.PLPLANADDRESS plpaddr ON plp.PLPLANID = plpaddr.PLPLANID AND plpaddr.MAIN = 1
            LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.MAILINGADDRESS plpaddr_mailaddr ON plpaddr.MAILINGADDRESSID = plpaddr_mailaddr.MAILINGADDRESSID AND plpaddr_mailaddr.ADDRESSTYPE = 'Location'
            LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.BLGLOBALENTITYEXTENSION buis ON buis.REGISTRATIONID = cspm.ExistingAlcoholBusinessNumber
            LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.GLOBALENTITY glent ON buis.GLOBALENTITYID = glent.GLOBALENTITYID
            LEFT OUTER JOIN [$(EnerGovDatabase)].dbo.BLLICENSE lic ON lic.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID AND
                                                 lic.BLLICENSESTATUSID = '6ed562c0-cb4b-4001-874b-b0fa05d7cb4d' AND
                                                 lic.BLLICENSETYPEID = '7f4eb150-f664-4990-a1d2-2b5a3a5afa76' AND
                                                 lic.TAXYEAR = cspm.ExistingAlcoholLicenseYear
            LEFT OUTER JOIN [laxreports].[BusinessLicenseTypeClassInformation] bltci ON lic.BLLICENSETYPEID = bltci.LicenseTypeId AND
                                                                                        lic.BLLICENSECLASSID = bltci.LicenseClassId
    WHERE plp.PLPLANID = @PLPLANID AND
          cspm.AlcoholLicenseExpansionType IS NOT NULL AND
          cspm.AlcoholLicenseExpansionType <> '64342c19-065d-0074-bf69-640adb0ebffd') x