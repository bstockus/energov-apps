WITH MailingAddresses AS (SELECT ma.MAILINGADDRESSID,
                                 ma.ADDRESSTYPE,
                                 LTRIM(RTRIM(ma.ADDRESSLINE1)) +
                                 IIF(LEN(ma.PREDIRECTION) > 0, ' ' + LTRIM(RTRIM(ma.PREDIRECTION)), '') + ' ' +
                                 LTRIM(RTRIM(ma.ADDRESSLINE2)) + ' ' + LTRIM(RTRIM(ma.STREETTYPE)) +
                                 IIF(LEN(ma.POSTDIRECTION) > 0, ' ' + LTRIM(RTRIM(ma.POSTDIRECTION)), '') +
                                 IIF(LEN(ma.UNITORSUITE) > 0, ' ' + LTRIM(RTRIM(ma.UNITORSUITE)), '') AS StreetAddress,
                                 LTRIM(RTRIM(ma.CITY)) + ', ' + LTRIM(RTRIM(ma.STATE)) + ' ' +
                                 LTRIM(RTRIM(LEFT(ma.POSTALCODE, 5)))                                 AS CityAddress,
                                 LTRIM(RTRIM(ma.ADDRESSLINE1)) +
                                 IIF(LEN(ma.PREDIRECTION) > 0, ' ' + LTRIM(RTRIM(ma.PREDIRECTION)), '') + ' ' +
                                 LTRIM(RTRIM(ma.ADDRESSLINE2)) + ' ' + LTRIM(RTRIM(ma.STREETTYPE)) +
                                 IIF(LEN(ma.POSTDIRECTION) > 0, ' ' + LTRIM(RTRIM(ma.POSTDIRECTION)),
                                     '')                                                              AS AddressLine1,
                                 IIF(LEN(ma.UNITORSUITE) > 0, LTRIM(RTRIM(ma.UNITORSUITE)),
                                     LTRIM(RTRIM(ma.CITY)) + ', ' + LTRIM(RTRIM(ma.STATE)) + ' ' +
                                     LTRIM(RTRIM(ma.POSTALCODE)))                                     AS AddressLine2,
                                 IIF(LEN(ma.UNITORSUITE) > 0, '',
                                     LTRIM(RTRIM(ma.CITY)) + ', ' + LTRIM(RTRIM(ma.STATE)) + ' ' +
                                     LTRIM(RTRIM(LEFT(ma.POSTALCODE, 5))))                            AS AddressLine3,
                                 LTRIM(RTRIM(ma.ADDRESSLINE1)) +
                                 IIF(LEN(ma.PREDIRECTION) > 0, ' ' + LTRIM(RTRIM(ma.PREDIRECTION)), '') + ' ' +
                                 LTRIM(RTRIM(ma.ADDRESSLINE2)) + ' ' + LTRIM(RTRIM(ma.STREETTYPE)) +
                                 IIF(LEN(ma.POSTDIRECTION) > 0, ' ' + LTRIM(RTRIM(ma.POSTDIRECTION)), '') +
                                 IIF(LEN(ma.UNITORSUITE) > 0, ' ' + LTRIM(RTRIM(ma.UNITORSUITE)), '') + ', ' +
                                 LTRIM(RTRIM(ma.CITY)) + ', ' + LTRIM(RTRIM(ma.STATE)) + ' ' +
                                 LTRIM(RTRIM(LEFT(ma.POSTALCODE, 5)))                                 AS CompleteAddress,
                                 LTRIM(RTRIM(ma.ADDRESSLINE1)) +
                                 IIF(LEN(ma.PREDIRECTION) > 0, ' ' + LTRIM(RTRIM(ma.PREDIRECTION)), '') + ' ' +
                                 LTRIM(RTRIM(ma.ADDRESSLINE2)) + ' ' + LTRIM(RTRIM(ma.STREETTYPE)) +
                                 IIF(LEN(ma.POSTDIRECTION) > 0, ' ' + LTRIM(RTRIM(ma.POSTDIRECTION)), '') +
                                 IIF(LEN(ma.UNITORSUITE) > 0, ' ' + LTRIM(RTRIM(ma.UNITORSUITE)), '') + CHAR(13) +
                                 LTRIM(RTRIM(ma.CITY)) + ', ' + LTRIM(RTRIM(ma.STATE)) + ' ' +
                                 LTRIM(RTRIM(LEFT(ma.POSTALCODE, 5)))                                 AS CompleteAddressBreaks,
                                 LTRIM(RTRIM(ma.ADDRESSLINE1)) +
                                 IIF(LEN(ma.PREDIRECTION) > 0, ' ' + LTRIM(RTRIM(ma.PREDIRECTION)), '') + ' ' +
                                 LTRIM(RTRIM(ma.ADDRESSLINE2)) + ' ' + LTRIM(RTRIM(ma.STREETTYPE)) +
                                 IIF(LEN(ma.POSTDIRECTION) > 0, ' ' + LTRIM(RTRIM(ma.POSTDIRECTION)), '') + CHAR(13) +
                                 IIF(LEN(ma.UNITORSUITE) > 0, LTRIM(RTRIM(ma.UNITORSUITE)),
                                     LTRIM(RTRIM(ma.CITY)) + ', ' + LTRIM(RTRIM(ma.STATE)) + ' ' +
                                     LTRIM(RTRIM(ma.POSTALCODE))) +
                                 IIF(LEN(ma.UNITORSUITE) > 0,
                                     CHAR(13) + LTRIM(RTRIM(ma.CITY)) + ', ' + LTRIM(RTRIM(ma.STATE)) + ' ' +
                                     LTRIM(RTRIM(LEFT(ma.POSTALCODE, 5))),
                                     '')                                                              AS CompleteAddressLines,
                                 LTRIM(RTRIM(ma.CITY)) + ', ' + LTRIM(RTRIM(ma.STATE)) + ' ' +
                                 LTRIM(RTRIM(LEFT(ma.POSTALCODE, 5)))                                 AS PostOfficeAddress,
                                 LTRIM(RTRIM(ma.CITY))                                                AS City,
                                 LTRIM(RTRIM(ma.STATE))                                               AS State,
                                 LTRIM(RTRIM(ma.POSTALCODE))                                          AS PostalCode
                          FROM MAILINGADDRESS ma),
     ManagerContacts AS (SELECT bll.BLLICENSEID                                                                   AS LicenseId,
                                COALESCE((SELECT TOP 1 bllc.GLOBALENTITYID
                                          FROM BLLICENSECONTACT bllc
                                          WHERE bllc.BLCONTACTTYPEID = 'f33af855-38af-4c5f-aada-a4aa9967d132'
                                            AND bllc.BLLICENSEID = bll.BLLICENSEID),
                                         (SELECT TOP 1 bllc.GLOBALENTITYID
                                          FROM BLLICENSECONTACT bllc
                                          WHERE bllc.BLCONTACTTYPEID = '1f76e1b7-7d57-41a2-a777-30bb098f01b5'
                                            AND bllc.BLLICENSEID = bll.BLLICENSEID),
                                         (SELECT TOP 1 bllc.GLOBALENTITYID
                                          FROM BLGLOBALENTITYEXTENSIONCONTACT bllc
                                          WHERE bllc.BLCONTACTTYPEID = '1f76e1b7-7d57-41a2-a777-30bb098f01b5'
                                            AND bllc.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID)) AS GlobalEntityId,
                                (SELECT TOP 1 gema.MAILINGADDRESSID
                                 FROM GLOBALENTITYMAILINGADDRESS gema
                                 WHERE gema.GLOBALENTITYID = buis.GLOBALENTITYID)                                 AS MailingAddressId
                         FROM dbo.BLLICENSE bll
                                  INNER JOIN dbo.BLGLOBALENTITYEXTENSION buis
                                             ON bll.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID),
     BusinessAddresses AS (SELECT (SELECT TOP 1 ma.MAILINGADDRESSID
                                   FROM BLGLOBALENTITYEXTENSIONADDRESS glext_addr
                                            INNER JOIN MailingAddresses ma ON glext_addr.MAILINGADDRESSID = ma.MAILINGADDRESSID
                                   WHERE glext_addr.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
                                     AND ma.ADDRESSTYPE = 'Location')        AS LocationMailingAddressId,
                                  (SELECT TOP 1 ma.MAILINGADDRESSID
                                   FROM BLGLOBALENTITYEXTENSIONADDRESS glext_addr
                                            INNER JOIN MailingAddresses ma ON glext_addr.MAILINGADDRESSID = ma.MAILINGADDRESSID
                                   WHERE glext_addr.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
                                     AND ma.ADDRESSTYPE = 'Renewal Mailing') AS RenewalMailingAddressId,
                                  (SELECT TOP 1 ma.MAILINGADDRESSID
                                   FROM BLGLOBALENTITYEXTENSIONADDRESS glext_addr
                                            INNER JOIN MailingAddresses ma ON glext_addr.MAILINGADDRESSID = ma.MAILINGADDRESSID
                                   WHERE glext_addr.BLGLOBALENTITYEXTENSIONID = buis.BLGLOBALENTITYEXTENSIONID
                                     AND ma.ADDRESSTYPE = 'License Mailing') AS LicenseMailingAddressId,
                                  buis.BLGLOBALENTITYEXTENSIONID             AS BusinessId
                           FROM BLGLOBALENTITYEXTENSION buis)
