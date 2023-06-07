using System;
using System.Data.Common;
using System.Threading;
using System.Threading.Tasks;
using Dapper;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations.Tasks.ReInspectionCreation {

    public static class ReInspectionDbConnectionExtensions {

        public static async Task UpdateParentInspectionToHavingReInspection(
            this DbConnection enerGovDbConnection,
            Guid inspectionId,
            CancellationToken cancellationToken) =>
            await enerGovDbConnection.ExecuteScalarAsync(new CommandDefinition(
                @"UPDATE IMINSPECTION 
                                SET ISREINSPECTION = 1
                                WHERE IMINSPECTIONID = @InspectionId",
                new {
                    InspectionId = inspectionId
                },
                cancellationToken: cancellationToken));

        public static async Task<string> GetNextInspectionAutoNumber(
            this DbConnection enerGovDbConnection,
            CancellationToken cancellationToken) {

            var inspectionNumber = await enerGovDbConnection.ExecuteScalarAsync<string>(
                new CommandDefinition(
                    @"SELECT dbo.GetAutoNumberWithClassName('EnerGovBusiness.Inspections.Inspection')",
                    cancellationToken: cancellationToken));

            await enerGovDbConnection.ExecuteScalarAsync(
                new CommandDefinition(
                    @"EXEC dbo.GETANDUPDATEAUTONUMBER 'EnerGovBusiness.Inspections.Inspection'",
                    cancellationToken: cancellationToken));

            return inspectionNumber?.Substring(1) ?? "";

        }

        public static async Task InsertReInspection(
            this DbConnection enerGovDbConnection,
            Guid reInspectionId,
            string reInspectionNumber,
            InspectionInformation inspectionInformation,
            CancellationToken cancellationToken) {

            var followUpDate = inspectionInformation.NextDeadlineResolveDate ?? DateTime.Today.AddDays(10.0d);
            if (followUpDate <= DateTime.Today) {
                followUpDate = DateTime.Today.AddDays(10.0d);
            }

            await enerGovDbConnection.ExecuteScalarAsync(
                new CommandDefinition(
                    @"INSERT INTO IMINSPECTION
                                    (IMINSPECTIONID, IMINSPECTIONSTATUSID, IMINSPECTIONTYPEID, INSPECTIONNUMBER, CREATEDATE, REQUESTEDDATE, REINSPECTED, ISREINSPECTION,
                                    COMPLETE, ROWVERSION, LASTCHANGEDBY, LASTCHANGEDON, GISX, GISY, IMINSPECTIONLINKID, LINKID,
                                    LINKNUMBER, REQUESTEDAMORPM, SCHEDULEDAMORPM, IMINSPECTIONREQUESTEDSOURCEID, PARENTINSPECTIONNUMBER, ESTIMATEDMINUTES,
                                    ISPARTIALPASS, INSPECTIONORDER, COMMENTS, NEXTSCHEDULEDAMORPM,SCHEDULEDSTARTDATE,SCHEDULEDENDDATE,ORDERNUMBER)
                                VALUES
                                    (
                                    @InspectionId,
                                    '9daf0666-1420-4a9c-af19-8b9ebce45769',
                                    @InspectionTypeId,
                                    @InspectionNumber,
                                    GETDATE(),
                                    @RequestedDate,
                                    0,
                                    0,
                                    0,
                                    1,
                                    'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
                                    GETDATE(),
                                    0,
                                    0,
                                    5,
                                    @GlobalEntityExtensionId,
                                    @GlobalEntityDBA,
                                    0,
                                    0,
                                    1,
                                    @ParentInspectionNumber,
                                    0,
                                    0,
                                    0,
                                    @Comments,
                                    0,
                                    @RequestedDate,
                                    @RequestedDate,
                                    @OrderNumber
                                    )",
                    new {
                        InspectionId = reInspectionId,
                        inspectionInformation.InspectionTypeId,
                        InspectionNumber = reInspectionNumber,
                        RequestedDate =  followUpDate,
                        inspectionInformation.GlobalEntityExtensionId,
                        inspectionInformation.GlobalEntityDBA,
                        ParentInspectionNumber = inspectionInformation.InspectionNumber,
                        OrderNumber = inspectionInformation.OrderNumber + 100,
                        Comments = inspectionInformation.Comments ?? ""
                    },
                    cancellationToken: cancellationToken));

            await enerGovDbConnection.ExecuteScalarAsync(
                new CommandDefinition(
                    @"INSERT INTO CUSTOMSAVERINSPECTIONS (ID, InspectedBy) 
                                    VALUES (@InspectionId, @InspectionPerformedBy)",
                    new {
                        InspectionId = reInspectionId, inspectionInformation.InspectionPerformedBy
                    },
                    cancellationToken: cancellationToken));

            await enerGovDbConnection.ExecuteScalarAsync(
                new CommandDefinition(
                    @"INSERT INTO CUSTOMSAVERINSPECTIONS2 (ID) VALUES (@InspectionId)",
                    new {
                        InspectionId = reInspectionId
                    },
                    cancellationToken: cancellationToken));
        }


        public static async Task InsertReInspectionReference(
            this DbConnection enerGovDbConnection,
            Guid reInspectionId,
            InspectionInformation inspectionInformation,
            CancellationToken cancellationToken) =>
            await enerGovDbConnection.ExecuteScalarAsync(
                new CommandDefinition(
                    @"INSERT INTO IMINSPECTIONACTREF 
                            (OBJECTID, IMINSPECTIONID, OBJECTMSG) 
                        VALUES 
                            (
                                @GlobalEntityExtensionId,
                                @InspectionId,
                                @RegistrationNumber
                            )",
                    new {
                        inspectionInformation.GlobalEntityExtensionId,
                        InspectionId = reInspectionId,
                        inspectionInformation.RegistrationNumber
                    },
                    cancellationToken: cancellationToken));

        public static async Task InsertReInspectionInspector(
            this DbConnection enerGovDbConnection,
            Guid reInspectionId,
            InspectionInspectorInformation inspectionInspectorInformation,
            CancellationToken cancellationToken) =>
            await enerGovDbConnection.ExecuteScalarAsync(
                new CommandDefinition(
                    @"INSERT INTO IMINSPECTORREF
                            (INSPECTIONID, USERID, BPRIMARY, IMINSPECTORREFID) 
                        VALUES
                            (
                                @InspectionId,
                                @UserId,
                                @IsPrimary,
                                @InspectorRefId
                            )",
                    new {
                        InspectorRefId = Guid.NewGuid().ToString(),
                        InspectionId = reInspectionId,
                        inspectionInspectorInformation.UserId,
                        inspectionInspectorInformation.IsPrimary
                    },
                    cancellationToken: cancellationToken));

        public static async Task InsertReInspectionParcel(
            this DbConnection enerGovDbConnection,
            Guid reInspectionId,
            InspectionParcelInformation inspectionParcelInformation,
            CancellationToken cancellationToken) =>
            await enerGovDbConnection.ExecuteScalarAsync(
                new CommandDefinition(
                    @"INSERT INTO IMINSPECTIONPARCEL
                                (INSPECTIONPARCELID, PARCELID, IMINSPECTIONID, MAIN)
                            VALUES 
                                (
                                @InspectionParcelId,
                                @ParcelId,
                                @InspectionId,
                                @IsMain
                                )",
                    new {
                        InspectionParcelId = Guid.NewGuid().ToString(),
                        inspectionParcelInformation.ParcelId,
                        InspectionId = reInspectionId,
                        inspectionParcelInformation.IsMain
                    },
                    cancellationToken: cancellationToken));

        public static async Task InsertReInspectionContact(
            this DbConnection enerGovDbConnection,
            Guid reInspectionId,
            InspectionContactInformation inspectionContactInformation,
            CancellationToken cancellationToken) =>
            await enerGovDbConnection.ExecuteScalarAsync(
                new CommandDefinition(
                    @"INSERT INTO IMINSPECTIONCONTACT
                                (IMINSPECTIONCONTACTID, IMINSPECTIONID, GLOBALENTITYID, CONTACTTYPEID, ISBILLING)
                            VALUES
                                (
                                    @InspectionContactId,
                                    @InspectionId,
                                    @GlobalEntityId,
                                    @ContactTypeId,
                                    @IsBilling
                                )",
                    new {
                        InspectionContactId = Guid.NewGuid().ToString(),
                        InspectionId = reInspectionId,
                        inspectionContactInformation.GlobalEntityId,
                        inspectionContactInformation.ContactTypeId,
                        inspectionContactInformation.IsBilling
                    },
                    cancellationToken: cancellationToken));

        public static async Task InsertReInspectionAddress(
            this DbConnection enerGovDbConnection,
            Guid reInspectionId,
            InspectionAddressInformation inspectionAddressInformation,
            CancellationToken cancellationToken) {

            var mailingAddressId = Guid.NewGuid().ToString();

            await enerGovDbConnection.ExecuteScalarAsync(
                new CommandDefinition(
                    @"INSERT INTO MAILINGADDRESS
                            (MAILINGADDRESSID, ADDRESSLINE1, ADDRESSLINE2, ADDRESSLINE3, CITY, STATE, COUNTY,
                             COUNTRY, POSTALCODE, COUNTRYTYPE, LASTCHANGEDON, LASTCHANGEDBY,
                             POSTDIRECTION, PREDIRECTION, ROWVERSION, ADDRESSID, ADDRESSTYPE, STREETTYPE,
                             PARCELID, PARCELNUMBER, UNITORSUITE, PROVINCE,
                             RURALROUTE, STATION, COMPSITE, POBOX, ATTN, GENERALDELIVERY)
                        SELECT TOP 1
                             @NewMailingAddressId,
                             ma.ADDRESSLINE1,
                             ma.ADDRESSLINE2,
                             ma.ADDRESSLINE3,
                             ma.CITY,
                             ma.STATE,
                             ma.COUNTY,
                             ma.COUNTRY,
                             ma.POSTALCODE,
                             ma.COUNTRYTYPE,
                             GETDATE(),
                             'a24df514-c3c1-49c7-8784-0b2bf58c79fa',
                             ma.POSTDIRECTION,
                             ma.PREDIRECTION,
                             1,
                             ma.ADDRESSID,
                             ma.ADDRESSTYPE,
                             ma.STREETTYPE,
                             ma.PARCELID,
                             ma.PARCELNUMBER,
                             ma.UNITORSUITE,
                             ma.PROVINCE,
                             ma.RURALROUTE,
                             ma.STATION,
                             ma.COMPSITE,
                             ma.POBOX,
                             ma.ATTN,
                             ma.GENERALDELIVERY
                        FROM MAILINGADDRESS ma
                        WHERE ma.MAILINGADDRESSID = @MailingAddressId",
                    new {
                        inspectionAddressInformation.MailingAddressId,
                        NewMailingAddressId = mailingAddressId
                    },
                    cancellationToken: cancellationToken));

            await enerGovDbConnection.ExecuteScalarAsync(
                new CommandDefinition(
                    @"INSERT INTO IMINSPECTIONADDRESS
                                (INSPECTIONADDRESSID, IMINSPECTIONID, MAILINGADDRESSID, MAIN) 
                            VALUES
                                (
                                    @InspectionAddressId,
                                    @InspectionId,
                                    @MailingAddressId,
                                    @IsMain
                                )",
                    new {
                        InspectionAddressId = Guid.NewGuid().ToString(),
                        InspectionId = reInspectionId,
                        MailingAddressId = mailingAddressId,
                        inspectionAddressInformation.IsMain
                    },
                    cancellationToken: cancellationToken));

        }

        public static async Task InsertReInspectionNonComplianceCode(
            this DbConnection enerGovDbConnection,
            Guid reInspectionId,
            InspectionNonComplianceCodeInformation inspectionNonComplianceCodeInformation,
            CancellationToken cancellationToken) =>
            await enerGovDbConnection.ExecuteScalarAsync(
                new CommandDefinition(
                    @"INSERT INTO IMINSPECTIONNONCOMPLYCODE
                            (IMINSPECTIONNONCOMPLYCODEID, IMINSPECTIONID, IMNONCOMPLIANCECODEID, IMNONCOMPLIANCECODEREVISIONID, 
                             IMNONCOMPLIANCERISKID, IMNONCOMPLIANCERESPPARTYID, CODENUMBER, CODEDESCRIPTION, 
                             COMMENTS, DEADLINEDATE, RESOLVEDDATE) 
                        SELECT TOP 1
                            @NewNonComplianceCodeId,
                            @ReInspectionId,
                            innc.IMNONCOMPLIANCECODEID,
                            innc.IMNONCOMPLIANCECODEREVISIONID,
                            innc.IMNONCOMPLIANCERISKID,
                            innc.IMNONCOMPLIANCERESPPARTYID,
                            innc.CODENUMBER,
                            innc.CODEDESCRIPTION,
                            innc.COMMENTS,
                            innc.DEADLINEDATE,
                            innc.RESOLVEDDATE
                        FROM IMINSPECTIONNONCOMPLYCODE innc
                        WHERE innc.IMINSPECTIONNONCOMPLYCODEID = @NonComplianceCodeId",
                    new {
                        NewNonComplianceCodeId = Guid.NewGuid().ToString(),
                        ReInspectionId = reInspectionId,
                        inspectionNonComplianceCodeInformation.NonComplianceCodeId
                    },
                    cancellationToken: cancellationToken));

    }

}