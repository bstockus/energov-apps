#! "netcoreapp2.1"
#r "nuget: System.Data.SqlClient, 4.6.0"
#r "nuget: Dapper, 1.60.6"

#load "classes/EnerGovOccupancyBusiness.csx"
#load "classes/SqlManager.csx"

using System.Data.SqlClient;
using Dapper;

var ENERGOV_SQL_CONNECTION_STRING = "Server=lax-sql1;Database=energovtest;Trusted_Connection=True;";

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
    {"A1","daa7e5ef-a7eb-46f0-9201-f78afb90ee56"},
    {"F1","7c341b13-162a-4372-a225-d681745ab392"},
    {"F2","7c341b13-162a-4372-a225-d681745ab392"},
    {"F3","7c341b13-162a-4372-a225-d681745ab392"},
    {"F4","7c341b13-162a-4372-a225-d681745ab392"},
    {"F5","15ebcc0d-2fb8-45e0-b7f4-4d24a43011bf"},
    {"F6","15ebcc0d-2fb8-45e0-b7f4-4d24a43011bf"},
    {"F7","15ebcc0d-2fb8-45e0-b7f4-4d24a43011bf"},
    {"T1","7c341b13-162a-4372-a225-d681745ab392"},
    {"M1","15ebcc0d-2fb8-45e0-b7f4-4d24a43011bf"},
    {"WU","15ebcc0d-2fb8-45e0-b7f4-4d24a43011bf"},
    {"PR","7c341b13-162a-4372-a225-d681745ab392"},
    {"LC","15ebcc0d-2fb8-45e0-b7f4-4d24a43011bf"},
    {"MD","15ebcc0d-2fb8-45e0-b7f4-4d24a43011bf"}
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

public class ExistingInspection {
    public string InspectionId { get; set; }
    public string InspectionNumber { get; set; }
}

foreach (var primaryZoneToSecondaryZoneMapping in primaryZoneToSecondaryZonesMappings) {

    var primaryZoneUserId = ZONE_TO_INSPECTOR_MAPPINGS[primaryZoneToSecondaryZoneMapping.Key];

    Console.WriteLine($"Zone {primaryZoneToSecondaryZoneMapping.Key}:");
    //'a58cc229-3b42-4a1b-9b68-f26f7f1f6d2e', 
    var existingInspections = (await enerGovSqlConnection.QueryAsync<ExistingInspection>(@"SELECT
            insp.IMINSPECTIONID AS InspectionId,
            insp.INSPECTIONNUMBER AS InspectionNumber
        FROM IMINSPECTION insp
        INNER JOIN IMINSPECTORREF insp_ref ON insp.IMINSPECTIONID = insp_ref.INSPECTIONID
        WHERE insp.IMINSPECTIONTYPEID IN ('8c95785d-0e26-4d40-b2a6-33da0bdf6a56') AND
            insp_ref.USERID = @UserId AND insp_ref.BPRIMARY = 1",
        new {
            UserId = primaryZoneUserId
        })).ToList();
    Console.WriteLine($"  Existing Inspections: {existingInspections.Count()}");

    foreach (var existingInspection in existingInspections) {

        Console.WriteLine($"  Assigning Inspection {existingInspection.InspectionNumber}:");

        foreach (var secondaryZone in primaryZoneToSecondaryZoneMapping.Value) {
            
            var userId = ZONE_TO_INSPECTOR_MAPPINGS[secondaryZone];

            Console.WriteLine($"    to Zone {secondaryZone} (Inspector {userId})");

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
                    InspectionId = existingInspection.InspectionId,
                    UserId = userId,
                    InspectorRefId = Guid.NewGuid().ToString()
                }
            );

        }

    }

}

