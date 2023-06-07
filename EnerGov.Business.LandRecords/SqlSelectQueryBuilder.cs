using System.Collections.Generic;
using System.Linq;

namespace EnerGov.Business.LandRecords {

    public class SqlSelectQueryBuilder {

        public string TableName { get; }

        public List<SqlSelectQueryBuilderColumnSpecification> ColumnSpecifications { get; } = new();

        public SqlSelectQueryBuilder(string tableName) {
            TableName = tableName;
        }

        public SqlSelectQueryBuilder Column(string columnName, string columnAlias = null) {

            ColumnSpecifications.Add(
                new SqlSelectQueryBuilderColumnSpecification(columnName, columnAlias ?? columnName));

            return this;
        }

        public string Build() {

            var columns = ColumnSpecifications.Select(_ => _.ToSql());

            var columnSql = columns.Skip(1).Aggregate(columns.First(), (accum, value) => $"{accum}, {value}");

            return $"SELECT {columnSql} FROM [dbo].[{TableName}];";

        }

    }

}