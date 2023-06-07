using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class ZoneCodeTypesEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.ZoneCodeTypes;
        public override IEnumerable<string> TableDependencies => new List<string> { };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("GeneralCodeType")
                .Column("GeneralCodeType", "CodeType")
                .Column("GeneralCodeTypeDescription", "Description")
                .Build();

    }

}