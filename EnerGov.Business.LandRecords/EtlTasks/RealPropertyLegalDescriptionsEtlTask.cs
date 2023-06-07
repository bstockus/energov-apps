using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class RealPropertyLegalDescriptionsEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.RealPropertyLegalDescriptions;
        public override IEnumerable<string> TableDependencies => new List<string> {
            LandRecordTableNames.RealProperties
        };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("RealPropertyLegalDescription")
                .Column("PropertyInternalID")
                .Column("LegalDescription")
                .Build();

    }

}