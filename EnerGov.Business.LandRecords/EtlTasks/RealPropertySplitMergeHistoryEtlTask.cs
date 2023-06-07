using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class RealPropertySplitMergeHistoryEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.RealPropertySplitMergeHistory;
        public override IEnumerable<string> TableDependencies => new List<string> {
            LandRecordTableNames.RealProperties,
            LandRecordTableNames.ChangeIndicatorCodes
        };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("PropertySplitMergeHistoryCrossRef")
                .Column("OldPropertyInternalId", "OriginalPropertyInternalID")
                .Column("PropertyInternalId", "NewPropertyInternalID")
                .Column("PropertyTransDate", "PropertyTransferDate")
                .Column("PropertyChangedIndicator", "ChangeIndicatorCode")
                .Build();

    }

}