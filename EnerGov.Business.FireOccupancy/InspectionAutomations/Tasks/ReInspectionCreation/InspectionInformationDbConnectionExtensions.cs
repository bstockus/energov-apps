using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Threading;
using System.Threading.Tasks;
using Dapper;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Tasks.ReInspectionCreation {

    public static class InspectionInformationDbConnectionExtensions {

        public static async Task<InspectionInformation> GetInspectionInformation(
            this DbConnection enerGovDbConnection,
            Guid inspectionId,
            CancellationToken cancellationToken) =>
            await enerGovDbConnection.QueryFirstOrDefaultAsync<InspectionInformation>(
                new CommandDefinition(
                    @"SELECT
                        ISNULL(csi.InspectedBy, '') AS InspectionPerformedBy,
                        insp.IMINSPECTIONTYPEID AS InspectionTypeId,
                        insp.LINKID AS GlobalEntityExtensionId,
                        insp.LINKNUMBER AS GlobalEntityDBA,
                        (SELECT TOP 1 blgle.REGISTRATIONID FROM BLGLOBALENTITYEXTENSION blgle WHERE blgle.BLGLOBALENTITYEXTENSIONID = insp.LINKID) AS RegistrationNumber,
                        (SELECT TOP 1 blglebt.BLEXTBUSINESSTYPEID FROM BLGLOBALENTITYEXTBUSTYPE blglebt
                            INNER JOIN BLEXTBUSINESSTYPE blextbt ON blglebt.BLEXTBUSINESSTYPEID = blextbt.BLEXTBUSINESSTYPEID
                            WHERE blextbt.BLEXTBUSINESSCATEGORYID = '4f47636f-0830-424d-a209-977ae9485f5e' AND
                                  blglebt.BLGLOBALENTITYEXTENSIONID = insp.LINKID) AS ZoneId,
                        ISNULL(insp.ORDERNUMBER, 0) AS OrderNumber,
                        insp.INSPECTIONNUMBER AS InspectionNumber,
                        insp.COMMENTS AS Comments,
                        ISNULL((SELECT COUNT(*)
                            FROM IMINSPECTIONNONCOMPLYCODE insp_nc
                            WHERE insp_nc.IMINSPECTIONID = insp.IMINSPECTIONID AND
                                  insp_nc.RESOLVEDDATE IS NULL), 0) AS OpenNonCompliances,
                        (SELECT MIN(insp_nc.DEADLINEDATE)
                            FROM IMINSPECTIONNONCOMPLYCODE insp_nc
                            WHERE insp_nc.IMINSPECTIONID = insp.IMINSPECTIONID AND
                                  insp_nc.RESOLVEDDATE IS NULL) AS NextDeadlineResolveDate
                    FROM CUSTOMSAVERINSPECTIONS csi
                    INNER JOIN IMINSPECTION insp ON csi.ID = insp.IMINSPECTIONID
                    WHERE insp.IMINSPECTIONID = @InspectionId",
                    new {
                        InspectionId = inspectionId
                    },
                    cancellationToken: cancellationToken));

        public static async Task<IEnumerable<InspectionContactInformation>> GetInspectionContactInformation(
            this DbConnection enerGovDbConnection,
            Guid inspectionId,
            CancellationToken cancellationToken) =>
            await enerGovDbConnection.QueryAsync<InspectionContactInformation>(new CommandDefinition(
                @"SELECT
                        insc.GLOBALENTITYID AS GlobalEntityId,
                        insc.CONTACTTYPEID AS ContactTypeId,
                        insc.ISBILLING AS IsBilling
                    FROM IMINSPECTIONCONTACT insc
                    WHERE insc.IMINSPECTIONID = @InspectionId",
                new {
                    InspectionId = inspectionId
                },
                cancellationToken: cancellationToken));

        public static async Task<IEnumerable<InspectionParcelInformation>> GetInspectionParcelInformation(
            this DbConnection enerGovDbConnection,
            Guid inspectionId,
            CancellationToken cancellationToken) =>
            await enerGovDbConnection.QueryAsync<InspectionParcelInformation>(
                new CommandDefinition(
                    @"SELECT
                        insp.PARCELID AS ParcelId,
                        insp.MAIN AS IsMain
                    FROM IMINSPECTIONPARCEL insp
                    WHERE insp.IMINSPECTIONID = @InspectionId",
                    new {
                        InspectionId = inspectionId
                    },
                    cancellationToken: cancellationToken));

        public static async Task<IEnumerable<InspectionAddressInformation>> GetInspectionAddressInformation(
            this DbConnection enerGovDbConnection,
            Guid inspectionId,
            CancellationToken cancellationToken) =>
            await enerGovDbConnection.QueryAsync<InspectionAddressInformation>(
                new CommandDefinition(
                    @"SELECT
                        insa.MAIN AS IsMain,
                        insa.MAILINGADDRESSID AS MailingAddressId
                    FROM IMINSPECTIONADDRESS insa
                    WHERE insa.IMINSPECTIONID = @InspectionId",
                    new {
                        InspectionId = inspectionId
                    },
                    cancellationToken: cancellationToken));

        public static async Task<IEnumerable<InspectionInspectorInformation>> GetInspectionInspectorInformation(
            this DbConnection enerGovDbConnection,
            Guid inspectionId,
            CancellationToken cancellationToken) =>
            await enerGovDbConnection.QueryAsync<InspectionInspectorInformation>(
                new CommandDefinition(
                    @"SELECT
                        insr.USERID AS UserId,
                        insr.BPRIMARY AS IsPrimary
                    FROM IMINSPECTORREF insr
                    WHERE insr.INSPECTIONID = @InspectionId",
                    new {
                        InspectionId = inspectionId
                    },
                    cancellationToken: cancellationToken));

        public static async Task<IEnumerable<InspectionNonComplianceCodeInformation>>
            GetInspectionNonComplianceCodeInformation(
                this DbConnection enerGovDbConnection,
                Guid inspectionId,
                CancellationToken cancellationToken) =>
            await enerGovDbConnection.QueryAsync<InspectionNonComplianceCodeInformation>(
                new CommandDefinition(
                    @"SELECT 
                                insnc.IMINSPECTIONNONCOMPLYCODEID AS NonComplianceCodeId
                            FROM IMINSPECTIONNONCOMPLYCODE insnc
                            WHERE insnc.IMINSPECTIONID = @InspectionId",
                    new {
                        InspectionId = inspectionId
                    },
                    cancellationToken: cancellationToken));

    }

}