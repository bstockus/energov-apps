using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class RealPropertyAddressesEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.RealPropertyAddresses;
        public override IEnumerable<string> TableDependencies => new List<string> {
            LandRecordTableNames.RealProperties,
            LandRecordTableNames.PropertyAddresses
        };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("RealPropertyAddressCrossRef")
                .Column("PropertyInternalID")
                .Column("PropertyAddressID")
                .Build();

    }

}