using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class RealPropertyZonesEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.RealPropertyZones;
        public override IEnumerable<string> TableDependencies => new List<string> {
            LandRecordTableNames.RealProperties,
            LandRecordTableNames.ZoneCodes
        };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("PropertyGeneralCodeCrossRef")
                .Column("PropertyInternalID")
                .Column("GeneralCodeType", "ZoneCodeType")
                .Column("GeneralCode", "ZoneCode")
                .Column("LocalMunicipalityCode")
                .Build();

    }

}