namespace EnerGov.Business.LandRecords {

    public class SqlSelectQueryBuilderColumnSpecification {

        public string ColumnName { get; }
        public string ColumnAlias { get; }

        public SqlSelectQueryBuilderColumnSpecification(string columnName, string columnAlias) {
            ColumnName = columnName;
            ColumnAlias = columnAlias;
        }

        public string ToSql() => $"[{ColumnName}] AS \"{ColumnAlias}\"";

    }

}