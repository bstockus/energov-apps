using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class ChangeIndicatorCodesEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.ChangeIndicatorCodes;
        public override IEnumerable<string> TableDependencies => new List<string> { };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("RealEstateChangeIndicatorCodes")
                .Column("ChangeIndicatorCode")
                .Column("ChangeIndicator")
                .Build();

    }

}