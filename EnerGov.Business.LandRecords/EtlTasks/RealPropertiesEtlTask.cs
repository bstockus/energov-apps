using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class RealPropertiesEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.RealProperties;
        public override IEnumerable<string> TableDependencies => new List<string> { };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("RealPropertyMaster")
                .Column("PropertyInternalID")
                .Column("LocalMunicipalityCode")
                .Column("MiddleParcelNumber")
                .Column("RightParcelNumber")
                .Column("Section")
                .Column("Township")
                .Column("Range")
                .Column("QuarterQuarter")
                .Column("PinParcelIdentifier")
                .Column("TotalAcreage")
                .Column("PropertyChangedIndicator")
                .Column("PropertyTaxableCurrentYear")
                .Column("IsHistory")
                .Column("InitialTaxYear")
                .Column("FinalTaxYear")
                .Build();


    }

}