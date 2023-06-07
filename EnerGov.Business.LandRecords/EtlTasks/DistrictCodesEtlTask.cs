using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class DistrictCodesEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.DistrictCodes;
        public override IEnumerable<string> TableDependencies => new List<string> {
            LandRecordTableNames.DistrictCodeTypes
        };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("DistrictCodeMaster")
                .Column("DistrictCode", "Code")
                .Column("DistrictType", "CodeType")
                .Column("DistrictDescription", "Description")
                .Column("ActiveRecord", "IsActive")
                .Build();

    }

}