SELECT buis.BLGLOBALENTITYEXTENSIONID                                                       AS BusinessId,
       ISNULL(comp.CONTACTID, buis.REGISTRATIONID)                                          AS CompanyId,
       lic.BLLICENSEID                                                                      AS LicenseId,
       buis_contact.BLLICENSEID                                                             AS ContactId,
       contact.GLOBALENTITYID                                                               AS PersonId,
       buis.EINNUMBER                                                                       AS TaxNumber,
       buis.STATETAXNUMBER                                                                  AS WisconsinSellersPermitNumber,
       buis.DBA                                                                             AS TradeName,
       buis.REGISTRATIONID                                                                  AS BusinessNumber,
       lic.LICENSENUMBER                                                                    AS LicenseNumber,
       (SELECT TOP 1 cfpli.SVALUE
        FROM dbo.CUSTOMFIELDPICKLISTITEM cfpli
        WHERE cfpli.GCUSTOMFIELDPICKLISTITEM = buis_cf.ClerksCompanyType)                   AS ClerksCompanyTypeName,
       buis_cf.ClerksCompanyType                                                            AS ClerksCompanyTypeId,
       ISNULL(comp.GLOBALENTITYNAME, buis.COMPANYNAME)                                      AS FullLegalName,
       ISNULL(comp.BUSINESSPHONE, buis.BUSINESSPHONE)                                       AS BusinessPhoneNumber,
       ISNULL(ba_location_ma.StreetAddress, '')                                             AS LocationAddress_StreetAddress,
       ISNULL(ba_location_ma.PostOfficeAddress, '')                                         AS LocationAddress_PostOfficeAddress,
       ISNULL(ba_location_ma.City, '')                                                      AS LocationAddress_City,
       ISNULL(ba_location_ma.State, '')                                                     AS LocationAddress_State,
       ISNULL(ba_location_ma.PostalCode, '')                                                AS LocationAddress_PostalCode,
       ISNULL(ba_renewal_ma.CompleteAddressLines, '')                                       AS RenewalMailingAddress_CompleteAddressLines,
       ISNULL(ba_license_ma.CompleteAddressLines, '')                                       AS LicenseMailingAddress_CompleteAddressLines,
       ISNULL(company_ma.CompleteAddressLines, '')                                          AS CompanyMailingAddress_CompleteAddressLines,
       ISNULL(company_ma.CompleteAddressBreaks, '')                                         AS CompanyMailingAddress_CompleteAddress,
       ISNULL(company_ma.CompleteAddress, '')                                               AS CompanyMailingAddress_CompleteAddressNoBreaks,
       ISNULL(company_ma.StreetAddress, '')                                                 AS CompanyMailingAddress_StreetAddress,
       ISNULL(company_ma.City, '')                                                          AS CompanyMailingAddress_City,
       ISNULL(company_ma.State, '')                                                         AS CompanyMailingAddress_State,
       ISNULL(company_ma.PostalCode, '')                                                    AS CompanyMailingAddress_PostalCode,
       lic.TAXYEAR                                                                          AS LicenseYear,
       lic.APPLIEDDATE                                                                      AS LicenseAppliedDate,
       lic.ISSUEDDATE                                                                       AS LicenseIssuedDate,
       lic.EXPIRATIONDATE                                                                   AS LicenseExpirationDate,
       lic_type.NAME                                                                        AS LicenseTypeName,
       lic_type.BLLICENSETYPEID                                                             AS LicenseTypeId,
       lic_class.NAME                                                                       AS LicenseClassName,
       lic_class.BLLICENSECLASSID                                                           AS LicenseClassId,
       lic_cf.PremiseDescriptionQuestion                                                    AS AlchoholLicenseSalesAndServiceArea,
       lic_cf.PremiseDescriptionStorageQuestion                                             AS AlcoholLicenseStorageArea,
       lic_cf.BeerGardenDescription                                                         AS BeerGardenDescription,
       lic_cf.OtherBusinessConductedOnPremise                                               AS OtherBusinessConductedOnPremise,
       lic_cf.IndoorCabaretDescription                                                      AS IndoorCabaretDescription,
       lic_cf.IndoorCabaretNatureofEntertainment                                            AS IndoorCabaretNatureOfEntertainment,
       lic_cf.OutdoorCabaretDescription                                                     AS OutdoorCabaretDescription,
       lic_cf.OutdoorCabaretNatureofEntertainment                                           AS OutdoorCabaretNatureOfEntertainment,
       lic_cf.Screens500OrUnder                                                             AS TheatreScreens500OrUnder,
       lic_cf.Screens500To1000                                                              AS TheatreScreens500To1000,
       lic_cf.ScreensOver1000                                                               AS TheatreScreensOver1000,
       lic_cf.KindOfMaterialToBeHandled                                                     AS KindOfMaterialToBeHandled,
       lic_cf.DetailedNatureOfBusiness                                                      AS DetailedNatureOfBusiness,
       lic_cf.JunkDealerLicenseType                                                         AS JunkDealerLicenseType,
       lic_cf.NameOfMobileHomePark                                                          AS NameOfMobileHomePark,
       lic_cf.NumberOfLots                                                                  AS NumberOfLots,
       (SELECT TOP 1 lic_cf_ms.CUSTOMFIELDPICKLISTITEMID
        FROM CUSTOMSAVERLICENSEMANAGEMENTMS lic_cf_ms
        WHERE lic_cf_ms.ID = lic.BLLICENSEID
          AND lic_cf_ms.CUSTOMFIELDPICKLISTITEMID =
              '9d3ac7ff-0960-4f5c-a21b-a36739ea8f72')                                       AS Recycling_ProcessingFacility,
       (SELECT TOP 1 lic_cf_ms.CUSTOMFIELDPICKLISTITEMID
        FROM CUSTOMSAVERLICENSEMANAGEMENTMS lic_cf_ms
        WHERE lic_cf_ms.ID = lic.BLLICENSEID
          AND lic_cf_ms.CUSTOMFIELDPICKLISTITEMID =
              '3cccc74b-db41-4780-a4df-653553c4c9b8')                                       AS Recycling_PickUpStation,
       (SELECT TOP 1 lic_cf_ms.CUSTOMFIELDPICKLISTITEMID
        FROM CUSTOMSAVERLICENSEMANAGEMENTMS lic_cf_ms
        WHERE lic_cf_ms.ID = lic.BLLICENSEID
          AND lic_cf_ms.CUSTOMFIELDPICKLISTITEMID =
              '48305e70-9846-465d-b70c-42c9e5226fad')                                       AS Recycling_RecyclingCenter,
       (SELECT TOP 1 lic_cf_ms.CUSTOMFIELDPICKLISTITEMID
        FROM CUSTOMSAVERLICENSEMANAGEMENTMS lic_cf_ms
        WHERE lic_cf_ms.ID = lic.BLLICENSEID
          AND lic_cf_ms.CUSTOMFIELDPICKLISTITEMID =
              '06e48340-954a-4e96-acd9-47b24372454c')                                       AS Recycling_ReverseVendingMachine,
       lic_cf.EngagedInCleaningWasteQuestion                                                AS EngagedInCleaningWasteQuestion,
       (SELECT TOP 1 lic_cf_ms.CUSTOMFIELDPICKLISTITEMID
        FROM CUSTOMSAVERLICENSEMANAGEMENTMS lic_cf_ms
        WHERE lic_cf_ms.ID = lic.BLLICENSEID
          AND lic_cf_ms.CUSTOMFIELDPICKLISTITEMID = 'ac99dc41-9a48-44a6-8880-848ff99334cb') AS Secondhand_Jewelry,
       (SELECT TOP 1 lic_cf_ms.CUSTOMFIELDPICKLISTITEMID
        FROM CUSTOMSAVERLICENSEMANAGEMENTMS lic_cf_ms
        WHERE lic_cf_ms.ID = lic.BLLICENSEID
          AND lic_cf_ms.CUSTOMFIELDPICKLISTITEMID = 'bf7b1496-35ff-469c-a2b2-438c8ca6a80b') AS Secondhand_Article,
       contact.FIRSTNAME                                                                    AS ContactFirstName,
       contact.MIDDLENAME                                                                   AS ContactMiddleName,
       contact.LASTNAME                                                                     AS ContactLastName,
       contact.EMAIL                                                                        AS ContactEmail,
       buis_contact_type.NAME                                                               AS ContactType,
       buis_contact_type.BLCONTACTTYPEID                                                    AS ContactTypeId,
       ISNULL(contact_ma.CompleteAddressBreaks, '')                                         AS ContactAddress_CompleteAddress,
       ISNULL(contact_ma.CompleteAddress, '')                                               AS ContactAddress_CompleteAddressNoBreaks,
       ISNULL(contact_ma.StreetAddress, '')                                                 AS ContactAddress_StreetAddress,
       ISNULL(contact_ma.City, '')                                                          AS ContactAddress_City,
       ISNULL(contact_ma.State, '')                                                         AS ContactAddress_State,
       ISNULL(contact_ma.PostalCode, '')                                                    AS ContactAddress_PostalCode,
       contact.HOMEPHONE                                                                    AS ContactHomePhone,
       contact.BUSINESSPHONE                                                                AS ContactBusinessPhone,
       contact.EMAIL                                                                        AS ContactEmail,
       (SELECT TOP 1 ge_cf.DateOfBirth
        FROM CUSTOMSAVERSYSTEMSETUP ge_cf
        WHERE ge_cf.ID = contact.GLOBALENTITYID)                                            AS ContactDateOfBirth,
       ISNULL(mc_ge.FIRSTNAME, '')                                                          AS ManagerName_First,
       ISNULL(mc_ge.MIDDLENAME, '')                                                         AS ManagerName_Middle,
       ISNULL(mc_ge.LASTNAME, '')                                                           AS ManagerName_Last,
       ISNULL(mc_ge.FIRSTNAME + ' ' + mc_ge.MIDDLENAME + ' ' + mc_ge.LASTNAME, '')          AS ManagerName,
       ISNULL(mc_ge.HOMEPHONE, '')                                                          AS ManagerHomePhone,
       ISNULL(mc_ge.BUSINESSPHONE, '')                                                      AS ManagerBusinessPhone,
       ISNULL(mc_ma.CompleteAddress, '')                                                    AS ManagerCompleteAddress,
       ISNULL(mc_ma.StreetAddress, '')                                                      AS ManagerCompleteAddress_StreetAddress,
       ISNULL(mc_ma.City, '')                                                               AS ManagerCompleteAddress_City,
       ISNULL(mc_ma.State, '')                                                              AS ManagerCompleteAddress_State,
       ISNULL(mc_ma.PostalCode, '')                                                         AS ManagerCompleteAddress_PostalCode,
       ISNULL(mc_ma.CompleteAddress, '')                                                    AS ManagerCompleteAddress,
       (SELECT TOP 1 par.PARCELNUMBER
        FROM BLLICENSEPARCEL bllp
                 INNER JOIN PARCEL par ON bllp.PARCELID = par.PARCELID
        WHERE bllp.BLLICENSEID = lic.BLLICENSEID
          AND bllp.MAIN = 1)                                                                AS ParcelNumber
