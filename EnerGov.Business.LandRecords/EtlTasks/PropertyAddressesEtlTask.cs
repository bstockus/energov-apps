using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class PropertyAddressesEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.PropertyAddresses;
        public override IEnumerable<string> TableDependencies => new List<string> { };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("PropertyAddressMaster")
                .Column("PropertyAddressID")
                .Column("PropertyStreetName")
                .Column("PropertyStreetPrefixDirectional")
                .Column("PropertyStreetType")
                .Column("PropertyStreetSuffixDirectional")
                .Column("PropertyHouseNumber")
                .Column("PropertySecondaryType")
                .Column("PropertySecondaryNumber")
                .Column("PropertyCity")
                .Column("PropertyState")
                .Column("PropertyZipCode")
                .Build();

    }

}