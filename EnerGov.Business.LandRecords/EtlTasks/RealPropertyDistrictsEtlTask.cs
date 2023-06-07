using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class RealPropertyDistrictsEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.RealPropertyDistricts;
        public override IEnumerable<string> TableDependencies => new List<string> {
            LandRecordTableNames.DistrictCodes,
            LandRecordTableNames.RealProperties
        };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("PropertyDistrictCrossRef")
                .Column("PropertyInternalID")
                .Column("DistrictType", "DistrictCodeType")
                .Column("DistrictCode")
                .Build();

    }

}