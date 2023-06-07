#r "nuget: System.Data.SqlClient, 4.6.0"
#r "nuget: Dapper, 1.60.6"

#load "classes/EnerGovOccupancyBusiness.csx"
#load "classes/SqlManager.csx"

using System.Data.SqlClient;
using Dapper;

var INSPECTION_STATUS_CANCELLED = "cf6745d4-02bd-4c22-a520-ceae4e1e0571";
var INSPETION_STATUS_NOT_PREFORMED = "ebae609f-550d-4656-85e6-88e5d9e51e14";
var INSPECTION_STATUS_REQUESTED_AUTO_CREATED = "4b12378a-01db-4279-af9a-d4b5ec1aef61";
var INSPECTION_STATUS_SCHEDULED = "9daf0666-1420-4a9c-af19-8b9ebce45769";

var zonesToGenerate = new [] { 
    "1A","1B","1C","1D","1E","1F","1G","1H","1I",
    "2A","2B","2C","2D","2E","2F",
    "3A","3B","3C","3D","3E","3F",
    "4A","4B","4C",
    "F1","F2","F3","F4","F5","F6","F7",
    "A1",
    "T1",
    "M1",
    "WU",
    "PR",
    "LC",
    "MD" 
};
var typesToGenerate = new [] { "SA"/*, "A"*/ };

var typesToMoveInspectionDateForward = new string[] { "A" };

var requestedDate = new DateTime(2022, 07, 01);

var ENERGOV_SQL_CONNECTION_STRING = "Server=lax-sql1\\ENERGOV;Database=energov_prod;Trusted_Connection=True;";

var ZONE_TO_BLEXTBUSINESSTYPE_MAPPINGS = new Dictionary<string, string> {
    {"1A","30cc8899-e0e2-4627-97be-d2524cc671d9"},
    {"1B","408cdf8a-8ad6-4e72-93cc-a93fe4207690"},
    {"1C","3a8732ab-d9c2-4d95-b11d-63fe660ef12b"},
    {"1D","e81e9e57-7aac-4736-9bb6-6a1671114ed3"},
    {"1E","3e38bc7c-63aa-478c-bd20-a589366ff4cf"},
    {"1F","92eb6104-0355-43dd-aa12-73ad4ad6b7f4"},
    {"1G","fee697bf-015e-4497-8a9c-3ffd8a191037"},
    {"1H","cf87443d-7587-43c6-8705-377b194db482"},
    {"1I","7b5e2335-dcd6-4fe9-8c27-19eaa18a83f3"},
    {"2A","41b30376-9afe-43a3-a9d2-f0539c56b2c6"},
    {"2B","0746e9f7-f702-4518-8423-aeaaa562a5f8"},
    {"2C","b8a9b64e-2fbd-47b4-81a1-8259720aee70"},
    {"2D","f5074e76-4e25-4f76-90d4-75d2e780a720"},
    {"2E","39189982-a103-4fa4-bea7-7a216997b054"},
    {"2F","653ae849-295e-4503-8564-a5bf5881b867"},
    {"3A","4f0d0fc7-4d21-48dc-b535-a4de21ab5d7e"},
    {"3B","99dd6e99-7804-4b47-af9a-45e0f6bd8c5d"},
    {"3C","0c4428d8-afca-4e78-ad5d-111001a8a857"},
    {"3D","47775c14-990a-4a1d-b080-41918c95f0d3"},
    {"3E","23b678a5-e585-4abb-9937-a9f215fa08fb"},
    {"3F","a29aac79-d7d7-4d61-a082-a7aad331c430"},
    {"4A","8422a84d-1126-48ab-92d7-05912c729689"},
    {"4B","e8c80f6f-8de1-4dd5-92c8-a8ec00b6c5db"},
    {"4C","a7bb4986-2629-4982-8acb-9818df41013a"},
    {"F1","113aae72-32f6-435a-ae33-296b788db851"},
    {"F2","16961407-31c6-4f4f-be3d-b4200d21f38e"},
    {"F3","2e611341-794f-41f0-a830-ff714db2a2db"},
    {"F4","9dca7aa0-14c3-457a-b930-3a1cabd3396e"},
    {"F5","86e9f8e0-466b-45b8-a1b5-f70e6fbaba72"},
    {"F6","ab8bb1ec-6e0d-4e41-b03b-4cdde7b0fddf"},
    {"F7","5a376fbd-9b4a-43d7-b107-ee5e9e64359c"},
    {"A1","c7efe372-6297-4c54-9093-beccb8546f72"},
    {"T1","22976bb4-c78b-4255-b35f-3e4eeafe769f"},
    {"M1","6480d091-db37-411e-8bf3-c891b9d81a9f"},
    {"WU","7cb09d9f-6811-43af-bc0e-7386e510b0d5"},
    {"PR","c16399f3-6ab3-4089-993c-090e9e3d2a25"},
    {"LC","ef4db7a8-0951-4d15-8038-7f978f98ef88"},
    {"MD","f8c1ddbf-e669-41f4-bbda-02042226ff51"}
};

