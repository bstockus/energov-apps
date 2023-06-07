using System.Linq;
using Autofac;
using Lax.AutoFac.AutoMapper;
using Lax.AutoFac.FluentValidation;
using Lax.AutoFac.MediatR;
using Lax.AutoFac.NodaTime;
using Lax.Business.Bus.Authorization;
using Lax.Business.Bus.Logging;
using Lax.Business.Bus.UnitOfWork;
using Lax.Business.Bus.Validation;
using EnerGov.Business.Identity;
using EnerGov.Security;
using System.Reflection;
using EnerGov.Business.Alerting;
using EnerGov.Business.ClerksLicensing;
using EnerGov.Business.Exports;
using EnerGov.Business.FireOccupancy;
using EnerGov.Business.LandRecords;
using EnerGov.Business.TcmIntegration;
using EnerGov.Business.Utilities;
using EnerGov.Business.UtilityExcavation;
using EnerGov.Data.Configuration;
using EnerGov.Data.CountyTax;
using EnerGov.Data.EnerGov;
using EnerGov.Data.GIS;
using EnerGov.Data.LandRecords;
using EnerGov.Data.Munis;
using EnerGov.Data.TCM;
using EnerGov.Data.ZollRMS;
using EnerGov.Services.Email;
using EnerGov.Services.Reporting.SSRS;
using EnerGov.Services.Templating.Fluid;
using Module = Autofac.Module;

namespace EnerGov.Business {

    public class BusinessModule : Module {

        private readonly string _configurationConnectionString;
        private readonly string _enerGovConnectionString;
        private readonly string _munisConnectionString;
        private readonly string _gisConnectionString;
        private readonly string _landRecordsConnectionString;
        private readonly string _countyTaxConnectionString;
        private readonly string _zollRmsConnectionString;
        private readonly string _tcmConnectionString;

        public static Assembly[] BusinessAssemblies = {
                typeof(IdentityBusinessModule).Assembly,
                typeof(UtilityExcavationBusinessModule).Assembly,
                typeof(FireOccupancyBusinessModule).Assembly,
                typeof(ExportsBusinessModule).Assembly,
                typeof(ClerksLicensingBusinessModule).Assembly,
                typeof(AlertingBusinessModule).Assembly,
                typeof(LandRecordsBusinessModule).Assembly,
                typeof(UtilitiesBusinessModule).Assembly,
                typeof(TcmIntegratiobBusinessModule).Assembly
            };

        public BusinessModule(
            string configurationConnectionString,
            string enerGovConnectionString,
            string munisConnectionString,
            string gisConnectionString,
            string landRecordsConnectionString,
            string countyTaxConnectionString,
            string zollRmsConnectionString,
            string tcmConnectionString) {

            _configurationConnectionString = configurationConnectionString;
            _enerGovConnectionString = enerGovConnectionString;
            _munisConnectionString = munisConnectionString;
            _gisConnectionString = gisConnectionString;
            _landRecordsConnectionString = landRecordsConnectionString;
            _countyTaxConnectionString = countyTaxConnectionString;
            _zollRmsConnectionString = zollRmsConnectionString;
            _tcmConnectionString = tcmConnectionString;
        }

        protected override void Load(ContainerBuilder builder) {

            builder
                .RegisterMediatRBus()
                .RegisterMediatRHandlers(BusinessAssemblies)
                .RegisterBusUnitOfWork()
                .RegisterBusLogging()
                .RegisterBusAuthorization()
                .RegisterBusValidation();

            builder.RegisterValidators(BusinessAssemblies);

            builder.RegisterAutoMapperProfiles(BusinessAssemblies);

            builder.RegisterSystemClock();

            builder
                .RegisterFluidTemplating()
                .RegisterEmailSender()
                .RegisterSSRSReporting();

            builder
                .RegisterModule(new ConfigurationDataModule(
                    BusinessAssemblies.Concat(new[] {typeof(EmailServiceModule).Assembly}).ToArray(),
                    _configurationConnectionString))
                .RegisterModule(new EnerGovDataModule(_enerGovConnectionString))
                .RegisterModule(new MunisDataModule(_munisConnectionString))
                .RegisterModule(new GISDataModule(_gisConnectionString))
                .RegisterModule(new LandRecordsDataModule(_landRecordsConnectionString))
                .RegisterModule(new CountyTaxDataModule(_countyTaxConnectionString))
                .RegisterModule(new ZollRmsDataModule(_zollRmsConnectionString))
                .RegisterModule(new TcmDataModule(_tcmConnectionString))
                .RegisterModule(new SecurityModule(BusinessAssemblies))
                .RegisterAssemblyModules(BusinessAssemblies);

        }

    }

}
