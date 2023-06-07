using System.Collections.Generic;

namespace EnerGov.Business.LandRecords.EtlTasks {

    public class NameTypesEtlTask : EtlTask {

        public override string TableName => LandRecordTableNames.NameTypes;
        public override IEnumerable<string> TableDependencies => new List<string> { };

        protected override string SqlQuery =>
            SqlBuilder.SelectFrom("NameTypeMaster")
                .Column("NameTypeCode", "TypeCode")
                .Column("NameTypeDescription", "Description")
                .Column("PrintNamePrefix")
                .Column("IsPrintFlag")
                .Column("IsOwner")
                .Build();

    }

}