var ZONE_TO_INSPECTEDBY_MAPPINGS = new Dictionary<string, string> {
    {"1A",""},
    {"1B",""},
    {"1C",""},
    {"1D",""},
    {"1E",""},
    {"1F",""},
    {"1G",""},
    {"1H",""},
    {"1I",""},
    {"2A",""},
    {"2B",""},
    {"2C",""},
    {"2D",""},
    {"2E",""},
    {"2F",""},
    {"3A",""},
    {"3B",""},
    {"3C",""},
    {"3D",""},
    {"3E",""},
    {"3F",""},
    {"4A",""},
    {"4B",""},
    {"4C",""},
    {"F1",""},
    {"F2",""},
    {"F3",""},
    {"F4",""},
    {"F5",""},
    {"F6",""},
    {"F7",""},
    {"A1",""},
    {"T1",""},
    {"M1",""},
    {"WU",""},
    {"PR",""},
    {"LC",""},
    {"MD",""}
};

var TYPE_TO_BLEXTBUSINESSTYPE_MAPPINGS = new Dictionary<string, string> {
    {"SA", "51c6f328-6366-4a00-99eb-81ef56a2538d"},
    {"A", "53809aa8-4575-477b-8bfc-5906283e615f"}
};

var TYPE_TO_IMINSPECTIONTYPE_MAPPINGS = new Dictionary<string, string> {
    {"SA", "a58cc229-3b42-4a1b-9b68-f26f7f1f6d2e"},
    {"A", "8c95785d-0e26-4d40-b2a6-33da0bdf6a56"}
};

