using System.Collections.Generic;
using System.Data.Common;
using System.Threading;
using System.Threading.Tasks;
using EnerGov.Business.Alerting.GenericCaseAlerts.Models;
using EnerGov.Data.Configuration;
using EnerGov.Services.Templating;

namespace EnerGov.Business.Alerting.GenericCaseAlerts.Handlers {

    public interface IModuleHandler {

        string Module { get; }

        Task ProcessModule(
            IEnumerable<GenericCaseAlertSpecification> specifications,
            DbConnection enerGovConnection, 
            ConfigurationDbContext configurationDbContext,
            ITemplateRenderingService templateRenderingService,
            CancellationToken cancellationToken);

    }

}