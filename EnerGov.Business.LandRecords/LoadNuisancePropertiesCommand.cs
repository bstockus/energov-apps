using System;
using System.Data.SqlClient;
using System.Threading;
using System.Threading.Tasks;
using EnerGov.Data.EnerGov;
using EnerGov.Data.LandRecords;
using EnerGov.Data.ZollRMS;
using Lax.Data.Sql.SqlServer;
using MediatR;

namespace EnerGov.Business.LandRecords {

    public class LoadNuisancePropertiesCommand : IRequest {

        public class Handler : IRequestHandler<LoadNuisancePropertiesCommand> {

            private readonly ISqlServerConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlServerConnectionProvider;
            private readonly ISqlServerConnectionProvider<LandRecordsSqlServerConnection> _landRecordsSqlServerConnectionProvider;
            private readonly ISqlServerConnectionProvider<ZollRmsSqlServerConnection> _zollRmsSqlServerConnectionProvider;

            public Handler(
                ISqlServerConnectionProvider<EnerGovSqlServerConnection> enerGovSqlServerConnectionProvider,
                ISqlServerConnectionProvider<LandRecordsSqlServerConnection> landRecordsSqlServerConnectionProvider,
                ISqlServerConnectionProvider<ZollRmsSqlServerConnection> zollRmsSqlServerConnectionProvider) {

                _enerGovSqlServerConnectionProvider = enerGovSqlServerConnectionProvider;
                _landRecordsSqlServerConnectionProvider = landRecordsSqlServerConnectionProvider;
                _zollRmsSqlServerConnectionProvider = zollRmsSqlServerConnectionProvider;
            }

            public async Task<Unit> Handle(LoadNuisancePropertiesCommand request, CancellationToken cancellationToken) {

                var enerGovSqlConnection = await _enerGovSqlServerConnectionProvider.GetSqlServerConnectionAsync(cancellationToken);
                var landRecordsSqlConnection = await _landRecordsSqlServerConnectionProvider.GetSqlServerConnectionAsync(cancellationToken);
                var zollRmsSqlConnection = await _zollRmsSqlServerConnectionProvider.GetSqlServerConnectionAsync(cancellationToken);

                await TruncateTable(cancellationToken, landRecordsSqlConnection);
                await LoadDataFromEnerGov(cancellationToken, enerGovSqlConnection, landRecordsSqlConnection);
                await LoadDataFromZollRms(cancellationToken, zollRmsSqlConnection, landRecordsSqlConnection);
                await LoadDataFromPolice(cancellationToken, landRecordsSqlConnection);

                return Unit.Value;

            }

            private async Task LoadDataFromZollRms(CancellationToken cancellationToken, SqlConnection zollRmsSqlConnection,
                SqlConnection landRecordsSqlConnection) {
                var zollRmsSqlCommand = new SqlCommand(@"
                    SELECT
                      CAST('ZollRMS' AS nvarchar(10)) AS 'System',
                      CAST('FP&BS - Fire' AS nvarchar(255)) AS 'Department',
                      CAST(codes.groupcode AS nvarchar(255)) AS 'Category',
                      CAST(codes.description AS nvarchar(255)) AS 'Type',
                      CAST(occupancy.ParcelID AS nvarchar(20)) AS 'Parcel',
                      CAST(activ.recorddate AS datetime) AS 'Date',
                      CAST(occupancy.number AS nvarchar(30)) AS 'CaseNumber',
                      CAST(activ.comments AS nvarchar(MAX)) AS 'Description'
                    FROM [dbo].[occ_activ] activ
                      INNER JOIN [dbo].[occ_bas] occupancy ON activ.occid = occupancy.occid
                      INNER JOIN [dbo].[occ_customize] codes ON activ.findingbycode = codes.code AND codes.record_type = 'F'
                    WHERE
                      activ.type = 'F' AND 
                      NOT activ.description = 'NO VIOL-1-NO VIOLATIONS NOTED' AND 
                      activ.recorddate >= '2016-01-01' AND 
                      occupancy.ParcelID IS NOT NULL",
                    zollRmsSqlConnection);

                using (var zollRmsReader = await zollRmsSqlCommand.ExecuteReaderAsync(cancellationToken)) {
                    using (var zollRmsSqlBulkCopy = new SqlBulkCopy(landRecordsSqlConnection)) {
                        zollRmsSqlBulkCopy.BulkCopyTimeout = 0;
                        zollRmsSqlBulkCopy.DestinationTableName = "[dbo].[NuisanceProperties]";

                        await zollRmsSqlBulkCopy.WriteToServerAsync(zollRmsReader, cancellationToken);
                    }
                }
            }

