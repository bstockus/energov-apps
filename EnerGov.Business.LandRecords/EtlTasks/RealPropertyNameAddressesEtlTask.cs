using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class RealPropertyNameAddressesEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.RealPropertyNameAddresses;
        public override IEnumerable<string> TableDependencies => new List<string> {
            LandRecordTableNames.RealProperties,
            LandRecordTableNames.NameAddresses,
            LandRecordTableNames.NameTypes
        };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("RealPropertyNameAddressCrossRef")
                .Column("PropertyInternalID")
                .Column("NameAddressID")
                .Column("NameTypeCode")
                .Column("IsBillToIndicator")
                .Build();

    }

}