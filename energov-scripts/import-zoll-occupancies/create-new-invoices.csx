#r "nuget: System.Data.SqlClient, 4.6.0"
#r "nuget: Dapper, 1.60.6"

#load "classes/EnerGovOccupancyBusiness.csx"
#load "classes/LandRecords.csx"
#load "classes/SqlManager.csx"

using System.Data.SqlClient;
using Dapper;

var INVOICE_DATE = DateTime.Now;
var INVOICE_DUE_DATE = INVOICE_DATE.AddMonths(3);


var ENERGOV_SQL_CONNECTION_STRING = @"Server=lax-sql1\ENERGOV;Database=energov_prod;Trusted_Connection=True;";
var LANDRECORDS_SQL_CONNECTION_STRING = @"Server=lax-sql1;Database=LandRecords;Trusted_Connection=True;";

var landRecordsSqlConnection = new SqlConnection(LANDRECORDS_SQL_CONNECTION_STRING);
await landRecordsSqlConnection.OpenAsync();

var enerGovSqlConnection = new SqlConnection(ENERGOV_SQL_CONNECTION_STRING);
await enerGovSqlConnection.OpenAsync();

var enerGovSqlManager = new SqlManager(enerGovSqlConnection, false);

if (enerGovSqlManager.ExecuteCommands) {
    Console.WriteLine($"Warning you are about to make changes to the '{ENERGOV_SQL_CONNECTION_STRING}' database!!!");
    Console.Write("Are you sure (Y/N)? ");

    var key = Console.ReadKey();
    Console.WriteLine("");
    if (!key.KeyChar.ToString().ToUpper().Equals("Y")) {
        Console.WriteLine("Exiting!");
        Environment.Exit(-1);
    }
}

