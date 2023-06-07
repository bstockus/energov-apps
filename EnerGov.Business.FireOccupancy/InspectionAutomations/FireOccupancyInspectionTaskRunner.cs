using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using EnerGov.Business.FireOccupancy.InspectionAutomations.Models;
using EnerGov.Data.Configuration;
using EnerGov.Data.EnerGov;
using Lax.Data.Sql;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations {

    public class FireOccupancyInspectionTaskRunner {

        public class InspectionResult {

            public InspectionResult(string inspectionIdRaw, string inspectionStatusIdRaw, int rowVersion) {
                InspectionIdRaw = inspectionIdRaw;
                InspectionStatusIdRaw = inspectionStatusIdRaw;
                RowVersion = rowVersion;
            }

            public string InspectionIdRaw { get; }
            public Guid InspectionId => Guid.Parse(InspectionIdRaw);
            public string InspectionStatusIdRaw { get; }
            public Guid InspectionStatusId => Guid.Parse(InspectionStatusIdRaw);
            public int RowVersion { get; }

        }

        private readonly ISqlConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlConnectionProvider;
        private readonly IOptions<FireOccupancyConfiguration> _fireOccupancyConfigurationOptions;
        private readonly IEnumerable<IFireOccupancyInspectionTask> _fireOccupancyInspectionTasks;
        private readonly ConfigurationDbContext _configurationDbContext;

        public FireOccupancyInspectionTaskRunner(
            ISqlConnectionProvider<EnerGovSqlServerConnection> enerGovSqlConnectionProvider,
            IOptions<FireOccupancyConfiguration> fireOccupancyConfigurationOptions,
            IEnumerable<IFireOccupancyInspectionTask> fireOccupancyInspectionTasks,
            ConfigurationDbContext configurationDbContext) {

            _enerGovSqlConnectionProvider = enerGovSqlConnectionProvider;
            _fireOccupancyConfigurationOptions = fireOccupancyConfigurationOptions;
            _fireOccupancyInspectionTasks = fireOccupancyInspectionTasks;
            _configurationDbContext = configurationDbContext;
        }

        public async Task RunTasks(CancellationToken cancellationToken) {

            var enerGovConnection = await _enerGovSqlConnectionProvider.GetDbConnectionAsync(cancellationToken);
            var configurationOptions = _fireOccupancyConfigurationOptions.Value;

            // Get all previously scanned inspections:
            var previouslyScannedInspections = (await _configurationDbContext
                    .Set<Inspection>()
                    .AsNoTracking()
                    .TagWith("Fetch all previously scanned inspections.")
                    .ToListAsync(cancellationToken))
                .ToLookup(_ => _.InspectionId)
                .ToDictionary(
                    _ => _.Key,
                    _ => _.OrderByDescending(x => x.RowVersion).First());

            // Get all relevant inspections from EnerGov
            var relevantInspections = await enerGovConnection.QueryAsync<InspectionResult>(new CommandDefinition(
                @"SELECT
                    insp.IMINSPECTIONID AS InspectionIdRaw,
                    insp.IMINSPECTIONSTATUSID AS InspectionStatusIdRaw,
                    insp.ROWVERSION AS RowVersion
                FROM IMINSPECTION insp
                WHERE insp.IMINSPECTIONTYPEID IN @InspectionTypeIds",
                new {
                    configurationOptions.Scanning.InspectionTypeIds
                },
                cancellationToken: cancellationToken));

            // Handle each relevant inspection from EnerGov
            foreach (var relevantInspection in relevantInspections) {

                Console.WriteLine(
                    $"Handling Inspection {relevantInspection.InspectionId}//{relevantInspection.RowVersion}");

                int? previousRowVersion = null;
                Guid? previousStatusId = null;

                // Have we previously scanned this inspections, if so what was its previous row number and status:
                if (previouslyScannedInspections.ContainsKey(relevantInspection.InspectionId)) {

                    previousRowVersion = previouslyScannedInspections[relevantInspection.InspectionId].RowVersion;
                    previousStatusId = previouslyScannedInspections[relevantInspection.InspectionId].InspectionStatusId;

                }

                // Is this a new inspection or has its row version changed, if so we will need to add a new inspection record
                if (!previousRowVersion.HasValue ||
                    previousRowVersion.Value != relevantInspection.RowVersion) {

                    _configurationDbContext.Set<Inspection>().Add(new Inspection {
                        InspectionId = relevantInspection.InspectionId,
                        RowVersion = relevantInspection.RowVersion,
                        InspectionStatusId = relevantInspection.InspectionStatusId,
                        DateScanned = DateTime.Now
                    });

                }

                // Is this a valid status transition for running tasks
                if (previousStatusId.HasValue && !previousStatusId.Equals(relevantInspection.InspectionStatusId)) {
                    foreach (var fireOccupancyInspectionTask in _fireOccupancyInspectionTasks) {

                        Console.WriteLine($"      Running Task {fireOccupancyInspectionTask.GetType().FullName}...");

                        await fireOccupancyInspectionTask.HandleInspection(
                            _configurationDbContext,
                            enerGovConnection,
                            relevantInspection.InspectionId,
                            relevantInspection.RowVersion,
                            previousStatusId.Value,
                            relevantInspection.InspectionStatusId,
                            cancellationToken);

                    }
                }

                

                // Last step is to commit any changes we have made
                await _configurationDbContext.SaveChangesAsync(cancellationToken);
            }

            

        }

    }

}