using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using EnerGov.Business.Alerting.GenericCaseAlerts.Handlers;
using EnerGov.Business.Alerting.GenericCaseAlerts.Models;
using EnerGov.Data.Configuration;
using EnerGov.Data.EnerGov;
using EnerGov.Services.Templating;
using Lax.Data.Sql;
using Microsoft.EntityFrameworkCore;

namespace EnerGov.Business.Alerting.GenericCaseAlerts {

    public class GenericCaseAlertTask {

        private readonly ISqlConnectionProvider<EnerGovSqlServerConnection> _enerGovSqlConnectionProvider;
        private readonly ConfigurationDbContext _configurationDbContext;
        private readonly ITemplateRenderingService _templateRenderingService;
        private readonly IEnumerable<IModuleHandler> _moduleHandlers;

        public GenericCaseAlertTask(
            ISqlConnectionProvider<EnerGovSqlServerConnection> enerGovSqlConnectionProvider,
            ConfigurationDbContext configurationDbContext,
            ITemplateRenderingService templateRenderingService,
            IEnumerable<IModuleHandler> moduleHandlers) {

            _enerGovSqlConnectionProvider = enerGovSqlConnectionProvider;
            _configurationDbContext = configurationDbContext;
            _templateRenderingService = templateRenderingService;
            _moduleHandlers = moduleHandlers;
        }

        public async Task Run(CancellationToken cancellationToken) {

            var enerGovConnection = await _enerGovSqlConnectionProvider.GetDbConnectionAsync(cancellationToken);

            var genericAlertSpecifications = await _configurationDbContext
                .Set<GenericCaseAlertSpecification>()
                .AsNoTracking()
                .TagWith("Fetch all Generic Case Alert Specifications")
                .ToListAsync(cancellationToken);

            foreach (var moduleHandler in _moduleHandlers) {

                var releventSpecifications =
                    genericAlertSpecifications.Where(_ => _.Module.Equals(moduleHandler.Module)).ToList();

                Console.WriteLine($"Running Module Handler {moduleHandler.Module} with {releventSpecifications.Count} specification(s).");

                await moduleHandler.ProcessModule(
                    releventSpecifications,
                    enerGovConnection,
                    _configurationDbContext,
                    _templateRenderingService,
                    cancellationToken);

            }


        }

    }

}
