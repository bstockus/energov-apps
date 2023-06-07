namespace EnerGov.Business.LandRecords {

    public static class SqlBuilder {

        public static SqlSelectQueryBuilder SelectFrom(string tableName) => new SqlSelectQueryBuilder(tableName);

    }

}