            private async Task LoadDataFromEnerGov(CancellationToken cancellationToken, SqlConnection enerGovSqlConnection,
                SqlConnection landRecordsSqlConnection) {

                var buildingsCodeCategories = new[] {
                    "93fe5ff3-2372-41ec-9502-2897b8d882f9",
                    "064ad162-fab2-40cc-9e2e-92c009ff0fd0",
                    "c30e9486-70ed-4255-9b9a-b119f05a2a30",
                    "c3b4d7c3-1698-4ea7-b302-46800f1d7cc0",
                    "0c55e5bf-7940-4152-bd3e-de0d40d2c36f",
                    "704f2fb9-2978-4a59-922f-de8b6373c1c5",
                    "60357216-53c0-400f-9660-c0b8792dfb3d",
                    "6ab0e780-7a17-49d5-80c5-188eb98d2ebc"
                };

                var fireCodeCategories = new[] {
                    "978564eb-33ef-410d-a305-8f72380bf407",
                    "cf6038d5-e3fa-4e99-82ae-ec99f8840449",
                    "505daabc-b4d8-414b-857b-ee356306eebe",
                    "a5c01226-395b-4a8f-ad50-5ed1c1a4995e",
                    "b72eec67-794b-4a4c-9209-a05279e11b33",
                    "bcba5c9f-a517-4703-9ce0-29265cbdc99d",
                    "a241bb91-092d-45d2-9597-63f7cd0e6991",
                    "502843cd-951e-4360-9894-b9557d3ef897",
                    "1ca195ac-06b4-4bf7-96ca-4686b8703fb1",
                    "9b2136d2-505d-485c-a921-2688c2df396d",
                    "d566ff0f-ab9a-40c9-bcee-eb5d3269159a",
                    "a10044ec-0fe5-4835-a0db-9ba458fc1658",
                    "8640f5fb-64dc-4c29-b8b0-a102febe9d07",
                    "8a884c66-031d-4efe-84a2-e488245d9251",
                    "7a3c5b17-be00-4e9c-b3b6-713791f7fbb2",
                    "f61f02ae-d9c7-4eed-9cf6-b3cfa8b9eaf8",
                    "43212ac5-be3f-4481-a93b-59502b2e6dc4",
                    "8b11c8e6-f311-4166-b47d-714ae2eaf8b7",
                    "b57bc3ba-d581-4b55-9167-c954b8fbc778",
                    "555540b5-b137-473b-82f5-7b543a2fe0b6",
                    "3d5710a2-af9e-406b-8286-b9f4a85839f6",
                    "c5ea43b7-7b61-49de-af36-e02655603b34",
                    "a1485a21-aeb3-42ec-bb95-bd011d8f3347",
                    "1de50d25-514a-4df9-a069-896c101b668b",
                    "3fdd4b38-2458-4f1e-9f4f-8b7f96d6737b",
                    "3241a7a9-b666-454d-b318-a21dd47ec8e0",
                    "14f4cd92-2f12-4c52-83c4-1ce1e9697131",
                    "9a366ffc-cdee-49b4-809a-3b1da5c0d2b1",
                    "9af8bc66-fcca-4f94-a430-1c566607e4ea",
                    "0c46056b-c017-4491-a5d6-116cb0332f8e",
                    "878157d8-792e-4f31-8126-c2da7b31c576",
                    "5c5ceb94-359c-42a1-9963-bacad105998b",
                    "082bd31f-cf5f-416f-bac1-3ed623f019da",
                    "9549507e-61c9-41f9-89e1-bd6089b0703b",
                    "1d685ea3-659c-4b9b-aab1-3f86d68f081a",
                    "9c82869e-0271-4313-86c2-c74332f822ed",
                    "77daef5f-028f-4947-979d-d1b80942bf5b",
                    "b6ffced3-a910-40f7-a455-c74675619f35",
                    "44d1203f-3ba1-41bb-9bd4-f0652303f1bd",
                    "8b8ca32d-9b97-4eec-baa0-8fa0ad588557",
                    "fc4a63eb-30f2-4521-8db5-2971b87d19a2",
                    "9dcf2778-256c-4707-9641-f2794f0c23fa",
                    "c2813709-a502-44e7-b0ae-9318111e7e47",
                    "f830cd34-f860-48f9-bfa0-76bf508fdc53",
                    "cb2741dd-3377-40ef-a8c6-d89a07529819"
                };

                var parksAndRecCodeCategories = new[] {
                    "b09e2553-7c30-4650-99bb-be51349e7fdf"
                };

                var codeCategoriesToLoadFrom = new[] {
                    "93fe5ff3-2372-41ec-9502-2897b8d882f9",
                    "064ad162-fab2-40cc-9e2e-92c009ff0fd0",
                    "c30e9486-70ed-4255-9b9a-b119f05a2a30",
                    "c3b4d7c3-1698-4ea7-b302-46800f1d7cc0",
                    "0c55e5bf-7940-4152-bd3e-de0d40d2c36f",
                    "704f2fb9-2978-4a59-922f-de8b6373c1c5",
                    "60357216-53c0-400f-9660-c0b8792dfb3d",
                    "6ab0e780-7a17-49d5-80c5-188eb98d2ebc"
                };

                var codesToExclude = new[] {
                    "0a12fa8c-4374-4097-8724-fba310499dce"
                };

                var codesToInclude = new[] {
                    "07b4eb2b-f05d-42ed-9fe0-f4fd3067bb2d"
                };

                var cutOffDate = new DateTime(2016, 1, 1);

                var enerGovSqlCommand = new SqlCommand(
                    @"
                    SELECT
                      CAST(CASE WHEN cc.CASENUMBER LIKE 'CONV-%' THEN 'Munis' ELSE 'EnerGov' END AS nvarchar(10)) AS 'System',
                      CAST(CASE WHEN c.CMCODECATEGORYID IN ({BuildingsCodeCategories}) THEN 'FP&BS - Bldgs.' 
                                WHEN c.CMCODECATEGORYID IN ({FireCodeCategories}) THEN 'FP&BS - Fire.' 
                                WHEN c.CMCODECATEGORYID IN ({ParksAndRecCodeCategories}) THEN 'Parks & Rec.' 
                                ELSE 'Unknown' END AS nvarchar(255)) AS 'Department',
                      CAST(cat.NAME AS nvarchar(255)) AS 'Category',
                      CAST(c.DESCRIPTION AS nvarchar(255)) AS 'Type',
                      CAST(par.PARCELNUMBER AS nvarchar(255)) AS 'Parcel',
                      CAST(cc.OPENEDDATE AS datetime) AS 'Date',
                      CAST(cc.CASENUMBER AS nvarchar(30)) AS 'CaseNumber',
                      CAST(cc.DESCRIPTION AS nvarchar(MAX)) AS 'Description'
                    FROM dbo.CMCODECASE cc
                      INNER JOIN dbo.CMCODEWFSTEP cwfs ON cc.CMCODECASEID = cwfs.CMCODECASEID
                        INNER JOIN dbo.CMCODEWFACTIONSTEP cwfas ON cwfs.CMCODEWFSTEPID = cwfas.CMCODEWFSTEPID
                        INNER JOIN dbo.CMVIOLATION viol ON cwfas.CMCODEWFACTIONSTEPID = viol.CMCODEWFACTIONID
                        INNER JOIN dbo.CMCODEREVISION cr ON viol.CMCODEREVISIONID = cr.CMCODEREVISIONID
                        INNER JOIN dbo.CMCODE c ON cr.CMCODEID = c.CMCODEID
                      INNER JOIN dbo.CMCODECATEGORY cat ON c.CMCODECATEGORYID = cat.CMCODECATEGORYID
                        INNER JOIN dbo.CMCODECASEPARCEL ccp ON cc.CMCODECASEID = ccp.CMCODECASEID AND ccp.[PRIMARY] = 1
                        INNER JOIN dbo.PARCEL par ON ccp.PARCELID = par.PARCELID
                    WHERE
                        ((c.CMCODECATEGORYID IN ({CodeCategoriesToLoadFrom}) AND 
                                c.CMCODEID NOT IN ({CodesToExclude})) OR 
                            c.CMCODEID IN ({CodesToInclude})) AND
                        cc.OPENEDDATE >= @CutOffDate", enerGovSqlConnection);

                enerGovSqlCommand.AddArrayParameters("BuildingsCodeCategories", buildingsCodeCategories);
                enerGovSqlCommand.AddArrayParameters("FireCodeCategories", fireCodeCategories);
                enerGovSqlCommand.AddArrayParameters("ParksAndRecCodeCategories", parksAndRecCodeCategories);

                enerGovSqlCommand.AddArrayParameters("CodeCategoriesToLoadFrom", codeCategoriesToLoadFrom);
                enerGovSqlCommand.AddArrayParameters("CodesToExclude", codesToExclude);
                enerGovSqlCommand.AddArrayParameters("CodesToInclude", codesToInclude);
                enerGovSqlCommand.Parameters.AddWithValue("CutOffDate", cutOffDate);

                using (var enerGovReader = await enerGovSqlCommand.ExecuteReaderAsync(cancellationToken)) {
                    using (var enerGovSqlBulkCopy = new SqlBulkCopy(landRecordsSqlConnection)) {
                        enerGovSqlBulkCopy.BulkCopyTimeout = 0;
                        enerGovSqlBulkCopy.DestinationTableName = "[dbo].[NuisanceProperties]";

                        await enerGovSqlBulkCopy.WriteToServerAsync(enerGovReader, cancellationToken);
                    }
                }
            }

            private async Task LoadDataFromPolice(CancellationToken cancellationToken,
                SqlConnection landRecordsSqlConnection) {



                var policeNuisancesCommand = new SqlCommand(
                    @"
                      INSERT INTO [dbo].[NuisanceProperties] (
                        [System],[Department],[Category],[Type],[Parcel],[Date],[CaseNumber],[Description])
                      SELECT
                        'VISION' AS 'System',
                        'Police' AS 'Department',
                        pn.Category AS 'Category',
                        pn.Type AS 'Type',
                        pn.Parcel AS 'Parcel',
                        pn.Date AS 'Date',
                        pn.CaseNumber AS 'CaseNumber',
                        pn.Description AS 'Description'
                      FROM dbo.PoliceNuisances pn", landRecordsSqlConnection);

                await policeNuisancesCommand.ExecuteNonQueryAsync(cancellationToken);


            }

            private async Task TruncateTable(CancellationToken cancellationToken, SqlConnection landRecordsSqlConnection) {
                var truncateTableCommand = new SqlCommand(@"TRUNCATE TABLE [dbo].[NuisanceProperties]", landRecordsSqlConnection);

                await truncateTableCommand.ExecuteScalarAsync(cancellationToken);
            }

        }

    }

}