FROM BLGLOBALENTITYEXTENSION buis
         INNER JOIN BLGLOBALENTITYEXTENSIONCONTACT buis_glent
                    ON buis.BLGLOBALENTITYEXTENSIONID = buis_glent.BLGLOBALENTITYEXTENSIONID AND
                       buis_glent.BLCONTACTTYPEID = '89625cdf-c6a3-47c2-8e54-2ac0c4e17c4e'
         LEFT OUTER JOIN CUSTOMSAVERLICENSEMANAGEMENT buis_cf ON buis.BLGLOBALENTITYEXTENSIONID = buis_cf.ID
         LEFT OUTER JOIN GLOBALENTITY comp ON buis.GLOBALENTITYID = comp.GLOBALENTITYID
         INNER JOIN BLLICENSE lic ON buis.BLGLOBALENTITYEXTENSIONID = lic.BLGLOBALENTITYEXTENSIONID AND
                                     lic.BLLICENSESTATUSID = '6ed562c0-cb4b-4001-874b-b0fa05d7cb4d'
         INNER JOIN BLLICENSETYPE lic_type ON lic.BLLICENSETYPEID = lic_type.BLLICENSETYPEID
         INNER JOIN BLLICENSECLASS lic_class ON lic.BLLICENSECLASSID = lic_class.BLLICENSECLASSID
         LEFT OUTER JOIN CUSTOMSAVERLICENSEMANAGEMENT lic_cf ON lic.BLLICENSEID = lic_cf.ID
         INNER JOIN BLLICENSECONTACT buis_contact
                    ON lic.BLLICENSEID = buis_contact.BLLICENSEID AND
                       buis_contact.BLCONTACTTYPEID IN (
                                                        '1f76e1b7-7d57-41a2-a777-30bb098f01b5', --Agent
                                                        '8143cbdf-c524-4e8c-a891-975f8c5458f9', --Applicant
                                                        'e5112f89-68e6-4a96-9ebc-142f9a27a0cc', --Director
                                                        '102dcef5-48b6-4bc1-8d29-237e249c93b1', --Individual
                                                        'f33af855-38af-4c5f-aada-a4aa9967d132', --Manager
                                                        'd18f11a0-473c-475d-b255-c710d1856f7e', --Member
                                                        'e87c4fa4-dc69-40b3-802f-9e6eba3e1808', --Owner
                                                        'b0f8cfa5-2a76-42b8-86f1-e63b3e0acce1', --Partner
                                                        'e4e0dd78-44f3-4dcf-b977-219f80082b2e', --President
                                                        '75bcb07d-9200-4eb9-89d3-44d5a33f4ca5', --Secretary
                                                        'c4f61107-0324-4a58-af58-ed1e15a5b42f', --Treasurer
                                                        'b8af6092-16cb-432e-a4ff-8d02c9e2a127') --Vice President
         INNER JOIN GLOBALENTITY contact ON buis_contact.GLOBALENTITYID = contact.GLOBALENTITYID
         INNER JOIN BLCONTACTTYPE buis_contact_type ON buis_contact.BLCONTACTTYPEID = buis_contact_type.BLCONTACTTYPEID
         LEFT OUTER JOIN ManagerContacts mc ON mc.LicenseId = lic.BLLICENSEID
         LEFT OUTER JOIN GLOBALENTITY mc_ge ON mc.GlobalEntityId = mc_ge.GLOBALENTITYID
         LEFT OUTER JOIN MailingAddresses mc_ma ON mc.MAILINGADDRESSID = mc_ma.MAILINGADDRESSID
         LEFT OUTER JOIN BusinessAddresses ba ON ba.BusinessId = buis.BLGLOBALENTITYEXTENSIONID
         LEFT OUTER JOIN MailingAddresses ba_location_ma
                         ON ba.LocationMailingAddressId = ba_location_ma.MAILINGADDRESSID
         LEFT OUTER JOIN MailingAddresses ba_renewal_ma ON ba.RenewalMailingAddressId = ba_renewal_ma.MAILINGADDRESSID
         LEFT OUTER JOIN MailingAddresses ba_license_ma ON ba.LicenseMailingAddressId = ba_license_ma.MAILINGADDRESSID
         OUTER APPLY (SELECT TOP 1 ma.*
                      FROM GLOBALENTITYMAILINGADDRESS ge_addr
                               INNER JOIN MailingAddresses ma ON ge_addr.MAILINGADDRESSID = ma.MAILINGADDRESSID
                      WHERE ge_addr.GLOBALENTITYID = contact.GLOBALENTITYID) contact_ma
         OUTER APPLY (SELECT TOP 1 ma.*
                      FROM GLOBALENTITYMAILINGADDRESS ge_addr
                               INNER JOIN MailingAddresses ma ON ge_addr.MAILINGADDRESSID = ma.MAILINGADDRESSID
                      WHERE ge_addr.GLOBALENTITYID =
                            ISNULL(comp.GLOBALENTITYID, buis_glent.GLOBALENTITYID)) company_ma
WHERE buis.BLGLOBALENTITYEXTENSIONID = @BusinessId AND lic.TAXYEAR = @TaxYear