var ZONE_TO_INSPECTOR_MAPPINGS = new Dictionary<string, string> {
    {"1A","289bcd17-3008-4b14-bce5-1b99163ac38e"},
    {"1B","a9debc27-1625-4913-b4e8-b82181a1f168"},
    {"1C","a19c8305-9e5f-48b8-b67a-f30175eaf8a1"},
    {"1D","b8755b38-eb47-49c5-aec6-aea580aa79bc"},
    {"1E","e7953e9a-c3cf-48d8-a6bb-0b74ed352bf9"},
    {"1F","1375ea19-736a-4c24-8744-fd72eb3cfac4"},
    {"1G","e7449623-ab0b-4fcc-89e9-55077feeeeb5"},
    {"1H","57301525-119e-4047-a9b9-1cc240d0e910"},
    {"1I","8e152f2b-6530-48b6-a2d3-aaa0d6d64666"},
    {"2A","b03119b6-3a69-469a-8b33-7d20281a7582"},
    {"2B","ba5e5cea-c664-42f5-b3e6-6582d15b2402"},
    {"2C","57641e74-399e-41d3-953d-435b9ceecbca"},
    {"2D","40cfce3d-3be5-419d-a678-40d033db1ef0"},
    {"2E","54803dc0-ff1b-4413-a523-3289d04bbde5"},
    {"2F","b8170ba1-cdbc-4f2b-8b58-f66016936641"},
    {"3A","8f9bf92c-4fb2-4a62-a4c8-0e6c3418abfc"},
    {"3B","8769e038-5518-4a94-9e06-5b4c9df99c6b"},
    {"3C","6524bd86-2367-47a1-8236-ed262a487c41"},
    {"3D","3f650357-5d8d-424b-ba5a-c6bf0d64bce1"},
    {"3E","98b0aed3-9943-415e-85c9-af6a58a27611"},
    {"3F","0f37bb8b-b923-40c7-83ec-300211fb238f"},
    {"4A","21d3e4bb-54d7-4e0d-98fe-e08ae5d0376a"},
    {"4B","6b7944d1-7c0d-4348-8aa9-b8b48f165c17"},
    {"4C","a974988c-0e9e-4c15-9ec4-5caf508e4300"},
    {"A1","984791d2-8aa0-4e4f-b922-4629e52994e0"},
    {"F1","7c341b13-162a-4372-a225-d681745ab392"},
    {"F2","7c341b13-162a-4372-a225-d681745ab392"},
    {"F3","7c341b13-162a-4372-a225-d681745ab392"},
    {"F4","7c341b13-162a-4372-a225-d681745ab392"},
    {"F5","984791d2-8aa0-4e4f-b922-4629e52994e0"},
    {"F6","984791d2-8aa0-4e4f-b922-4629e52994e0"},
    {"F7","984791d2-8aa0-4e4f-b922-4629e52994e0"},
    {"T1","7c341b13-162a-4372-a225-d681745ab392"},
    {"M1","984791d2-8aa0-4e4f-b922-4629e52994e0"},
    {"WU","984791d2-8aa0-4e4f-b922-4629e52994e0"},
    {"PR","7c341b13-162a-4372-a225-d681745ab392"},
    {"LC","984791d2-8aa0-4e4f-b922-4629e52994e0"},
    {"MD","984791d2-8aa0-4e4f-b922-4629e52994e0"}
};

var primaryZoneToSecondaryZonesMappings = new Dictionary<string, string[]> {
    {"1A", new [] {"1D", "1G"}},
    {"1D", new [] {"1A", "1G"}},
    {"1G", new [] {"1A", "1D"}},

    {"1B", new [] {"1E", "1H"}},
    {"1E", new [] {"1B", "1H"}},
    {"1H", new [] {"1B", "1E"}},

    {"1C", new [] {"1F", "1I"}},
    {"1F", new [] {"1C", "1I"}},
    {"1I", new [] {"1C", "1F"}},

    {"2A", new [] {"2D"}},
    {"2D", new [] {"2A"}},

    {"2B", new [] {"2E"}},
    {"2E", new [] {"2B"}},

    {"2C", new [] {"2F"}},
    {"2F", new [] {"2C"}},

    {"3A", new [] {"3D"}},
    {"3D", new [] {"3A"}},

    {"3B", new [] {"3E"}},
    {"3E", new [] {"3B"}},

    {"3C", new [] {"3F"}},
    {"3F", new [] {"3C"}}
};

var ZONEID_TO_INSPECTORID_MAP = ZONE_TO_BLEXTBUSINESSTYPE_MAPPINGS.Select(_ => (ZoneId: _.Value, InspectorId: ZONE_TO_INSPECTOR_MAPPINGS[_.Key])).ToDictionary(_ => _.ZoneId, _ => _.InspectorId);
var ZONEID_TO_INSPECTEDBY_MAP = ZONE_TO_BLEXTBUSINESSTYPE_MAPPINGS.Select(_ => (ZoneId: _.Value, InspectedBy: ZONE_TO_INSPECTEDBY_MAPPINGS[_.Key])).ToDictionary(_ => _.ZoneId, _ => _.InspectedBy);

