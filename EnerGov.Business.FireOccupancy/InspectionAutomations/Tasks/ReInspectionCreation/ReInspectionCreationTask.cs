using System;
using System.Data.Common;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using EnerGov.Business.FireOccupancy.Constants;
using EnerGov.Business.FireOccupancy.InspectionAutomations.Models;
using EnerGov.Data.Configuration;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Tasks.ReInspectionCreation {

    public class ReInspectionCreationTask : IFireOccupancyInspectionTask {

        private static readonly Guid[] ValidFromStatuses = {
            InspectionStatus.Requested,
            InspectionStatus.RequestedAutoCreated,
            InspectionStatus.Scheduled
        };

        private static readonly Guid[] ValidToStatuses = {
            InspectionStatus.NoViolationsFound,
            InspectionStatus.ViolationFoundNotResolved,
            InspectionStatus.ViolationFoundResolved
        };

        public async Task HandleInspection(
            ConfigurationDbContext configurationDbContext,
            DbConnection enerGovDbConnection,
            Guid inspectionId,
            int rowVersion,
            Guid fromStatusId,
            Guid toStatusId,
            CancellationToken cancellationToken) {

            if (!ValidFromStatuses.Contains(fromStatusId) || !ValidToStatuses.Contains(toStatusId)) {
                return;
            }

            var inspectionInformation =
                await enerGovDbConnection.GetInspectionInformation(inspectionId, cancellationToken);

            if (inspectionInformation.OpenNonCompliances > 0) {

                // 1a. Get Inspection Contacts:
                var inspectionContactsInformation =
                    await enerGovDbConnection.GetInspectionContactInformation(inspectionId, cancellationToken);
                
                // 1b. Get Inspection Parcels:
                var inspectionParcelsInformation =
                    await enerGovDbConnection.GetInspectionParcelInformation(inspectionId, cancellationToken);

                // 1c. Get Inspection Addresses:
                var inspectionAddressesInformation =
                    await enerGovDbConnection.GetInspectionAddressInformation(inspectionId, cancellationToken);

                // 1d. Get Inspection Inspectors:
                var inspectionInspectorsInformation =
                    await enerGovDbConnection.GetInspectionInspectorInformation(inspectionId, cancellationToken);

                // 1e. Get Inspection Non-Compliance:
                var inspectionNonComplianceCodesInformation =
                    await enerGovDbConnection.GetInspectionNonComplianceCodeInformation(inspectionId,
                        cancellationToken);

                // 2a. Generate Re-Inspection Id
                var reInspectionId = Guid.NewGuid();

                // 2b. Create Re-Inspection Record
                configurationDbContext.Set<ReInspection>().Add(new ReInspection {
                    InspectionId = inspectionId,
                    RowVersion = rowVersion,
                    ReInspectionId = reInspectionId,
                    NotificationFailureCount = 0,
                    ReminderFailureCount = 0
                });

                // 3a. Set Parent Inspection to be Re-Inspection
                await enerGovDbConnection.UpdateParentInspectionToHavingReInspection(inspectionId, cancellationToken);

                // 3b. Get Next Inspection Auto Number
                var reInspectionNumber = await enerGovDbConnection.GetNextInspectionAutoNumber(cancellationToken);

                // 3c. Insert Re-Inspection Record (also inserts Custom Fields records.)
                await enerGovDbConnection.InsertReInspection(
                    reInspectionId,
                    reInspectionNumber,
                    inspectionInformation,
                    cancellationToken);

                // 3d. Insert Re-Inspection Reference Record
                await enerGovDbConnection.InsertReInspectionReference(
                    reInspectionId,
                    inspectionInformation,
                    cancellationToken);

                // 4a. Insert Re-Inspection Inspector Records
                foreach (var inspectionInspectorInformation in inspectionInspectorsInformation) {
                    await enerGovDbConnection.InsertReInspectionInspector(
                        reInspectionId,
                        inspectionInspectorInformation,
                        cancellationToken);
                }

                // 4b. Insert Re-Inspection Parcel Records
                foreach (var inspectionParcelInformation in inspectionParcelsInformation) {
                    await enerGovDbConnection.InsertReInspectionParcel(
                        reInspectionId,
                        inspectionParcelInformation,
                        cancellationToken);
                }

                // 4c. Insert Re-Inspection Contact Records
                foreach (var inspectionContactInformation in inspectionContactsInformation) {
                    await enerGovDbConnection.InsertReInspectionContact(
                        reInspectionId,
                        inspectionContactInformation,
                        cancellationToken);
                }

                // 4d. Insert Re-Inspection Address Records
                foreach (var inspectionAddressInformation in inspectionAddressesInformation) {
                    await enerGovDbConnection.InsertReInspectionAddress(
                        reInspectionId,
                        inspectionAddressInformation,
                        cancellationToken);
                }

                // 4e. Insert Re-Inspection Non-Compliance Records
                foreach (var inspectionNonComplianceCodeInformation in inspectionNonComplianceCodesInformation) {
                    await enerGovDbConnection.InsertReInspectionNonComplianceCode(
                        reInspectionId,
                        inspectionNonComplianceCodeInformation,
                        cancellationToken);
                }

            }


        }

    }

}