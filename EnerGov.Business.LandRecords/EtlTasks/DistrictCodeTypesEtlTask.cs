using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class DistrictCodeTypesEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.DistrictCodeTypes;
        public override IEnumerable<string> TableDependencies => new List<string>();

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("DistrictTypeMaster")
                .Column("DistrictType", "CodeType")
                .Column("DistrictTypeDescription", "Description")
                .Column("UsageIndicator")
                .Column("IsTaxationIndicator")
                .Column("IncludeInAssessmentProcess")
                .Build();

    }

}