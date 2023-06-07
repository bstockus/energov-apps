#r "nuget: System.Data.SqlClient, 4.6.0"
#r "nuget: Dapper, 1.60.6"

using System.Data.SqlClient;
using Dapper;

public class FeeInformation {
    public string FeeSetupId { get; set; }
    public string FeeId { get; set; }
    public string FeeName { get; set; }
}

var FEE_SCHEDULE_CURR_ID = "03592b31-93a2-66b5-f924-a7c67194734b";
var FEE_SCHEDULE_NEXT_ID = "828ddb03-2184-2086-b42c-3e198d5d2e23";

var ENERGOV_SQL_CONNECTION_STRING = "Server=lax-sql1\\ENERGOV;Database=energov_train;Trusted_Connection=True;";

var enerGovSqlConnection = new SqlConnection(ENERGOV_SQL_CONNECTION_STRING);
await enerGovSqlConnection.OpenAsync();

var currentFeeSetupInformations = await enerGovSqlConnection.QueryAsync<FeeInformation>(@"
    SELECT
        cafs.CAFEESETUPID AS FeeSetupId,
        caf.CAFEEID AS FeeId,
        caf.NAME AS FeeName
    FROM CAFEESETUP cafs
    INNER JOIN CAFEE caf ON cafs.CAFEEID = caf.CAFEEID
    WHERE cafs.CASCHEDULEID = @FeeScheduleId",
    new {
        FeeScheduleId = FEE_SCHEDULE_CURR_ID
    });

Console.WriteLine($"Current Fee Setups = {currentFeeSetupInformations.Count()}");

var nextFeeSetupInformations = await enerGovSqlConnection.QueryAsync<FeeInformation>(@"
    SELECT
        cafs.CAFEESETUPID AS FeeSetupId,
        caf.CAFEEID AS FeeId,
        caf.NAME AS FeeName
    FROM CAFEESETUP cafs
    INNER JOIN CAFEE caf ON cafs.CAFEEID = caf.CAFEEID
    WHERE cafs.CASCHEDULEID = @FeeScheduleId",
    new {
        FeeScheduleId = FEE_SCHEDULE_NEXT_ID
    });

var feesToIgnore = nextFeeSetupInformations.Select(_ => _.FeeId).ToList();

Console.WriteLine($"Next Fee Setups = {nextFeeSetupInformations.Count()}");

foreach (var fee in currentFeeSetupInformations.Where(_ => !feesToIgnore.Contains(_.FeeId))) {

    Console.WriteLine($"Fee {fee.FeeId} (Setup: {fee.FeeSetupId}) Name = {fee.FeeName}");

    var newFeeSetupId = Guid.NewGuid().ToString();

    await enerGovSqlConnection.ExecuteScalarAsync(
        @"
        INSERT INTO CAFEESETUP
            (CAFEESETUPID, CAFEEID, CASCHEDULEID,
            AMOUNT, MINIMUMAMOUNT, MAXIMUMAMOUNT,
            COMPUTATIONVALUE, COMPUTATIONVALUENAME,
            ROUNDINGTYPEID, ROUNDINGVALUE,
            ROWVERSION, LASTCHANGEDBY, LASTCHANGEDON,
            CAPRORATESCHEDULEID, CAPRORATIONMODELID,
            CACPITYPEID, CPIORIGINALFEEDATE,
            CAFEECOMPOUNDINGFREQUENCYTYPEID)
        SELECT
            @NewFeeSetupId,
            cafs.CAFEEID,
            @FeeScheduleId,
            cafs.AMOUNT,
            cafs.MINIMUMAMOUNT,
            cafs.MAXIMUMAMOUNT,
            cafs.COMPUTATIONVALUE,
            cafs.COMPUTATIONVALUENAME,
            cafs.ROUNDINGTYPEID,
            cafs.ROUNDINGVALUE,
            cafs.ROWVERSION,
            cafs.LASTCHANGEDBY,
            cafs.LASTCHANGEDON,
            cafs.CAPRORATESCHEDULEID,
            cafs.CAPRORATIONMODELID,
            cafs.CACPITYPEID,
            cafs.CPIORIGINALFEEDATE,
            cafs.CAFEECOMPOUNDINGFREQUENCYTYPEID
        FROM CAFEESETUP cafs
        WHERE cafs.CAFEESETUPID = @OldFeeSetupId",
        new {
            NewFeeSetupId = newFeeSetupId,
            FeeScheduleId = FEE_SCHEDULE_NEXT_ID,
            OldFeeSetupId = fee.FeeSetupId
        }
    );

    await enerGovSqlConnection.ExecuteScalarAsync(
        @"
        INSERT INTO CAFEEADJUSTABLECALC
            (CAFEEADJUSTABLECALCID, CAFEEID, LOWERLIMIT, UPPERLIMIT, UNLIMITED, AMOUNT, ADDITIONALAMOUNT, ADDITIONALUNIT, [OVER], CAFEESETUPID, PERCENTAGE)
        SELECT
            CONVERT(char(36), NEWID()),
            cafac.CAFEEID,
            cafac.LOWERLIMIT,
            cafac.UPPERLIMIT,
            cafac.UNLIMITED,
            cafac.AMOUNT,
            cafac.ADDITIONALAMOUNT,
            cafac.ADDITIONALUNIT,
            cafac.[OVER],
            @NewFeeSetupId,
            cafac.PERCENTAGE
        FROM CAFEEADJUSTABLECALC cafac
        WHERE cafac.CAFEESETUPID = @OldFeeSetupId
        ",
        new {
            NewFeeSetupId = newFeeSetupId,
            OldFeeSetupId = fee.FeeSetupId
        }
    );

}