using System;
using System.Data.Common;
using System.Threading;
using System.Threading.Tasks;
using EnerGov.Data.Configuration;

namespace EnerGov.Business.FireOccupancy.InspectionAutomations {
    
    public interface IFireOccupancyInspectionTask {

        Task HandleInspection(
            ConfigurationDbContext configurationDbContext,
            DbConnection enerGovDbConnection,
            Guid inspectionId, 
            int rowVersion,
            Guid fromStatusId, 
            Guid toStatusId, 
            CancellationToken cancellationToken);

    }

}
