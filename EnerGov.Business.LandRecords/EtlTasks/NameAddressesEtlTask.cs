using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class NameAddressesEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.NameAddresses;
        public override IEnumerable<string> TableDependencies => new List<string> { };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("NameAddressMaster")
                .Column("LastName")
                .Column("FirstName")
                .Column("StreetName")
                .Column("StreetPrefixDirectional")
                .Column("StreetSuffixDirectional")
                .Column("HouseNumber")
                .Column("StreetSecondaryNumber")
                .Column("City")
                .Column("State")
                .Column("ZipCode")
                .Column("DeliveryPointBarCode")
                .Column("DPBCCheckDigit")
                .Column("CountryCode")
                .Column("StreetType")
                .Column("SecondaryType")
                .Column("NameAddressID")
                .Column("IsBusiness")
                .Build();

    }

}