var landRecordsParcelOwners = (await landRecordsSqlConnection.QueryAsync<CompleteParcelOwner>(@"SELECT 
        PropertyId, OwnerId, ParcelNumber, LastName, FirstName, IsBusiness, StreetName, StreetType, 
        StreetPrefixDirectional, StreetSuffixDirectional, HouseNumber, SecondaryNumber, SecondaryType, 
        City, State, ZipCode
    FROM ParcelOwners")).ToLookup(_ => _.ParcelNumber);
Console.WriteLine($"Found {landRecordsParcelOwners.Count()} land records parcels");

var occupancyBusinesses = await enerGovSqlConnection.QueryAsync<EnerGovOccupancyBusiness>(@"SELECT
        geext.BLGLOBALENTITYEXTENSIONID,
        geext.DBA,
        geext.REGISTRATIONID,
        geext.STATETAXNUMBER,
        gect_zone.BLEXTBUSINESSTYPEID AS ZoneId,
        gect_type.BLEXTBUSINESSTYPEID AS TypeId,
        cslm.FireHighLifeSafetySquareFootage,
        cslm.FireCommercialSquareFootage,
        cslm.FireNumberOfHotelRooms,
        cslm.FireNumberOfApartments
    FROM BLGLOBALENTITYEXTENSION geext
    INNER JOIN BLGLOBALENTITYEXTBUSTYPE gect_zone ON
        geext.BLGLOBALENTITYEXTENSIONID = gect_zone.BLGLOBALENTITYEXTENSIONID
    INNER JOIN BLEXTBUSINESSTYPE gebt_zone ON
        gect_zone.BLEXTBUSINESSTYPEID = gebt_zone.BLEXTBUSINESSTYPEID AND
        gebt_zone.BLEXTBUSINESSCATEGORYID = '4f47636f-0830-424d-a209-977ae9485f5e'
    INNER JOIN BLGLOBALENTITYEXTBUSTYPE gect_type ON
        geext.BLGLOBALENTITYEXTENSIONID = gect_type.BLGLOBALENTITYEXTENSIONID
    INNER JOIN BLEXTBUSINESSTYPE gebt_type ON
        gect_type.BLEXTBUSINESSTYPEID = gebt_type.BLEXTBUSINESSTYPEID AND
        gebt_type.BLEXTBUSINESSCATEGORYID = '7b3266a4-e2fe-4aa3-93cb-b785c3b0eb3c'
    INNER JOIN CUSTOMSAVERLICENSEMANAGEMENT cslm ON
        geext.BLGLOBALENTITYEXTENSIONID = cslm.ID
    WHERE geext.BLEXTCOMPANYTYPEID = 'aa449424-7b5c-4197-a715-6ddba9c6af18' AND
          geext.BLEXTSTATUSID = '3d99f589-e6a1-48d1-9015-3f6973034da2' AND
          cslm.IsBilledOccupancy = 1");

Console.WriteLine($"Found {occupancyBusinesses.Count()} to generate invoices.");

var occupancyParcels = (await enerGovSqlConnection.QueryAsync<EnerGovOccupancyBusinessParcel>(@"SELECT
        geext.BLGLOBALENTITYEXTENSIONID,
        gepar.PARCELID,
        gepar.MAIN,
        par.PARCELNUMBER
    FROM BLGLOBALENTITYEXTENSION geext
    INNER JOIN BLGLOBALENTITYEXTENSIONPARCEL gepar ON geext.BLGLOBALENTITYEXTENSIONID = gepar.BLGLOBALENTITYEXTENSIONID
    INNER JOIN PARCEL par ON gepar.PARCELID = par.PARCELID
    WHERE geext.BLEXTCOMPANYTYPEID = 'aa449424-7b5c-4197-a715-6ddba9c6af18' AND geext.BLEXTSTATUSID = '3d99f589-e6a1-48d1-9015-3f6973034da2'")).ToLookup(_ => _.BLGLOBALENTITYEXTENSIONID);
Console.WriteLine($"Count of Occupancy Parcels: {occupancyParcels.Sum(_ => _.Count())}");

var occupancyAddresses = (await enerGovSqlConnection.QueryAsync<EnerGovOccupancyBusinessAddress>(@"SELECT
        geext.BLGLOBALENTITYEXTENSIONID,
        geaddr.MAILINGADDRESSID,
        geaddr.MAIN
    FROM BLGLOBALENTITYEXTENSION geext
    INNER JOIN BLGLOBALENTITYEXTENSIONADDRESS geaddr ON geext.BLGLOBALENTITYEXTENSIONID = geaddr.BLGLOBALENTITYEXTENSIONID
    WHERE geext.BLEXTCOMPANYTYPEID = 'aa449424-7b5c-4197-a715-6ddba9c6af18' AND geext.BLEXTSTATUSID = '3d99f589-e6a1-48d1-9015-3f6973034da2'")).ToLookup(_ => _.BLGLOBALENTITYEXTENSIONID);
Console.WriteLine($"Count of Occupancy Addresses: {occupancyAddresses.Sum(_ => _.Count())}");

var occupancyContacts = (await enerGovSqlConnection.QueryAsync<EnerGovOccupancyBusinessContact>(@"SELECT
        geext.BLGLOBALENTITYEXTENSIONID,
        gecont.GLOBALENTITYID,
        gecont.BLCONTACTTYPEID
    FROM BLGLOBALENTITYEXTENSION geext
    INNER JOIN BLGLOBALENTITYEXTENSIONCONTACT gecont ON geext.BLGLOBALENTITYEXTENSIONID = gecont.BLGLOBALENTITYEXTENSIONID
    WHERE geext.BLEXTCOMPANYTYPEID = 'aa449424-7b5c-4197-a715-6ddba9c6af18' AND geext.BLEXTSTATUSID = '3d99f589-e6a1-48d1-9015-3f6973034da2'")).ToLookup(_ => _.BLGLOBALENTITYEXTENSIONID);
Console.WriteLine($"Count of Occupancy Contacts: {occupancyContacts.Sum(_ => _.Count())}");

var allParcelNumbers = occupancyParcels.SelectMany(_ => _.Where(x => x.MAIN).Select(x => x.PARCELNUMBER));

if (allParcelNumbers.Any(_ =>!landRecordsParcelOwners.Contains(_))) {
    Console.WriteLine($"Missing parcels!!!!! {allParcelNumbers.Count(_ =>!landRecordsParcelOwners.Contains(_))}");
    foreach (var parcelNumber in allParcelNumbers.Where(_ =>!landRecordsParcelOwners.Contains(_))) {
        Console.WriteLine(parcelNumber);
    }
}

var occupanciesMissingOwnerContacts = 0;

//var feeOwnerMappings = new List<(int OwnerEntityId, string ComputedFeeId, decimal FeeAmount)>();

var feeOwnerLookup = new Dictionary<int, List<(string ComputedFeeId, decimal FeeAmount)>>();
var ownerAddressLookup = new Dictionary<int, CompleteParcelOwner>();

try {

    foreach (var business in occupancyBusinesses.Where(_ => !_.ZoneId.Equals("f8c1ddbf-e669-41f4-bbda-02042226ff51")).OrderBy(_ => _.BLGLOBALENTITYEXTENSIONID)) {

        var parcels = occupancyParcels[business.BLGLOBALENTITYEXTENSIONID];
        var addresses = occupancyAddresses[business.BLGLOBALENTITYEXTENSIONID];
        var contacts = occupancyContacts[business.BLGLOBALENTITYEXTENSIONID];

        var mainParcel = parcels.First(_ => _.MAIN);

        var inspectionId = Guid.NewGuid().ToString();

        Console.WriteLine($"Processing Business {business.STATETAXNUMBER} -> {business.DBA}:");

        
        var inspectionNumber = await enerGovSqlConnection.ExecuteScalarAsync<string>(@"SELECT dbo.GetAutoNumberWithClassName('EnerGovBusiness.Inspections.Inspection')");

        
        Console.WriteLine($"  [BUIS] {business.BLGLOBALENTITYEXTENSIONID} {business.REGISTRATIONID} {inspectionNumber.Substring(1)}");

        await enerGovSqlManager.ExecuteScalarAsync(@"EXEC dbo.GETANDUPDATEAUTONUMBER 'EnerGovBusiness.Inspections.Inspection'");

        await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO IMINSPECTION
                (IMINSPECTIONID, IMINSPECTIONSTATUSID, IMINSPECTIONTYPEID, INSPECTIONNUMBER, CREATEDATE, REQUESTEDDATE, REINSPECTED, ISREINSPECTION,
                COMPLETE, ROWVERSION, LASTCHANGEDBY, LASTCHANGEDON, GISX, GISY, IMINSPECTIONLINKID, LINKID,
                LINKNUMBER, REQUESTEDAMORPM, SCHEDULEDAMORPM, IMINSPECTIONREQUESTEDSOURCEID, PARENTINSPECTIONNUMBER, ESTIMATEDMINUTES,
                ISPARTIALPASS, INSPECTIONORDER, COMMENTS, NEXTSCHEDULEDAMORPM,SCHEDULEDSTARTDATE,SCHEDULEDENDDATE)
            VALUES
                (
                @InspectionId,
                'ebae609f-550d-4656-85e6-88e5d9e51e14',
                '27d06b89-2626-4244-ace6-ae981d0d40bb',
                @InspectionNumber,
                GETDATE(),
                GETDATE(),
                0,
                0,
                0,
                1,
                'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
                GETDATE(),
                0,
                0,
                5,
                @GlobalEntityExtensionId,
                @GlobalEntityDBA,
                0,
                0,
                1,
                '',
                0,
                0,
                0,
                '',
                0,
                GETDATE(),
                GETDATE()
                )", new {
                    InspectionId = inspectionId,
                    InspectionNumber = inspectionNumber.Substring(1),
                    GlobalEntityExtensionId = business.BLGLOBALENTITYEXTENSIONID,
                    GlobalEntityDBA = business.DBA
                });
        

        await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO IMINSPECTIONACTREF 
                (OBJECTID, IMINSPECTIONID, OBJECTMSG) 
            VALUES 
                (
                    @GlobaleEntityExtensionId,
                    @InspectionId,
                    @RegistrationNumber
                )", new {
                    GlobaleEntityExtensionId = business.BLGLOBALENTITYEXTENSIONID,
                    InspectionId = inspectionId,
                    RegistrationNumber = business.REGISTRATIONID
                });

        
        
        await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO CUSTOMSAVERINSPECTIONS 
            (ID, FireHighLifeSafetySquareFootage, FireCommercialSquareFootage, FireNumberOfHotelRooms, FireNumberOfApartments) 
            VALUES (
                @InspectionId,
                @FireHighLifeSafetySquareFootage, 
                @FireCommercialSquareFootage, 
                @FireNumberOfHotelRooms, 
                @FireNumberOfApartments)", 
            new {
                InspectionId = inspectionId,
                FireHighLifeSafetySquareFootage = business.FireHighLifeSafetySquareFootage, 
                FireCommercialSquareFootage = business.FireCommercialSquareFootage, 
                FireNumberOfHotelRooms = business.FireNumberOfHotelRooms, 
                FireNumberOfApartments = business.FireNumberOfApartments
            });
        await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO CUSTOMSAVERINSPECTIONS2 (ID) VALUES (@InspectionId)", new {InspectionId = inspectionId});

        foreach (var parcel in parcels) {
            Console.WriteLine($"    [PARCEL] {parcel.PARCELID}");

            await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO IMINSPECTIONPARCEL
                    (INSPECTIONPARCELID, PARCELID, IMINSPECTIONID, MAIN)
                VALUES 
                    (
                    @InspectionParcelId,
                    @ParcelId,
                    @InspectionId,
                    @IsMain
                    )", new {
                        InspectionParcelId = Guid.NewGuid().ToString(),
                        ParcelId = parcel.PARCELID,
                        InspectionId = inspectionId,
                        IsMain = parcel.MAIN
                    });
        }

        foreach (var address in addresses) {
            Console.WriteLine($"    [ADDRESS] {address.MAILINGADDRESSID}");

            var mailingAddressId = Guid.NewGuid().ToString();

            await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO MAILINGADDRESS
                                (MAILINGADDRESSID, ADDRESSLINE1, ADDRESSLINE2, ADDRESSLINE3, CITY, STATE, COUNTY,
                                COUNTRY, POSTALCODE, COUNTRYTYPE, LASTCHANGEDON, LASTCHANGEDBY,
                                POSTDIRECTION, PREDIRECTION, ROWVERSION, ADDRESSID, ADDRESSTYPE, STREETTYPE,
                                PARCELID, PARCELNUMBER, UNITORSUITE, PROVINCE,
                                RURALROUTE, STATION, COMPSITE, POBOX, ATTN, GENERALDELIVERY)
                            SELECT TOP 1
                                @NewMailingAddressId,
                                ma.ADDRESSLINE1,
                                ma.ADDRESSLINE2,
                                ma.ADDRESSLINE3,
                                ma.CITY,
                                ma.STATE,
                                ma.COUNTY,
                                ma.COUNTRY,
                                ma.POSTALCODE,
                                ma.COUNTRYTYPE,
                                GETDATE(),
                                'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
                                ma.POSTDIRECTION,
                                ma.PREDIRECTION,
                                1,
                                ma.ADDRESSID,
                                ma.ADDRESSTYPE,
                                ma.STREETTYPE,
                                ma.PARCELID,
                                ma.PARCELNUMBER,
                                ma.UNITORSUITE,
                                ma.PROVINCE,
                                ma.RURALROUTE,
                                ma.STATION,
                                ma.COMPSITE,
                                ma.POBOX,
                                ma.ATTN,
                                ma.GENERALDELIVERY
                            FROM MAILINGADDRESS ma
                            WHERE ma.MAILINGADDRESSID = @MailingAddressId",
                            new {
                                MailingAddressId = address.MAILINGADDRESSID,
                                NewMailingAddressId = mailingAddressId
                            });

            await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO IMINSPECTIONADDRESS
                    (INSPECTIONADDRESSID, IMINSPECTIONID, MAILINGADDRESSID, MAIN) 
                VALUES
                    (
                        @InspectionAddressId,
                        @InspectionId,
                        @MailingAddressId,
                        @IsMain
                    )", new {
                        InspectionAddressId = Guid.NewGuid().ToString(),
                        InspectionId = inspectionId,
                        MailingAddressId = mailingAddressId,
                        IsMain = address.MAIN
                    });
        }

        if (!contacts.Any(_ => _.BLCONTACTTYPEID.Equals("e87c4fa4-dc69-40b3-802f-9e6eba3e1808"))) {
            if (enerGovSqlManager.ExecuteCommands) {
                throw new Exception("No Owner Contact attached to Business!");
            }
            occupanciesMissingOwnerContacts++;
        }

        // (FeeTemplateId, FeeName, InputValue, ComputedAmount, FeeOrder)
        var feesToAdd = new List<(string FeeTemplateId, string FeeName, decimal InputValue, decimal ComputedAmount, int FeeOrder)>();

        if ((business.FireCommercialSquareFootage ?? 0) > 0) {
            
            var fee = 0.00m;
            if (business.FireCommercialSquareFootage < 5000) {
                fee = 50.00m;
            } else if (business.FireCommercialSquareFootage <= 25000) {
                fee = 98.00m;
            } else if (business.FireCommercialSquareFootage <= 50000) {
                fee = 146.25m;
            } else if (business.FireCommercialSquareFootage <= 75000) {
                fee = 210.25m;
            } else if (business.FireCommercialSquareFootage <= 100000) {
                fee = 245.00m;
            } else if (business.FireCommercialSquareFootage <= 125000) {
                fee = 291.05m;
            } else {
                fee = 342.00m;
                int additionalAmount = (int)(business.FireCommercialSquareFootage - 150000);
                if (additionalAmount > 0) {
                    var additionalUnits = (int)(additionalAmount / 50000);
                    if (additionalAmount % 50000 > 0) {
                        additionalUnits += 1;
                    }
                    fee += 50.00m * (decimal)(additionalUnits);
                }
            }
            //Console.WriteLine($"    Commercial Fee = {fee:C2} (Square Footage = {business.FireCommercialSquareFootage:F0})");
            feesToAdd.Add((FeeTemplateId: "40e5aa0b-825d-4565-b01d-7bf311b30a92", FeeName: "Fire Inspection Fee - Commercial", InputValue: (decimal)business.FireCommercialSquareFootage, ComputedAmount: fee, FeeOrder: 4));
            
        }

        if ((business.FireHighLifeSafetySquareFootage ?? 0) > 0) {
            var fee = 0.00m;
            if (business.FireHighLifeSafetySquareFootage < 5000) {
                fee = 92.75m;
            } else if (business.FireHighLifeSafetySquareFootage <= 25000) {
                fee = 198.00m;
            } else if (business.FireHighLifeSafetySquareFootage <= 50000) {
                fee = 275.75m;
            } else if (business.FireHighLifeSafetySquareFootage <= 75000) {
                fee = 369.00m;
            } else if (business.FireHighLifeSafetySquareFootage <= 100000) {
                fee = 463.00m;
            } else if (business.FireHighLifeSafetySquareFootage <= 125000) {
                fee = 555.25m;
            } else if (business.FireHighLifeSafetySquareFootage <= 150000) {
                fee = 683.50m;
            } else if (business.FireHighLifeSafetySquareFootage <= 175000) {
                fee = 781.50m;
            } else if (business.FireHighLifeSafetySquareFootage <= 200000) {
                fee = 897.50m;
            } else if (business.FireHighLifeSafetySquareFootage <= 225000) {
                fee = 977.50m;
            } else if (business.FireHighLifeSafetySquareFootage <= 250000) {
                fee = 1075.30m;
            } else if (business.FireHighLifeSafetySquareFootage <= 275000) {
                fee = 1173.50m;
            } else if (business.FireHighLifeSafetySquareFootage <= 300000) {
                fee = 1271.50m;
            } else if (business.FireHighLifeSafetySquareFootage <= 325000) {
                fee = 1369.50m;
            } else if (business.FireHighLifeSafetySquareFootage <= 350000) {
                fee = 1467.50m;
            } else if (business.FireHighLifeSafetySquareFootage <= 375000) {
                fee = 1565.50m;
            } else if (business.FireHighLifeSafetySquareFootage <= 400000) {
                fee = 1663.50m;
            } else if (business.FireHighLifeSafetySquareFootage <= 425000) {
                fee = 1761.50m;
            } else if (business.FireHighLifeSafetySquareFootage <= 450000) {
                fee = 1859.50m;
            } else if (business.FireHighLifeSafetySquareFootage <= 475000) {
                fee = 1957.50m;
            } else {
                fee = 2055.50m;
            }
            //Console.WriteLine($"    High Life Safety Fee = {fee:C2} (Square Footage = {business.FireHighLifeSafetySquareFootage:F0})");
            feesToAdd.Add((FeeTemplateId: "a2519b5e-36b4-492e-bbdc-73ac530fa9c9", FeeName: "Fire Inspection Fee - High Life Safety", InputValue: (decimal)business.FireHighLifeSafetySquareFootage, ComputedAmount: fee, FeeOrder: 6));

        }

        if ((business.FireNumberOfApartments ?? 0) > 0) {
            var fee = 0.00m;
            if (business.FireNumberOfApartments < 5) {
                fee = 10.00m;
            } else if (business.FireNumberOfApartments < 13) {
                fee = 20.00m;
            } else if (business.FireNumberOfApartments < 19) {
                fee = 30.00m;
            } else {
                fee = 50.00m;
            }

            //Console.WriteLine($"    Apartment Fee = {fee:C2} (Units = {business.FireNumberOfApartments:F0})");
            feesToAdd.Add((FeeTemplateId: "7c56b788-568e-4fe3-ba2a-8c3999f4e1d5", FeeName: "Fire Inspection Fee - Apartments", InputValue: (decimal)business.FireNumberOfApartments, ComputedAmount: fee, FeeOrder: 2));
        }

        if ((business.FireNumberOfHotelRooms ?? 0) > 0) {
            var fee = (business.FireNumberOfHotelRooms ?? 0) * 5.00m;

            //Console.WriteLine($"    Hotel Fee = {fee:C2} (Rooms = {business.FireNumberOfHotelRooms:F0})");
            feesToAdd.Add((FeeTemplateId: "d74718e5-cf2c-4bbc-b769-6a42a051fd4c", FeeName: "Fire Inspection Fee - Hotel", InputValue: (decimal)business.FireNumberOfHotelRooms, ComputedAmount: fee, FeeOrder: 8));
        }

        foreach (var feeToAdd in feesToAdd.OrderBy(_ => _.FeeOrder)) {

            Console.Write($"    [FEE] {feeToAdd.FeeName} => {feeToAdd.ComputedAmount:C2} (Input Value = {feeToAdd.InputValue:F0}): ");

            var feeNumber = await enerGovSqlConnection.ExecuteScalarAsync<string>(@"SELECT dbo.GetAutoNumberWithClassName('EnerGovBusiness.Cashier.CAComputedFee')");
        
            Console.WriteLine(feeNumber);

            await enerGovSqlManager.ExecuteScalarAsync(@"EXEC dbo.GETANDUPDATEAUTONUMBER 'EnerGovBusiness.Cashier.CAComputedFee'");

            var computedFeeId = Guid.NewGuid().ToString();

            await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO CACOMPUTEDFEE
                (CACOMPUTEDFEEID, CAFEETEMPLATEFEEID, FEEDESCRIPTION, FEEORDER, ISMANUALLYADDED, COMPUTEDAMOUNT,
                ISPROCESSED, CASTATUSID, AMOUNTPAIDTODATE, ROWVERSION, LASTCHANGEDON, LASTCHANGEDBY, ISDELETED,
                INPUTVALUE, FEEPRIORITY, FEENUMBER, CREATEDBY, CREATEDON, FEENAME, BASEAMOUNT, NOTES, DISPLAYINPUTVALUE,
                ISONLINEADDED, TIMETRACKINGID, WFACTIONID, TOTALFEEBASEDID, CPIAMOUNT, FEEPRORATIONAMOUNT, FEEPRORATIONRATE,
                CREDITAMOUNT, ISRENEWALFEE)
                VALUES (
                        @ComputedFeeId,
                        @FeeTemplateFeeId,
                        @FeeName,
                        @FeeOrder,
                        1,
                        @ComputedAmount,
                        0,
                        1,
                        0,
                        1,
                        GETDATE(),
                        'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
                        0,
                        @InputValue,
                        0,
                        @FeeNumber,
                        'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
                        GETDATE(),
                        @FeeName,
                        @ComputedAmount,
                        '',
                        @InputValue,
                        0,
                        NULL,
                        NULL,
                        NULL,
                        0,
                        0,
                        0,
                        0,
                        0
                        )",
                new {
                    ComputedFeeId = computedFeeId,
                    FeeTemplateFeeId = feeToAdd.FeeTemplateId,
                    FeeName = feeToAdd.FeeName,
                    FeeOrder = feeToAdd.FeeOrder,
                    ComputedAmount= feeToAdd.ComputedAmount,
                    InputValue = feeToAdd.InputValue,
                    feeNumber = feeNumber
                });

                Console.WriteLine($"        (CACOMPUTEDFEE): {computedFeeId}");

                var inspectionFeeId = Guid.NewGuid().ToString();

                await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO IMINSPECTIONFEE (IMINSPECTIONFEEID, IMINSPECTIONID, CACOMPUTEDFEEID, CREATEDON) 
                    VALUES (
                            @InspectionFeeId,
                            @InspectionId,
                            @ComputedFeeId,
                            GETDATE()
                        )",
                    new {
                        InspectionFeeId = inspectionFeeId,
                        InspectionId = inspectionId,
                        ComputedFeeId = computedFeeId
                    });
                
                Console.WriteLine($"        (IMINSPECTIONFEE): {inspectionFeeId}");

                if (landRecordsParcelOwners.Contains(mainParcel.PARCELNUMBER)) {
                    var parcelOwner = landRecordsParcelOwners[mainParcel.PARCELNUMBER].First();

                    if (!ownerAddressLookup.ContainsKey(parcelOwner.OwnerId)) {
                        ownerAddressLookup.Add(parcelOwner.OwnerId, parcelOwner);
                    }

                    if (!feeOwnerLookup.ContainsKey(parcelOwner.OwnerId)) {
                        feeOwnerLookup.Add(parcelOwner.OwnerId, new List<(string ComputedFeeId, decimal FeeAmount)>());
                    }

                    feeOwnerLookup[parcelOwner.OwnerId].Add((ComputedFeeId: computedFeeId, FeeAmount: feeToAdd.ComputedAmount));
                }

                

        }

    }

    var invoiceNumbers = new List<string>();

    foreach (var ownerFeeGroup in feeOwnerLookup.OrderBy(_ => _.Value.Count())) {

        var ownerInformation = ownerAddressLookup[ownerFeeGroup.Key];

        Console.Write($"Generating invoice for {ownerInformation.OwnerId} => {ownerFeeGroup.Value.Count()} ");

        var invoiceNumber = await enerGovSqlConnection.ExecuteScalarAsync<string>(@"SELECT dbo.GetAutoNumberWithClassName('EnerGovBusiness.Cashier.CAInvoice')");
        invoiceNumbers.Add(invoiceNumber);
        await enerGovSqlManager.ExecuteScalarAsync(@"EXEC dbo.GETANDUPDATEAUTONUMBER 'EnerGovBusiness.Cashier.CAInvoice'");
        var invoiceId = Guid.NewGuid().ToString();
        Console.WriteLine($"  Invoice Number = {invoiceNumber} [ID = {invoiceId}]");


        var globalEntityNumber = "ID-" + (await enerGovSqlManager.ExecuteScalarAsync<string>(@"SELECT dbo.GetAutoNumberWithClassName('EnerGovBusiness.SystemSetup.GlobalEntity')"));
        await enerGovSqlManager.ExecuteScalarAsync(@"EXEC dbo.GETANDUPDATEAUTONUMBER 'EnerGovBusiness.SystemSetup.GlobalEntity'");
        var globalEntityId = Guid.NewGuid().ToString();
        Console.WriteLine($"  Global Entity Number = {globalEntityNumber} [ID = {globalEntityId}]");
        
        await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO GLOBALENTITY
                (GLOBALENTITYID, GLOBALENTITYNAME, ISCOMPANY, ISCONTACT, MANUFACTURER, VENDOR, SHIPPER, EMAIL, WEBSITE,
                BUSINESSPHONE, HOMEPHONE, MOBILEPHONE, OTHERPHONE, FAX, FIRSTNAME, LASTNAME, MIDDLENAME, TITLE, LASTCHANGEDON,
                LASTCHANGEDBY, ROWVERSION, CONTACTID, PREFCOMM, ISACTIVE)
            VALUES (
                    @GlobalEntityId,
                    @GlobalEntityName,
                    @IsCompany,
                    @IsContact,
                    0,
                    0,
                    0,
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    '',
                    @FirstName,
                    @LastName,
                    '',
                    '',
                    GETDATE(),
                    'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
                    1,
                    @ContactId,
                    0,
                    0
                )",
                new {
                    GlobalEntityId = globalEntityId,
                    IsCompany = ownerInformation.IsBusiness ?? false,
                    IsContact = !(ownerInformation.IsBusiness ?? false),
                    GlobalEntityName = (ownerInformation.FirstName + " " + ownerInformation.LastName).Trim(),
                    FirstName = ownerInformation.FirstName.Trim(),
                    LastName = ownerInformation.LastName.Trim(),
                    ContactId = globalEntityNumber
                });

        var mailingAddressId = Guid.NewGuid().ToString();
        Console.WriteLine($"    Mailing Address ID = {mailingAddressId}");

        await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO MAILINGADDRESS
                            (MAILINGADDRESSID, ADDRESSLINE1, ADDRESSLINE2, ADDRESSLINE3, CITY, STATE, COUNTY,
                             COUNTRY, POSTALCODE, COUNTRYTYPE, LASTCHANGEDON, LASTCHANGEDBY,
                             POSTDIRECTION, PREDIRECTION, ROWVERSION, ADDRESSID, ADDRESSTYPE, STREETTYPE,
                             PARCELID, PARCELNUMBER, UNITORSUITE, PROVINCE,
                             RURALROUTE, STATION, COMPSITE, POBOX, ATTN, GENERALDELIVERY)
                    VALUES (
                            @MailingAddressId,
                            @AddressLine1,
                            @AddressLine2,
                            '',
                            @City,
                            @State,
                            NULL,
                            'USA',
                            @PostalCode,
                            0,
                            GETDATE(),
                            'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
                            @PostDirection,
                            @PreDirection,
                            1,
                            NULL,
                            'Location',
                            @StreetType,
                            NULL,
                            '',
                            @UnitOrSuite,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL,
                            NULL)",
                        new {
                            MailingAddressId = mailingAddressId,
                            AddressLine1 = ownerInformation?.HouseNumber ?? "",
                            AddressLine2 = ownerInformation?.StreetName ?? "",
                            City = ownerInformation?.City ?? "",
                            State = ownerInformation?.State ?? "",
                            PostalCode = ownerInformation?.ZipCode ?? "",
                            PostDirection = ownerInformation?.StreetSuffixDirectional ?? "",
                            PreDirection = ownerInformation?.StreetPrefixDirectional ?? "",
                            StreetType = ownerInformation?.StreetType ?? "",
                            UnitOrSuite = ((ownerInformation?.SecondaryType ?? "") + " " + (ownerInformation?.SecondaryNumber ?? "")).Trim()
                        });

        var globalEntityMailingAddressId = Guid.NewGuid().ToString();
        Console.WriteLine($"    Global Entity Mailing Address ID = {globalEntityMailingAddressId}");

        await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO GLOBALENTITYMAILINGADDRESS
                        (GLOBALENTITYMAILINGADDRESSID, GLOBALENTITYID, MAILINGADDRESSID, MAIN)
                    VALUES (
                            @GlobalEntityMailingAddressId,
                            @GlobalEntityId,
                            @MailingAddressId,
                            1)",
                        new {
                            GlobalEntityMailingAddressId = globalEntityMailingAddressId,
                            GlobalEntityId = globalEntityId,
                            MailingAddressId = mailingAddressId
                        });


        await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO CAINVOICE
            (CAINVOICEID, CASTATUSID, INVOICENUMBER, GLOBALENTITYID, INVOICETOTAL, INVOICEDATE,
            INVOICEDESCRIPTION, ROWVERSION, LASTCHANGEDON, LASTCHANGEDBY, INVOICEDUEDATE, ADJUSTEDDATE, CREATEDBY)
        VALUES (
                @InvoiceId,
                1,
                @InvoiceNumber,
                @GlobalEntityId,
                @InvoiceTotal,
                @InvoiceDate,
                @InvoiceDescription,
                1,
                GETDATE(),
                'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
                @InvoiceDueDate,
                NULL,
                'a24df514-c3c1-49c7-8784-0b2bf58c79fa')",
            new {
                InvoiceId = invoiceId,
                InvoiceNumber = invoiceNumber,
                GlobalEntityId = globalEntityId,
                InvoiceTotal = ownerFeeGroup.Value.Sum(_ => _.FeeAmount),
                InvoiceDate = INVOICE_DATE,
                InvoiceDescription = "",
                InvoiceDueDate = INVOICE_DUE_DATE
            });
     
         Console.WriteLine($"    (CAINVOICE) {invoiceId}");

         var invoiceContactId = Guid.NewGuid().ToString();

         await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO CAINVOICECONTACT 
                 (CAINVOICECONTACTID, CAINVOICEID, GLOBALENTITYID, ISACTIVE) 
             VALUES (
                     @InvoiceContactId,
                     @InvoiceId,
                     @GlobalEntityId,
                     1)",
             new {
                 InvoiceContactId = invoiceContactId,
                 InvoiceId = invoiceId,
                 GlobalEntityId = globalEntityId
             });
        
         Console.WriteLine($"    (CAINVOICECONTACT) {invoiceContactId}");

         var transactionAccountReceivablePostingId = Guid.NewGuid().ToString();

        await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO CATRANSACTIONARPOSTING
                (CATRANSACTIONARPOSTINGID, DEBITACCOUNTID, DEBITACCOUNTNUMBER, CREDITACCOUNTID, CREDITACCOUNTNUMBER,
                POSTINGDATE, POSTINGAMOUNT, CATRANSACTIONARTYPEID, POSTEDBYUSER, EXPORTEDON)
            VALUES (
                    @TransactionARPostingId,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    GETDATE(),
                    @PostingAmount,
                    2,
                    'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
                    NULL)",
            new {
                TransactionARPostingId = transactionAccountReceivablePostingId,
                PostingAmount = ownerFeeGroup.Value.Sum(_ => _.FeeAmount)
            });

         Console.WriteLine($"    (CATRANSACTIONARPOSTING) {transactionAccountReceivablePostingId}");

         foreach (var feeToProcess in ownerFeeGroup.Value) {

             Console.WriteLine($"    Processing Fee {feeToProcess.ComputedFeeId}");

             var invoiceFeeId = Guid.NewGuid().ToString();

             await enerGovSqlManager.ExecuteScalarAsync(@"INSERT CAINVOICEFEE
                     (CAINVOICEFEEID, CACOMPUTEDFEEID, CAINVOICEID, PAIDAMOUNT, CREATEDON, CREATEDBY)
                 VALUES (
                         @InvoiceFeeId,
                         @ComputedFeeId,
                         @InvoiceId,
                         0,
                         GETDATE(),
                         'a24df514-c3c1-49c7-8784-0b2bf58c79fa')",
                 new {
                     InvoiceFeeId = invoiceFeeId,
                     ComputedFeeId = feeToProcess.ComputedFeeId,
                     InvoiceId = invoiceId
                 });
            
             Console.WriteLine($"        (CAINVOICEFEE) {invoiceFeeId}");

            //  var invoiceFeePostingId = Guid.NewGuid().ToString();

            //  await enerGovSqlManager.ExecuteScalarAsync(@"INSERT CAINVOICEFEEARPOSTING 
            //          (CAINVOICEFEEARPOSTINGID, CAINVOICEFEEID, CATRANSACTIONARPOSTINGID) 
            //      VALUES (
            //              @InvoiceFeePostingId,
            //              @InvoiceFeeId,
            //              @TransactionPostingId)",
            //      new {
            //          InvoiceFeePostingId = invoiceFeePostingId,
            //          InvoiceFeeId = invoiceFeeId,
            //          TransactionPostingId = transactionAccountReceivablePostingId
            //      });
            
            //  Console.WriteLine($"        (CAINVOICEFEEARPOSTING) {invoiceFeePostingId}");

             await enerGovSqlManager.ExecuteScalarAsync(
                 @"UPDATE CACOMPUTEDFEE SET CASTATUSID = 6 WHERE CACOMPUTEDFEEID = @ComputedFeeId",
                 new {
                     ComputedFeeId = feeToProcess.ComputedFeeId
                 });
            

         }

     }

    await enerGovSqlManager.CommitAsync();

    Console.WriteLine($"Owners = {ownerAddressLookup.Count()}");
    Console.WriteLine($"Total Fees = {feeOwnerLookup.Sum(_ => _.Value.Sum(x => x.FeeAmount))}");

    Console.WriteLine($"Occupancies Missing Owner Contacts = {occupanciesMissingOwnerContacts}");

    Console.WriteLine($"Invoice Numbers = {invoiceNumbers.Min(_ => _)} .. {invoiceNumbers.Max(_ => _)}");

} catch (Exception e) {
    Console.WriteLine($"Exception: {e.Message}");
    Console.WriteLine(e.StackTrace);
    await enerGovSqlManager.RollbackAsync();
}

