SELECT
    x.*
FROM (
    SELECT
        'BUIS' AS EntityType,
        buis.BLGLOBALENTITYEXTENSIONID AS BusinessId,
        LTRIM(RTRIM(buis.REGISTRATIONID)) AS BusinessNumber,
        buis_company_type.BLEXTCOMPANYTYPEID AS BusinessCompanyTypeId,
        LTRIM(RTRIM(ISNULL(buis_company_type.NAME, ''))) AS BusinessCompanyType,
        buis_status.BLEXTSTATUSID AS BusinessStatusId,
        LTRIM(RTRIM(ISNULL(buis_status.NAME, ''))) AS BusinessStatus,
        LTRIM(RTRIM(ISNULL(buis.DESCRIPTION, ''))) AS Description,
        LTRIM(RTRIM(ISNULL(buis.DBA, ''))) AS TradeName,
        LTRIM(RTRIM(ISNULL(buis.EINNUMBER, ''))) AS FederalTaxNumber,
        LTRIM(RTRIM(ISNULL(buis.STATETAXNUMBER, ''))) AS StateTaxNumber,
        district.DISTRICTID AS DistrictId,
        LTRIM(RTRIM(ISNULL(district.NAME, ''))) AS District,
        buis_location.BLEXTLOCATIONID AS BusinessLocationId,
        LTRIM(RTRIM(ISNULL(buis_location.NAME, ''))) AS BusinessLocation,
        buis.OPENDATE AS OpenDate,
        buis.CLOSEDATE AS CloseDate,
        NULL AS ContactId, NULL AS ContactNumber, NULL AS CompanyName, NULL AS FirstName, NULL AS MiddleName, NULL AS LastName, NULL AS Title, NULL AS Email, NULL AS WebSite, NULL AS BusinessPhoneNumber, NULL AS HomePhoneNumber, NULL AS MobilePhoneNumber, NULL AS FaxNumber, NULL AS OtherPhoneNumber, NULL AS IsCompany, NULL AS IsContact,
        NULL AS BusinessContactTypeId, NULL AS BusinessContactType,
        NULL AS MailingAddressId, NULL AS AddressType, NULL AS AddressNumber, NULL AS PreDirection, NULL AS StreetName, NULL AS StreetType, NULL AS PostDirection, NULL AS UnitOrSuite, NULL AS AddressLine3, NULL AS City, NULL AS State, NULL AS ZipCode,
        NULL AS IsMain,
        NULL AS ParcelId, NULL AS ParcelNumber,
        NULL AS LicenseId, NULL AS LicenseNumber, NULL AS LicenseYear, NULL AS LicenseTypeId, NULL AS LicenseType, NULL AS LicenseClassId, NULL AS LicenseClass, NULL AS LicenseStatusId, NULL AS LicenseStatus, NULL AS AppliedDate, NULL AS IssuedDate, NULL AS ExpirationDate, NULL AS IsBilling
    FROM BLGLOBALENTITYEXTENSION buis
        INNER JOIN BLEXTCOMPANYTYPE buis_company_type ON buis.BLEXTCOMPANYTYPEID = buis_company_type.BLEXTCOMPANYTYPEID
        INNER JOIN BLEXTSTATUS buis_status ON buis.BLEXTSTATUSID = buis_status.BLEXTSTATUSID
        INNER JOIN DISTRICT district ON buis.DISTRICTID = district.DISTRICTID
        INNER JOIN BLEXTLOCATION buis_location ON buis.BLEXTLOCATIONID = buis_location.BLEXTLOCATIONID
    --WHERE buis.BLGLOBALENTITYEXTENSIONID = '2fc75425-95d1-45d4-b32e-693c1773d9a3'

    UNION SELECT
        'COMP' AS EntityType,
        buis.BLGLOBALENTITYEXTENSIONID AS BusinessId,
        NULL AS BusinessNumber, NULL AS BusinessCompanyTypeId, NULL AS BusinessCompanyType, NULL AS BusinessStatusId, NULL AS BusinessStatus, NULL AS Description, NULL AS TradeName, NULL AS FederalTaxNumber, NULL AS StateTaxNumber, NULL AS DistrictId, NULL AS District, NULL AS BusinessLocationId, NULL AS BusinessLocation, NULL AS OpenDate, NULL AS CloseDate,
        contact.GLOBALENTITYID AS ContactId,
        LTRIM(RTRIM(contact.CONTACTID)) AS ContactNumber,
        LTRIM(RTRIM(ISNULL(contact.GLOBALENTITYNAME, ''))) AS CompanyName,
        LTRIM(RTRIM(ISNULL(contact.FIRSTNAME, ''))) AS FirstName,
        LTRIM(RTRIM(ISNULL(contact.MIDDLENAME, ''))) AS MiddleName,
        LTRIM(RTRIM(ISNULL(contact.LASTNAME, ''))) AS LastName,
        LTRIM(RTRIM(ISNULL(contact.TITLE, ''))) AS Title,
        LTRIM(RTRIM(ISNULL(contact.EMAIL, ''))) AS Email,
        LTRIM(RTRIM(ISNULL(contact.WEBSITE, ''))) AS WebSite,
        LTRIM(RTRIM(ISNULL(contact.BUSINESSPHONE, ''))) AS BusinessPhoneNumber,
        LTRIM(RTRIM(ISNULL(contact.HOMEPHONE, ''))) AS HomePhoneNumber,
        LTRIM(RTRIM(ISNULL(contact.MOBILEPHONE, ''))) AS MobilePhoneNumber,
        LTRIM(RTRIM(ISNULL(contact.FAX, ''))) AS FaxNumber,
        LTRIM(RTRIM(ISNULL(contact.OTHERPHONE, ''))) AS OtherPhoneNumber,
        contact.ISCOMPANY AS IsCompany,
        contact.ISCONTACT AS IsContact,
        NULL AS BusinessContactTypeId, NULL AS BusinessContactType,
        NULL AS MailingAddressId, NULL AS AddressType, NULL AS AddressNumber, NULL AS PreDirection, NULL AS StreetName, NULL AS StreetType, NULL AS PostDirection, NULL AS UnitOrSuite, NULL AS AddressLine3, NULL AS City, NULL AS State, NULL AS ZipCode,
        NULL AS IsMain,
        NULL AS ParcelId, NULL AS ParcelNumber,
        NULL AS LicenseId, NULL AS LicenseNumber, NULL AS LicenseYear, NULL AS LicenseTypeId, NULL AS LicenseType, NULL AS LicenseClassId, NULL AS LicenseClass, NULL AS LicenseStatusId, NULL AS LicenseStatus, NULL AS AppliedDate, NULL AS IssuedDate, NULL AS ExpirationDate, NULL AS IsBilling
    FROM BLGLOBALENTITYEXTENSION buis
        INNER JOIN GLOBALENTITY contact ON buis.GLOBALENTITYID = contact.GLOBALENTITYID
    -- WHERE buis.BLGLOBALENTITYEXTENSIONID = '2fc75425-95d1-45d4-b32e-693c1773d9a3'

    UNION SELECT
        'CADR' AS EntityType,
        buis.BLGLOBALENTITYEXTENSIONID AS BusinessId,
        NULL AS BusinessNumber, NULL AS BusinessCompanyTypeId, NULL AS BusinessCompanyType, NULL AS BusinessStatusId, NULL AS BusinessStatus, NULL AS Description, NULL AS TradeName, NULL AS FederalTaxNumber, NULL AS StateTaxNumber, NULL AS DistrictId, NULL AS District, NULL AS BusinessLocationId, NULL AS BusinessLocation, NULL AS OpenDate, NULL AS CloseDate,
        contact_addr.GLOBALENTITYID AS ContactId,
        NULL AS ContactNumber, NULL AS CompanyName, NULL AS FirstName, NULL AS MiddleName, NULL AS LastName, NULL AS Title, NULL AS Email, NULL AS WebSite, NULL AS BusinessPhoneNumber, NULL AS HomePhoneNumber, NULL AS MobilePhoneNumber, NULL AS FaxNumber, NULL AS OtherPhoneNumber, NULL AS IsCompany, NULL AS IsContact,
        NULL AS BusinessContactTypeId, NULL AS BusinessContactType,
        addr.MAILINGADDRESSID AS MailingAddressId,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSTYPE, ''))) AS AddressType,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE1, ''))) AS AddressNumber,
        LTRIM(RTRIM(ISNULL(addr.PREDIRECTION, ''))) AS PreDirection,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE2, ''))) AS StreetName,
        LTRIM(RTRIM(ISNULL(addr.STREETTYPE, ''))) AS StreetType,
        LTRIM(RTRIM(ISNULL(addr.POSTDIRECTION, ''))) AS PostDirection,
        LTRIM(RTRIM(ISNULL(addr.UNITORSUITE, ''))) AS UnitOrSuite,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE3, ''))) AS AddressLine3,
        LTRIM(RTRIM(ISNULL(addr.CITY, ''))) AS City,
        LTRIM(RTRIM(ISNULL(addr.STATE, ''))) AS State,
        LTRIM(RTRIM(ISNULL(addr.POSTALCODE, ''))) AS ZipCode,
        NULL AS IsMain,
        NULL AS ParcelId, NULL AS ParcelNumber,
        NULL AS LicenseId, NULL AS LicenseNumber, NULL AS LicenseYear, NULL AS LicenseTypeId, NULL AS LicenseType, NULL AS LicenseClassId, NULL AS LicenseClass, NULL AS LicenseStatusId, NULL AS LicenseStatus, NULL AS AppliedDate, NULL AS IssuedDate, NULL AS ExpirationDate, NULL AS IsBilling
    FROM BLGLOBALENTITYEXTENSION buis
        INNER JOIN GLOBALENTITY contact ON buis.GLOBALENTITYID = contact.GLOBALENTITYID
        INNER JOIN GLOBALENTITYMAILINGADDRESS contact_addr ON contact.GLOBALENTITYID = contact_addr.GLOBALENTITYID
        INNER JOIN MAILINGADDRESS addr ON contact_addr.MAILINGADDRESSID = addr.MAILINGADDRESSID
    -- WHERE buis.BLGLOBALENTITYEXTENSIONID = '2fc75425-95d1-45d4-b32e-693c1773d9a3'

    UNION SELECT
        'BADR' AS EntityType,
        buis.BLGLOBALENTITYEXTENSIONID AS BusinessId,
        NULL AS BusinessNumber, NULL AS BusinessCompanyTypeId, NULL AS BusinessCompanyType, NULL AS BusinessStatusId, NULL AS BusinessStatus, NULL AS Description, NULL AS TradeName, NULL AS FederalTaxNumber, NULL AS StateTaxNumber, NULL AS DistrictId, NULL AS District, NULL AS BusinessLocationId, NULL AS BusinessLocation, NULL AS OpenDate, NULL AS CloseDate,
        NULL AS ContactId, NULL AS ContactNumber, NULL AS CompanyName, NULL AS FirstName, NULL AS MiddleName, NULL AS LastName, NULL AS Title, NULL AS Email, NULL AS WebSite, NULL AS BusinessPhoneNumber, NULL AS HomePhoneNumber, NULL AS MobilePhoneNumber, NULL AS FaxNumber, NULL AS OtherPhoneNumber, NULL AS IsCompany, NULL AS IsContact,
        NULL AS BusinessContactTypeId, NULL AS BusinessContactType,
        addr.MAILINGADDRESSID AS MailingAddressId,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSTYPE, ''))) AS AddressType,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE1, ''))) AS AddressNumber,
        LTRIM(RTRIM(ISNULL(addr.PREDIRECTION, ''))) AS PreDirection,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE2, ''))) AS StreetName,
        LTRIM(RTRIM(ISNULL(addr.STREETTYPE, ''))) AS StreetType,
        LTRIM(RTRIM(ISNULL(addr.POSTDIRECTION, ''))) AS PostDirection,
        LTRIM(RTRIM(ISNULL(addr.UNITORSUITE, ''))) AS UnitOrSuite,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE3, ''))) AS AddressLine3,
        LTRIM(RTRIM(ISNULL(addr.CITY, ''))) AS City,
        LTRIM(RTRIM(ISNULL(addr.STATE, ''))) AS State,
        LTRIM(RTRIM(ISNULL(addr.POSTALCODE, ''))) AS ZipCode,
        buis_addr.MAIN AS IsMain,
        NULL AS ParcelId, NULL AS ParcelNumber,
        NULL AS LicenseId, NULL AS LicenseNumber, NULL AS LicenseYear, NULL AS LicenseTypeId, NULL AS LicenseType, NULL AS LicenseClassId, NULL AS LicenseClass, NULL AS LicenseStatusId, NULL AS LicenseStatus, NULL AS AppliedDate, NULL AS IssuedDate, NULL AS ExpirationDate, NULL AS IsBilling
    FROM BLGLOBALENTITYEXTENSION buis
        INNER JOIN BLGLOBALENTITYEXTENSIONADDRESS buis_addr ON buis.BLGLOBALENTITYEXTENSIONID = buis_addr.BLGLOBALENTITYEXTENSIONID
        INNER JOIN MAILINGADDRESS addr ON buis_addr.MAILINGADDRESSID = addr.MAILINGADDRESSID
    -- WHERE buis.BLGLOBALENTITYEXTENSIONID = '2fc75425-95d1-45d4-b32e-693c1773d9a3'

    UNION SELECT
        'BPAR' AS EntityType,
        buis.BLGLOBALENTITYEXTENSIONID AS BusinessId,
        NULL AS BusinessNumber, NULL AS BusinessCompanyTypeId, NULL AS BusinessCompanyType, NULL AS BusinessStatusId, NULL AS BusinessStatus, NULL AS Description, NULL AS TradeName, NULL AS FederalTaxNumber, NULL AS StateTaxNumber, NULL AS DistrictId, NULL AS District, NULL AS BusinessLocationId, NULL AS BusinessLocation, NULL AS OpenDate, NULL AS CloseDate,
        NULL AS ContactId, NULL AS ContactNumber, NULL AS CompanyName, NULL AS FirstName, NULL AS MiddleName, NULL AS LastName, NULL AS Title, NULL AS Email, NULL AS WebSite, NULL AS BusinessPhoneNumber, NULL AS HomePhoneNumber, NULL AS MobilePhoneNumber, NULL AS FaxNumber, NULL AS OtherPhoneNumber, NULL AS IsCompany, NULL AS IsContact,
        NULL AS BusinessContactTypeId, NULL AS BusinessContactType,
        NULL AS MailingAddressId, NULL AS AddressType, NULL AS AddressNumber, NULL AS PreDirection, NULL AS StreetName, NULL AS StreetType, NULL AS PostDirection, NULL AS UnitOrSuite, NULL AS AddressLine3, NULL AS City, NULL AS State, NULL AS ZipCode,
        buis_parcel.MAIN AS IsMain,
        parcel.PARCELID AS ParcelId,
        LTRIM(RTRIM(ISNULL(parcel.PARCELNUMBER, ''))) AS ParcelNumber,
        NULL AS LicenseId, NULL AS LicenseNumber, NULL AS LicenseYear, NULL AS LicenseTypeId, NULL AS LicenseType, NULL AS LicenseClassId, NULL AS LicenseClass, NULL AS LicenseStatusId, NULL AS LicenseStatus, NULL AS AppliedDate, NULL AS IssuedDate, NULL AS ExpirationDate, NULL AS IsBilling
    FROM BLGLOBALENTITYEXTENSION buis
        INNER JOIN BLGLOBALENTITYEXTENSIONPARCEL buis_parcel ON buis.BLGLOBALENTITYEXTENSIONID = buis_parcel.BLGLOBALENTITYEXTENSIONID
        INNER JOIN PARCEL parcel ON buis_parcel.PARCELID = parcel.PARCELID
    -- WHERE buis.BLGLOBALENTITYEXTENSIONID = '2fc75425-95d1-45d4-b32e-693c1773d9a3'

    UNION SELECT
        'BCON' AS EntityType,
        buis.BLGLOBALENTITYEXTENSIONID AS BusinessId,
        NULL AS BusinessNumber, NULL AS BusinessCompanyTypeId, NULL AS BusinessCompanyType, NULL AS BusinessStatusId, NULL AS BusinessStatus, NULL AS Description, NULL AS TradeName, NULL AS FederalTaxNumber, NULL AS StateTaxNumber, NULL AS DistrictId, NULL AS District, NULL AS BusinessLocationId, NULL AS BusinessLocation, NULL AS OpenDate, NULL AS CloseDate,
        contact.GLOBALENTITYID AS ContactId,
        LTRIM(RTRIM(contact.CONTACTID)) AS ContactNumber,
        LTRIM(RTRIM(ISNULL(contact.GLOBALENTITYNAME, ''))) AS CompanyName,
        LTRIM(RTRIM(ISNULL(contact.FIRSTNAME, ''))) AS FirstName,
        LTRIM(RTRIM(ISNULL(contact.MIDDLENAME, ''))) AS MiddleName,
        LTRIM(RTRIM(ISNULL(contact.LASTNAME, ''))) AS LastName,
        LTRIM(RTRIM(ISNULL(contact.TITLE, ''))) AS Title,
        LTRIM(RTRIM(ISNULL(contact.EMAIL, ''))) AS Email,
        LTRIM(RTRIM(ISNULL(contact.WEBSITE, ''))) AS WebSite,
        LTRIM(RTRIM(ISNULL(contact.BUSINESSPHONE, ''))) AS BusinessPhoneNumber,
        LTRIM(RTRIM(ISNULL(contact.HOMEPHONE, ''))) AS HomePhoneNumber,
        LTRIM(RTRIM(ISNULL(contact.MOBILEPHONE, ''))) AS MobilePhoneNumber,
        LTRIM(RTRIM(ISNULL(contact.FAX, ''))) AS FaxNumber,
        LTRIM(RTRIM(ISNULL(contact.OTHERPHONE, ''))) AS OtherPhoneNumber,
        contact.ISCOMPANY AS IsCompany,
        contact.ISCONTACT AS IsContact,
        buis_contact_type.BLCONTACTTYPEID AS BusinessContactTypeId,
        LTRIM(RTRIM(ISNULL(buis_contact_type.NAME, ''))) AS BusinessContactType,
        NULL AS MailingAddressId, NULL AS AddressType, NULL AS AddressNumber, NULL AS PreDirection, NULL AS StreetName, NULL AS StreetType, NULL AS PostDirection, NULL AS UnitOrSuite, NULL AS AddressLine3, NULL AS City, NULL AS State, NULL AS ZipCode,
        NULL AS IsMain,
        NULL AS ParcelId, NULL AS ParcelNumber,
        NULL AS LicenseId, NULL AS LicenseNumber, NULL AS LicenseYear, NULL AS LicenseTypeId, NULL AS LicenseType, NULL AS LicenseClassId, NULL AS LicenseClass, NULL AS LicenseStatusId, NULL AS LicenseStatus, NULL AS AppliedDate, NULL AS IssuedDate, NULL AS ExpirationDate, NULL AS IsBilling
    FROM BLGLOBALENTITYEXTENSION buis
        INNER JOIN BLGLOBALENTITYEXTENSIONCONTACT buis_contact ON buis.BLGLOBALENTITYEXTENSIONID = buis_contact.BLGLOBALENTITYEXTENSIONID
        INNER JOIN GLOBALENTITY contact ON buis_contact.GLOBALENTITYID = contact.GLOBALENTITYID
        INNER JOIN BLCONTACTTYPE buis_contact_type ON buis_contact.BLCONTACTTYPEID = buis_contact_type.BLCONTACTTYPEID
    -- WHERE buis.BLGLOBALENTITYEXTENSIONID = '2fc75425-95d1-45d4-b32e-693c1773d9a3'

    UNION SELECT
        'BCAD' AS EntityType,
        buis.BLGLOBALENTITYEXTENSIONID AS BusinessId,
        NULL AS BusinessNumber, NULL AS BusinessCompanyTypeId, NULL AS BusinessCompanyType, NULL AS BusinessStatusId, NULL AS BusinessStatus, NULL AS Description, NULL AS TradeName, NULL AS FederalTaxNumber, NULL AS StateTaxNumber, NULL AS DistrictId, NULL AS District, NULL AS BusinessLocationId, NULL AS BusinessLocation, NULL AS OpenDate, NULL AS CloseDate,
        contact.GLOBALENTITYID AS ContactId,
        NULL AS ContactNumber, NULL AS CompanyName, NULL AS FirstName, NULL AS MiddleName, NULL AS LastName, NULL AS Title, NULL AS Email, NULL AS WebSite, NULL AS BusinessPhoneNumber, NULL AS HomePhoneNumber, NULL AS MobilePhoneNumber, NULL AS FaxNumber, NULL AS OtherPhoneNumber, NULL AS IsCompany, NULL AS IsContact,
        NULL AS BusinessContactTypeId, NULL AS BusinessContactType,
        addr.MAILINGADDRESSID AS MailingAddressId,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSTYPE, ''))) AS AddressType,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE1, ''))) AS AddressNumber,
        LTRIM(RTRIM(ISNULL(addr.PREDIRECTION, ''))) AS PreDirection,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE2, ''))) AS StreetName,
        LTRIM(RTRIM(ISNULL(addr.STREETTYPE, ''))) AS StreetType,
        LTRIM(RTRIM(ISNULL(addr.POSTDIRECTION, ''))) AS PostDirection,
        LTRIM(RTRIM(ISNULL(addr.UNITORSUITE, ''))) AS UnitOrSuite,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE3, ''))) AS AddressLine3,
        LTRIM(RTRIM(ISNULL(addr.CITY, ''))) AS City,
        LTRIM(RTRIM(ISNULL(addr.STATE, ''))) AS State,
        LTRIM(RTRIM(ISNULL(addr.POSTALCODE, ''))) AS ZipCode,
        NULL AS IsMain,
        NULL AS ParcelId, NULL AS ParcelNumber,
        NULL AS LicenseId, NULL AS LicenseNumber, NULL AS LicenseYear, NULL AS LicenseTypeId, NULL AS LicenseType, NULL AS LicenseClassId, NULL AS LicenseClass, NULL AS LicenseStatusId, NULL AS LicenseStatus, NULL AS AppliedDate, NULL AS IssuedDate, NULL AS ExpirationDate, NULL AS IsBilling
    FROM BLGLOBALENTITYEXTENSION buis
        INNER JOIN BLGLOBALENTITYEXTENSIONCONTACT buis_contact ON buis.BLGLOBALENTITYEXTENSIONID = buis_contact.BLGLOBALENTITYEXTENSIONID
        INNER JOIN GLOBALENTITY contact ON buis_contact.GLOBALENTITYID = contact.GLOBALENTITYID
        INNER JOIN BLCONTACTTYPE buis_contact_type ON buis_contact.BLCONTACTTYPEID = buis_contact_type.BLCONTACTTYPEID
        INNER JOIN GLOBALENTITYMAILINGADDRESS contact_addr ON contact.GLOBALENTITYID = contact_addr.GLOBALENTITYID
        INNER JOIN MAILINGADDRESS addr ON contact_addr.MAILINGADDRESSID = addr.MAILINGADDRESSID
    -- WHERE buis.BLGLOBALENTITYEXTENSIONID = '2fc75425-95d1-45d4-b32e-693c1773d9a3'

    UNION SELECT
        'BLIC' AS EntityType,
        buis.BLGLOBALENTITYEXTENSIONID AS BusinessId,
        NULL AS BusinessNumber, NULL AS BusinessCompanyTypeId, NULL AS BusinessCompanyType, NULL AS BusinessStatusId, NULL AS BusinessStatus,
        LTRIM(RTRIM(ISNULL(lic.DESCRIPTION, ''))) AS Description,
        NULL AS TradeName, NULL AS FederalTaxNumber, NULL AS StateTaxNumber,
        district.DISTRICTID AS DistrictId,
        LTRIM(RTRIM(ISNULL(district.NAME, ''))) AS District,
        NULL AS BusinessLocationId, NULL AS BusinessLocation, NULL AS OpenDate, NULL AS CloseDate,
        NULL AS ContactId, NULL AS ContactNumber, NULL AS CompanyName, NULL AS FirstName, NULL AS MiddleName, NULL AS LastName, NULL AS Title, NULL AS Email, NULL AS WebSite, NULL AS BusinessPhoneNumber, NULL AS HomePhoneNumber, NULL AS MobilePhoneNumber, NULL AS FaxNumber, NULL AS OtherPhoneNumber, NULL AS IsCompany, NULL AS IsContact,
        NULL AS BusinessContactTypeId, NULL AS BusinessContactType,
        NULL AS MailingAddressId, NULL AS AddressType, NULL AS AddressNumber, NULL AS PreDirection, NULL AS StreetName, NULL AS StreetType, NULL AS PostDirection, NULL AS UnitOrSuite, NULL AS AddressLine3, NULL AS City, NULL AS State, NULL AS ZipCode,
        NULL AS IsMain,
        NULL AS ParcelId, NULL AS ParcelNumber,
        lic.BLLICENSEID AS LicenseId,
        LTRIM(RTRIM(ISNULL(lic.LICENSENUMBER, ''))) AS LicenseNumber,
        lic.TAXYEAR AS LicenseYear,
        lic_type.BLLICENSETYPEID AS LicenseTypeId,
        LTRIM(RTRIM(ISNULL(lic_type.NAME, ''))) AS LicenseType,
        lic_class.BLLICENSECLASSID AS LicenseClassId,
        LTRIM(RTRIM(ISNULL(lic_class.NAME, ''))) AS LicenseClass,
        lic_status.BLLICENSESTATUSID AS LicenseStatusId,
        LTRIM(RTRIM(ISNULL(lic_status.NAME, ''))) AS LicenseStatus,
        lic.APPLIEDDATE AS AppliedDate,
        lic.ISSUEDDATE AS IssuedDate,
        lic.EXPIRATIONDATE AS ExpirationDate,
        NULL AS IsBilling
    FROM BLGLOBALENTITYEXTENSION buis
        INNER JOIN BLLICENSE lic ON buis.BLGLOBALENTITYEXTENSIONID = lic.BLGLOBALENTITYEXTENSIONID
        INNER JOIN DISTRICT district ON buis.DISTRICTID = district.DISTRICTID
        INNER JOIN BLLICENSETYPE lic_type ON lic.BLLICENSETYPEID = lic_type.BLLICENSETYPEID
        INNER JOIN BLLICENSECLASS lic_class ON lic.BLLICENSECLASSID = lic_class.BLLICENSECLASSID
        INNER JOIN BLLICENSESTATUS lic_status ON lic.BLLICENSESTATUSID = lic_status.BLLICENSESTATUSID

    UNION SELECT
        'BLPA' AS EntityType,
        buis.BLGLOBALENTITYEXTENSIONID AS BusinessId,
        NULL AS BusinessNumber, NULL AS BusinessCompanyTypeId, NULL AS BusinessCompanyType, NULL AS BusinessStatusId, NULL AS BusinessStatus, NULL AS Description, NULL AS TradeName, NULL AS FederalTaxNumber, NULL AS StateTaxNumber, NULL AS DistrictId, NULL AS District, NULL AS BusinessLocationId, NULL AS BusinessLocation, NULL AS OpenDate, NULL AS CloseDate,
        NULL AS ContactId, NULL AS ContactNumber, NULL AS CompanyName, NULL AS FirstName, NULL AS MiddleName, NULL AS LastName, NULL AS Title, NULL AS Email, NULL AS WebSite, NULL AS BusinessPhoneNumber, NULL AS HomePhoneNumber, NULL AS MobilePhoneNumber, NULL AS FaxNumber, NULL AS OtherPhoneNumber, NULL AS IsCompany, NULL AS IsContact,
        NULL AS BusinessContactTypeId, NULL AS BusinessContactType,
        NULL AS MailingAddressId, NULL AS AddressType, NULL AS AddressNumber, NULL AS PreDirection, NULL AS StreetName, NULL AS StreetType, NULL AS PostDirection, NULL AS UnitOrSuite, NULL AS AddressLine3, NULL AS City, NULL AS State, NULL AS ZipCode,
        lic_parcel.MAIN AS IsMain,
        parcel.PARCELID AS ParcelId,
        LTRIM(RTRIM(ISNULL(parcel.PARCELNUMBER, ''))) AS ParcelNumber,
        lic.BLLICENSEID AS LicenseId,
        NULL AS LicenseNumber, NULL AS LicenseYear, NULL AS LicenseTypeId, NULL AS LicenseType, NULL AS LicenseClassId, NULL AS LicenseClass, NULL AS LicenseStatusId, NULL AS LicenseStatus, NULL AS AppliedDate, NULL AS IssuedDate, NULL AS ExpirationDate, NULL AS IsBilling
    FROM BLGLOBALENTITYEXTENSION buis
        INNER JOIN BLLICENSE lic ON buis.BLGLOBALENTITYEXTENSIONID = lic.BLGLOBALENTITYEXTENSIONID
        INNER JOIN BLLICENSEPARCEL lic_parcel ON lic.BLLICENSEID = lic_parcel.BLLICENSEID
        INNER JOIN PARCEL parcel ON lic_parcel.PARCELID = parcel.PARCELID

    UNION SELECT
        'BLAD' AS EntityType,
        buis.BLGLOBALENTITYEXTENSIONID AS BusinessId,
        NULL AS BusinessNumber, NULL AS BusinessCompanyTypeId, NULL AS BusinessCompanyType, NULL AS BusinessStatusId, NULL AS BusinessStatus, NULL AS Description, NULL AS TradeName, NULL AS FederalTaxNumber, NULL AS StateTaxNumber, NULL AS DistrictId, NULL AS District, NULL AS BusinessLocationId, NULL AS BusinessLocation, NULL AS OpenDate, NULL AS CloseDate,
        NULL AS ContactId, NULL AS ContactNumber, NULL AS CompanyName, NULL AS FirstName, NULL AS MiddleName, NULL AS LastName, NULL AS Title, NULL AS Email, NULL AS WebSite, NULL AS BusinessPhoneNumber, NULL AS HomePhoneNumber, NULL AS MobilePhoneNumber, NULL AS FaxNumber, NULL AS OtherPhoneNumber, NULL AS IsCompany, NULL AS IsContact,
        NULL AS BusinessContactTypeId, NULL AS BusinessContactType,
        addr.MAILINGADDRESSID AS MailingAddressId,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSTYPE, ''))) AS AddressType,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE1, ''))) AS AddressNumber,
        LTRIM(RTRIM(ISNULL(addr.PREDIRECTION, ''))) AS PreDirection,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE2, ''))) AS StreetName,
        LTRIM(RTRIM(ISNULL(addr.STREETTYPE, ''))) AS StreetType,
        LTRIM(RTRIM(ISNULL(addr.POSTDIRECTION, ''))) AS PostDirection,
        LTRIM(RTRIM(ISNULL(addr.UNITORSUITE, ''))) AS UnitOrSuite,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE3, ''))) AS AddressLine3,
        LTRIM(RTRIM(ISNULL(addr.CITY, ''))) AS City,
        LTRIM(RTRIM(ISNULL(addr.STATE, ''))) AS State,
        LTRIM(RTRIM(ISNULL(addr.POSTALCODE, ''))) AS ZipCode,
        lic_addr.MAIN AS IsMain,
        NULL AS ParcelId, NULL AS ParcelNumber,
        lic.BLLICENSEID AS LicenseId,
        NULL AS LicenseNumber, NULL AS LicenseYear, NULL AS LicenseTypeId, NULL AS LicenseType, NULL AS LicenseClassId, NULL AS LicenseClass, NULL AS LicenseStatusId, NULL AS LicenseStatus, NULL AS AppliedDate, NULL AS IssuedDate, NULL AS ExpirationDate, NULL AS IsBilling
    FROM BLGLOBALENTITYEXTENSION buis
        INNER JOIN BLLICENSE lic ON buis.BLGLOBALENTITYEXTENSIONID = lic.BLGLOBALENTITYEXTENSIONID
        INNER JOIN BLLICENSEADDRESS lic_addr ON lic.BLLICENSEID = lic_addr.BLLICENSEID
        INNER JOIN MAILINGADDRESS addr ON lic_addr.MAILINGADDRESSID = addr.MAILINGADDRESSID

    UNION SELECT
        'BLCO' AS EntityType,
        buis.BLGLOBALENTITYEXTENSIONID AS BusinessId,
        NULL AS BusinessNumber, NULL AS BusinessCompanyTypeId, NULL AS BusinessCompanyType, NULL AS BusinessStatusId, NULL AS BusinessStatus, NULL AS Description, NULL AS TradeName, NULL AS FederalTaxNumber, NULL AS StateTaxNumber, NULL AS DistrictId, NULL AS District, NULL AS BusinessLocationId, NULL AS BusinessLocation, NULL AS OpenDate, NULL AS CloseDate,
        contact.GLOBALENTITYID AS ContactId,
        LTRIM(RTRIM(contact.CONTACTID)) AS ContactNumber,
        LTRIM(RTRIM(ISNULL(contact.GLOBALENTITYNAME, ''))) AS CompanyName,
        LTRIM(RTRIM(ISNULL(contact.FIRSTNAME, ''))) AS FirstName,
        LTRIM(RTRIM(ISNULL(contact.MIDDLENAME, ''))) AS MiddleName,
        LTRIM(RTRIM(ISNULL(contact.LASTNAME, ''))) AS LastName,
        LTRIM(RTRIM(ISNULL(contact.TITLE, ''))) AS Title,
        LTRIM(RTRIM(ISNULL(contact.EMAIL, ''))) AS Email,
        LTRIM(RTRIM(ISNULL(contact.WEBSITE, ''))) AS WebSite,
        LTRIM(RTRIM(ISNULL(contact.BUSINESSPHONE, ''))) AS BusinessPhoneNumber,
        LTRIM(RTRIM(ISNULL(contact.HOMEPHONE, ''))) AS HomePhoneNumber,
        LTRIM(RTRIM(ISNULL(contact.MOBILEPHONE, ''))) AS MobilePhoneNumber,
        LTRIM(RTRIM(ISNULL(contact.FAX, ''))) AS FaxNumber,
        LTRIM(RTRIM(ISNULL(contact.OTHERPHONE, ''))) AS OtherPhoneNumber,
        contact.ISCOMPANY AS IsCompany,
        contact.ISCONTACT AS IsContact,
        buis_contact_type.BLCONTACTTYPEID AS BusinessContactTypeId,
        LTRIM(RTRIM(ISNULL(buis_contact_type.NAME, ''))) AS BusinessContactType,
        NULL AS MailingAddressId, NULL AS AddressType, NULL AS AddressNumber, NULL AS PreDirection, NULL AS StreetName, NULL AS StreetType, NULL AS PostDirection, NULL AS UnitOrSuite, NULL AS AddressLine3, NULL AS City, NULL AS State, NULL AS ZipCode,
        NULL AS IsMain,
        NULL AS ParcelId, NULL AS ParcelNumber,
        lic.BLLICENSEID AS LicenseId,
        NULL AS LicenseNumber, NULL AS LicenseYear, NULL AS LicenseTypeId, NULL AS LicenseType, NULL AS LicenseClassId, NULL AS LicenseClass, NULL AS LicenseStatusId, NULL AS LicenseStatus, NULL AS AppliedDate, NULL AS IssuedDate, NULL AS ExpirationDate,
        lic_contact.ISBILLING AS IsBilling
    FROM BLGLOBALENTITYEXTENSION buis
        INNER JOIN BLLICENSE lic ON buis.BLGLOBALENTITYEXTENSIONID = lic.BLGLOBALENTITYEXTENSIONID
        INNER JOIN BLLICENSECONTACT lic_contact ON lic.BLLICENSEID = lic_contact.BLLICENSEID
        INNER JOIN BLCONTACTTYPE buis_contact_type ON lic_contact.BLCONTACTTYPEID = buis_contact_type.BLCONTACTTYPEID
        INNER JOIN GLOBALENTITY contact ON buis.GLOBALENTITYID = contact.GLOBALENTITYID

    UNION SELECT
        'BLCA' AS EntityType,
        buis.BLGLOBALENTITYEXTENSIONID AS BusinessId,
        NULL AS BusinessNumber, NULL AS BusinessCompanyTypeId, NULL AS BusinessCompanyType, NULL AS BusinessStatusId, NULL AS BusinessStatus, NULL AS Description, NULL AS TradeName, NULL AS FederalTaxNumber, NULL AS StateTaxNumber, NULL AS DistrictId, NULL AS District, NULL AS BusinessLocationId, NULL AS BusinessLocation, NULL AS OpenDate, NULL AS CloseDate,
        contact.GLOBALENTITYID AS ContactId,
        NULL AS ContactNumber, NULL AS CompanyName, NULL AS FirstName, NULL AS MiddleName, NULL AS LastName, NULL AS Title, NULL AS Email, NULL AS WebSite, NULL AS BusinessPhoneNumber, NULL AS HomePhoneNumber, NULL AS MobilePhoneNumber, NULL AS FaxNumber, NULL AS OtherPhoneNumber, NULL AS IsCompany, NULL AS IsContact,
        NULL AS BusinessContactTypeId, NULL AS BusinessContactType,
        addr.MAILINGADDRESSID AS MailingAddressId,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSTYPE, ''))) AS AddressType,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE1, ''))) AS AddressNumber,
        LTRIM(RTRIM(ISNULL(addr.PREDIRECTION, ''))) AS PreDirection,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE2, ''))) AS StreetName,
        LTRIM(RTRIM(ISNULL(addr.STREETTYPE, ''))) AS StreetType,
        LTRIM(RTRIM(ISNULL(addr.POSTDIRECTION, ''))) AS PostDirection,
        LTRIM(RTRIM(ISNULL(addr.UNITORSUITE, ''))) AS UnitOrSuite,
        LTRIM(RTRIM(ISNULL(addr.ADDRESSLINE3, ''))) AS AddressLine3,
        LTRIM(RTRIM(ISNULL(addr.CITY, ''))) AS City,
        LTRIM(RTRIM(ISNULL(addr.STATE, ''))) AS State,
        LTRIM(RTRIM(ISNULL(addr.POSTALCODE, ''))) AS ZipCode,
        NULL AS IsMain,
        NULL AS ParcelId, NULL AS ParcelNumber,
        lic.BLLICENSEID AS LicenseId,
        NULL AS LicenseNumber, NULL AS LicenseYear, NULL AS LicenseTypeId, NULL AS LicenseType, NULL AS LicenseClassId, NULL AS LicenseClass, NULL AS LicenseStatusId, NULL AS LicenseStatus, NULL AS AppliedDate, NULL AS IssuedDate, NULL AS ExpirationDate, NULL AS IsBilling
    FROM BLGLOBALENTITYEXTENSION buis
        INNER JOIN BLLICENSE lic ON buis.BLGLOBALENTITYEXTENSIONID = lic.BLGLOBALENTITYEXTENSIONID
        INNER JOIN BLLICENSECONTACT lic_contact ON lic.BLLICENSEID = lic_contact.BLLICENSEID
        INNER JOIN GLOBALENTITY contact ON buis.GLOBALENTITYID = contact.GLOBALENTITYID
        INNER JOIN GLOBALENTITYMAILINGADDRESS contact_addr ON contact.GLOBALENTITYID = contact_addr.GLOBALENTITYID
        INNER JOIN MAILINGADDRESS addr ON contact_addr.MAILINGADDRESSID = addr.MAILINGADDRESSID
    ) x
INNER JOIN BLGLOBALENTITYEXTENSION buis ON buis.BLGLOBALENTITYEXTENSIONID = x.BusinessId
WHERE buis.BLEXTCOMPANYTYPEID = 'b0bcecf3-927a-45ac-b93a-45cc5a5c37c0' AND buis.BLEXTSTATUSID = '3d99f589-e6a1-48d1-9015-3f6973034da2'