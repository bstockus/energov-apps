using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class RealPropertyTaxAssessmentsEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.RealPropertyTaxAssessments;
        public override IEnumerable<string> TableDependencies => new List<string> {
            LandRecordTableNames.RealProperties,
            LandRecordTableNames.TaxAssessmentClassCodes
        };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("PropertyTaxAssessments")
                .Column("PropertyInternalID")
                .Column("AssessmentClassCode", "TaxAssessmentClassCode")
                .Column("TaxationYear")
                .Column("Acreage")
                .Column("LandValue")
                .Column("ImprovementValue")
                .Column("AssessmentLineTotals")
                .Build();

    }

}