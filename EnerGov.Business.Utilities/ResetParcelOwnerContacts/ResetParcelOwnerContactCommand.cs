using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Data.EnerGov;
using Lax.Business.Bus.Logging;
using Lax.Data.Sql.SqlServer;
using MediatR;

namespace EnerGov.Business.Utilities.ResetParcelOwnerContacts {

    [LogRequest]
    public class ResetParcelOwnerContactCommand : IRequest<IEnumerable<ResetParcelOwnerContactCommand.ParcelAffectedInformation>> {

        public string ParcelNumber { get; set; }

        public record ParcelImportInformation(
            string ImportNameKey,
            string ImportAddressKey,
            string ParcelId);

        public record ParcelAffectedInformation(
            string ParcelNumber);

        public class Handler : IRequestHandler<ResetParcelOwnerContactCommand, IEnumerable<ResetParcelOwnerContactCommand.ParcelAffectedInformation>> {

            private readonly ISqlServerConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlServerConnectionProvider;

            public Handler(
                ISqlServerConnectionProvider<EnerGovSqlServerConnection> enerGovSqlServerConnectionProvider) {
                _enerGovSqlServerConnectionProvider = enerGovSqlServerConnectionProvider;
            }

            public async Task<IEnumerable<ResetParcelOwnerContactCommand.ParcelAffectedInformation>> Handle(
                ResetParcelOwnerContactCommand request,
                CancellationToken cancellationToken) {

                var enerGovConnection =
                    await _enerGovSqlServerConnectionProvider.GetSqlServerConnectionAsync(cancellationToken);

                var parcelImportInformation =
                    await enerGovConnection.QueryFirstAsync<ParcelImportInformation>(
                        @"SELECT 
                                    IMPNAMEKEY AS ImportNameKey, 
                                    IMPADDKEY AS ImportAddressKey, 
                                    PARCELID AS ParcelId
                                FROM PARCEL WHERE PARCELNUMBER = @ParcelNumber",
                        new {
                            request.ParcelNumber
                        });

                if (parcelImportInformation == null ||
                    string.IsNullOrWhiteSpace(parcelImportInformation.ImportAddressKey) ||
                    string.IsNullOrWhiteSpace(parcelImportInformation.ImportNameKey)) {
                    return new ParcelAffectedInformation[] {};
                }

                var parcelsAffected = await enerGovConnection.QueryAsync<ParcelAffectedInformation>(
                    @"SELECT
                                PARCELNUMBER AS ParcelNumber
                            FROM PARCEL
                            WHERE LTRIM(RTRIM(IMPNAMEKEY)) = LTRIM(RTRIM(@ImportNameKey)) AND 
                                  LTRIM(RTRIM(IMPADDKEY)) = LTRIM(RTRIM(@ImportAddressKey))",
                    new {
                        parcelImportInformation.ImportNameKey,
                        parcelImportInformation.ImportAddressKey
                    });

                await enerGovConnection.QueryAsync(
                    @"UPDATE PARCEL
                            SET 
                                IMPADDKEY = NULL,
                                IMPNAMEKEY = NULL
                            WHERE PARCELID = @ParcelId",
                    new {
                        parcelImportInformation.ParcelId
                    });

                await enerGovConnection.QueryAsync(
                    @"UPDATE GLOBALENTITY
                            SET
                                IMPADDKEY = NULL,
                                IMPNAMEKEY = NULL
                            WHERE LTRIM(RTRIM(IMPNAMEKEY)) = LTRIM(RTRIM(@ImportNameKey)) AND 
                                  LTRIM(RTRIM(IMPADDKEY)) = LTRIM(RTRIM(@ImportAddressKey))",
                    new {
                        parcelImportInformation.ImportNameKey,
                        parcelImportInformation.ImportAddressKey
                    });


                return parcelsAffected;

            }

        }

    }

}
