using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class TaxAssessmentClassCodesEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.TaxAssessmentClassCodes;
        public override IEnumerable<string> TableDependencies => new List<string> { };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("TaxAssessmentClass")
                .Column("AssessmentClassCode", "TaxAssessmentClassCode")
                .Column("TaxAssessmentDescription", "Description")
                .Build();

    }

}