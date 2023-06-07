using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class ZoneCodesEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.ZoneCodes;
        public override IEnumerable<string> TableDependencies => new List<string> {
            LandRecordTableNames.ZoneCodeTypes
        };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("GeneralCodeMaster")
                .Column("GeneralCode", "Code")
                .Column("GeneralCodeType", "CodeType")
                .Column("LocalMunicipalityCode")
                .Column("GeneralCodeDescrition", "Description")
                .Column("ActiveRecord", "IsActive")
                .Build();


    }

}