var ZONEID_TO_ZONENAME_MAP = ZONE_TO_BLEXTBUSINESSTYPE_MAPPINGS.Select(_ => (ZoneId: _.Value, ZoneName: _.Key)).ToDictionary(_ => _.ZoneId, _ => _.ZoneName);

var BUSINESSTYPEIDS_TO_INSPECTIONTYPEID_MAP = TYPE_TO_BLEXTBUSINESSTYPE_MAPPINGS.Select(_ => (BusinessTypeId: _.Value, InspectionTypeId: TYPE_TO_IMINSPECTIONTYPE_MAPPINGS[_.Key])).ToDictionary(_ => _.BusinessTypeId, _ => _.InspectionTypeId);

var businessZoneIdsToGenerate = zonesToGenerate.Select(_ => ZONE_TO_BLEXTBUSINESSTYPE_MAPPINGS[_]).ToList();
var businessTypeIdsToGenerate = typesToGenerate.Select(_ => TYPE_TO_BLEXTBUSINESSTYPE_MAPPINGS[_]).ToList();
var businessTypeIdsToMoveInspectionDateForward = typesToMoveInspectionDateForward.Select(_ => TYPE_TO_BLEXTBUSINESSTYPE_MAPPINGS[_]).ToList();

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

var occupancyBusinesses = await enerGovSqlConnection.QueryAsync<EnerGovOccupancyBusiness>(@"SELECT
        geext.BLGLOBALENTITYEXTENSIONID,
        geext.DBA,
        geext.REGISTRATIONID,
        geext.STATETAXNUMBER,
        gect_zone.BLEXTBUSINESSTYPEID AS ZoneId,
        gect_type.BLEXTBUSINESSTYPEID AS TypeId
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
    WHERE geext.BLEXTCOMPANYTYPEID = 'aa449424-7b5c-4197-a715-6ddba9c6af18' AND geext.BLEXTSTATUSID = '3d99f589-e6a1-48d1-9015-3f6973034da2'");

var occupancyBusinessesToCreateInspections = occupancyBusinesses.Where(_ => businessZoneIdsToGenerate.Contains(_.ZoneId ?? "") && businessTypeIdsToGenerate.Contains(_.TypeId ?? "")).ToList();

Console.WriteLine($"Businesses to Add Inspections To: {occupancyBusinessesToCreateInspections.Count()}");

var occupancyParcels = (await enerGovSqlConnection.QueryAsync<EnerGovOccupancyBusinessParcel>(@"SELECT
        geext.BLGLOBALENTITYEXTENSIONID,
        gepar.PARCELID,
        gepar.MAIN
    FROM BLGLOBALENTITYEXTENSION geext
    INNER JOIN BLGLOBALENTITYEXTENSIONPARCEL gepar ON geext.BLGLOBALENTITYEXTENSIONID = gepar.BLGLOBALENTITYEXTENSIONID
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
        gecont.GLOBALENTITYID
    FROM BLGLOBALENTITYEXTENSION geext
    INNER JOIN BLGLOBALENTITYEXTENSIONCONTACT gecont ON geext.BLGLOBALENTITYEXTENSIONID = gecont.BLGLOBALENTITYEXTENSIONID
    WHERE geext.BLEXTCOMPANYTYPEID = 'aa449424-7b5c-4197-a715-6ddba9c6af18' AND geext.BLEXTSTATUSID = '3d99f589-e6a1-48d1-9015-3f6973034da2'")).ToLookup(_ => _.BLGLOBALENTITYEXTENSIONID);
Console.WriteLine($"Count of Occupancy Contacts: {occupancyContacts.Sum(_ => _.Count())}");

var existingInspections = (await enerGovSqlConnection.QueryAsync<EnerGovOccupancyBusinessInspection>(@"SELECT
        insp.LINKID AS BusinessId,
        insp.IMINSPECTIONID AS InspectionId,
        insp.INSPECTIONNUMBER AS InspectionNumber,
        insp.INSPECTIONORDER AS InspectionOrder,
        insp.PARENTINSPECTIONNUMBER AS ParentInspectionNumber,
        insp.IMINSPECTIONSTATUSID AS InspectionStatusId,
        insp.IMINSPECTIONTYPEID AS InspectionTypeId,
        insp_stat.STATUSNAME AS InspectionStatus,
        insp.REQUESTEDDATE AS RequestedDate,
        insp.SCHEDULEDENDDATE AS ScheduledDate,
        insp.ACTUALSTARTDATE AS ActualStartDate,
        insp_nc.IMINSPECTIONNONCOMPLYCODEID AS NonComplianceId,
        insp_nc.IMNONCOMPLIANCECODEID AS CodeId,
        insp_nc.IMNONCOMPLIANCECODEREVISIONID AS CodeRevisionId,
        insp_nc.IMNONCOMPLIANCERESPPARTYID AS ResPartyId,
        insp_nc.IMNONCOMPLIANCERISKID AS RiskId,
        insp_nc.CODEDESCRIPTION AS CodeDescription,
        insp_nc.CODENUMBER AS CodeNumber,
        insp_nc.COMMENTS AS Comments,
        insp_nc.DEADLINEDATE AS DeadlineDate,
        insp_nc.RESOLVEDDATE AS ResolvedDate,
        insp.CREATEDATE AS CreatedDate
    FROM IMINSPECTION insp
    LEFT OUTER JOIN IMINSPECTIONNONCOMPLYCODE insp_nc ON insp.IMINSPECTIONID = insp_nc.IMINSPECTIONID
    INNER JOIN IMINSPECTIONSTATUS insp_stat ON insp.IMINSPECTIONSTATUSID = insp_stat.IMINSPECTIONSTATUSID
    WHERE insp.IMINSPECTIONTYPEID IN ('a58cc229-3b42-4a1b-9b68-f26f7f1f6d2e', '8c95785d-0e26-4d40-b2a6-33da0bdf6a56')")).ToLookup(_ => _.BusinessId);
Console.WriteLine($"Existing Inspections: {existingInspections.Count()}");

foreach (var business in occupancyBusinessesToCreateInspections.OrderBy(_ => _.BLGLOBALENTITYEXTENSIONID)) {

    var parcels = occupancyParcels[business.BLGLOBALENTITYEXTENSIONID];
    var addresses = occupancyAddresses[business.BLGLOBALENTITYEXTENSIONID];
    var contacts = occupancyContacts[business.BLGLOBALENTITYEXTENSIONID];
    var inspections = existingInspections.Contains(business.BLGLOBALENTITYEXTENSIONID) ? existingInspections[business.BLGLOBALENTITYEXTENSIONID].ToArray() : new EnerGovOccupancyBusinessInspection[] {};
    
    var groupedInspections = inspections.GroupBy(_ => _.InspectionId);

    var inspectionId = Guid.NewGuid().ToString();

    Console.WriteLine($"Processing Business {business.STATETAXNUMBER} -> {business.DBA}:");

    var lastInspection = groupedInspections.OrderByDescending(_ => _.First().InspectionDate).FirstOrDefault();

    var nonCompliancesToAddToInspection = new List<EnerGovOccupancyBusinessInspection>();

    if (businessTypeIdsToMoveInspectionDateForward.Contains(business.TypeId)) {
        
        var inspectionTypeId = BUSINESSTYPEIDS_TO_INSPECTIONTYPEID_MAP[business.TypeId];

        var mostRecentInspection = inspections.Where(_ => _.InspectionTypeId.Equals(inspectionTypeId)).OrderByDescending(_ => _.RequestedDate).FirstOrDefault();

        if (mostRecentInspection != null && 
            mostRecentInspection.InspectionStatusId.Equals(INSPECTION_STATUS_REQUESTED_AUTO_CREATED)) {

            Console.WriteLine("      **** Last Inspection is Requested and this occupancy is a Move Forward Type, this inspection will be rescheduled. ****");

            await enerGovSqlManager.ExecuteScalarAsync(@"UPDATE IMINSPECTION
                    SET REQUESTEDDATE = @RequestedDate,
                        SCHEDULEDSTARTDATE = @RequestedDate,
                        SCHEDULEDENDDATE = @RequestedDate
                    WHERE IMINSPECTIONID = @InspectionId",
                    new {
                        InspectionId = mostRecentInspection.InspectionId,
                        RequestedDate = requestedDate
                    });

        } else {
            Console.WriteLine("      **** This is a Move Forward Type inspection that has already been completed, no new inspection will be created. ****");
        }
        
        continue;

    }

    if (lastInspection != null) {
        Console.WriteLine($"  Last Inspection {lastInspection.First().InspectionNumber} [{(lastInspection.First().ActualStartDate ?? lastInspection.First().ScheduledDate ?? lastInspection.First().RequestedDate ?? DateTime.MinValue).ToShortDateString()}] => {lastInspection.First().InspectionStatus}:");

        if (lastInspection.First().InspectionStatusId.Equals(INSPECTION_STATUS_SCHEDULED) || lastInspection.First().InspectionStatusId.Equals(INSPECTION_STATUS_REQUESTED_AUTO_CREATED)) {
            Console.WriteLine($"      **** Last Inspection is Scheduled or Requested, this instance will be cancelled. ****");

            await enerGovSqlManager.ExecuteScalarAsync(@"UPDATE IMINSPECTION
                SET IMINSPECTIONSTATUSID = 'ebae609f-550d-4656-85e6-88e5d9e51e14'
                WHERE IMINSPECTIONID = @InspectionId",
                new {
                    InspectionId = lastInspection.First().InspectionId
                });
        }

        if (!string.IsNullOrEmpty(lastInspection.First().NonComplianceId)) {
            foreach (var nonCompliance in lastInspection) {
                Console.Write($"    Non-Compliance {nonCompliance.CodeNumber}: {nonCompliance.DeadlineDate.ToShortDateString()}");
                if (nonCompliance.ResolvedDate.HasValue) {
                    Console.Write($" [Resolved: {nonCompliance.ResolvedDate.Value.ToShortDateString()}]");
                } else {
                    nonCompliancesToAddToInspection.Add(nonCompliance);
                }
                Console.WriteLine();
            }
        }
    }

    if (nonCompliancesToAddToInspection.Any()) {
        Console.WriteLine("      **** Inspection will have non-compliances added ****");
    }

    
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
             '4b12378a-01db-4279-af9a-d4b5ec1aef61',
             @InspectionTypeId,
             @InspectionNumber,
             GETDATE(),
             @RequestedDate,
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
             @RequestedDate,
             @RequestedDate
             )", new {
                 InspectionId = inspectionId,
                 InspectionTypeId = BUSINESSTYPEIDS_TO_INSPECTIONTYPEID_MAP[business.TypeId],
                 InspectionNumber = inspectionNumber.Substring(1),
                 RequestedDate = requestedDate,
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

    Console.WriteLine($"    [INSPECTOR] Primary {ZONEID_TO_INSPECTORID_MAP[business.ZoneId]}");
    
    await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO IMINSPECTORREF
             (INSPECTIONID, USERID, BPRIMARY, IMINSPECTORREFID) 
         VALUES
             (
                 @InspectionId,
                 @UserId,
                 1,
                 @InspectorRefId
             )", new {
                 InspectionId = inspectionId,
                 UserId = ZONEID_TO_INSPECTORID_MAP[business.ZoneId],
                 //UserId = BRYAN_TEST_USERID,
                 InspectorRefId = Guid.NewGuid().ToString()
             });
    
    if (primaryZoneToSecondaryZonesMappings.ContainsKey(ZONEID_TO_ZONENAME_MAP[business.ZoneId])) {
        foreach (var secondaryZone in primaryZoneToSecondaryZonesMappings[ZONEID_TO_ZONENAME_MAP[business.ZoneId]]) {
            
            var userId = ZONE_TO_INSPECTOR_MAPPINGS[secondaryZone];

            Console.WriteLine($"    [INSPECTOR] Secondary {userId}");

            await enerGovSqlManager.ExecuteScalarAsync(
                @"INSERT INTO IMINSPECTORREF
                (INSPECTIONID, USERID, BPRIMARY, IMINSPECTORREFID) 
                VALUES (
                        @InspectionId,
                        @UserId,
                        0,
                        @InspectorRefId
                )",
                new {
                    InspectionId = inspectionId,
                    UserId = userId,
                    InspectorRefId = Guid.NewGuid().ToString()
                }
            );

        }
    }

    
    
    await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO CUSTOMSAVERINSPECTIONS (ID) VALUES (@InspectionId)", 
         new {
             InspectionId = inspectionId
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

    var isFirstContact = true;

    foreach (var contact in contacts) {
        Console.WriteLine($"    [CONTACT] {contact.GLOBALENTITYID}");

        await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO IMINSPECTIONCONTACT
                (IMINSPECTIONCONTACTID, IMINSPECTIONID, GLOBALENTITYID, CONTACTTYPEID, ISBILLING)
            VALUES
                (
                    @InspectionContactId,
                    @InspectionId,
                    @GlobalEntityId,
                    'e87c4fa4-dc69-40b3-802f-9e6eba3e1808',
                    @IsBilling
                )", new {
                    InspectionContactId= Guid.NewGuid().ToString(),
                    InspectionId = inspectionId,
                    GlobalEntityId = contact.GLOBALENTITYID,
                    IsBilling = isFirstContact
                });
    
        isFirstContact = false;
    }

    foreach (var nonComplianceToAdd in nonCompliancesToAddToInspection) {
        Console.WriteLine($"    [NON-COMPLY] {nonComplianceToAdd.NonComplianceId}");

        await enerGovSqlManager.ExecuteScalarAsync(@"INSERT INTO IMINSPECTIONNONCOMPLYCODE
                            (IMINSPECTIONNONCOMPLYCODEID, IMINSPECTIONID, IMNONCOMPLIANCECODEID, IMNONCOMPLIANCECODEREVISIONID, 
                             IMNONCOMPLIANCERISKID, IMNONCOMPLIANCERESPPARTYID, CODENUMBER, CODEDESCRIPTION, 
                             COMMENTS, DEADLINEDATE, RESOLVEDDATE) 
                        SELECT TOP 1
                            @NewNonComplianceCodeId,
                            @ReInspectionId,
                            innc.IMNONCOMPLIANCECODEID,
                            innc.IMNONCOMPLIANCECODEREVISIONID,
                            innc.IMNONCOMPLIANCERISKID,
                            innc.IMNONCOMPLIANCERESPPARTYID,
                            innc.CODENUMBER,
                            innc.CODEDESCRIPTION,
                            innc.COMMENTS,
                            innc.DEADLINEDATE,
                            innc.RESOLVEDDATE
                        FROM IMINSPECTIONNONCOMPLYCODE innc
                        WHERE innc.IMINSPECTIONNONCOMPLYCODEID = @NonComplianceCodeId",
                    new {
                        NewNonComplianceCodeId = Guid.NewGuid().ToString(),
                        ReInspectionId = inspectionId,
                        NonComplianceCodeId = nonComplianceToAdd.NonComplianceId
                    });
    }

}