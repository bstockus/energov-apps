using EnerGov.Business.ClerksLicensing.Helpers;
using Lax.Cli.Common;
using Lax.Helpers.AsyncProgress;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets;

public class ClerksLicensingTestTask : CliTask
{

    private readonly RenewalPacketGenerator _renewalPacketGenerator;
    private readonly IEnumerable<ILicenseRenewalFormGenerator> _licenseRenewalGenerators;

    public override string Name => "renewal-packet-generator-test";

    public ClerksLicensingTestTask(
        RenewalPacketGenerator renewalPacketGenerator,
        IEnumerable<ILicenseRenewalFormGenerator> licenseRenewalGenerators)
    {
        _renewalPacketGenerator = renewalPacketGenerator;
        _licenseRenewalGenerators = licenseRenewalGenerators;
    }



    public override async Task Run(ILookup<string, string> args, IEnumerable<string> flags)
    {


        await File.WriteAllBytesAsync(@"C:\Users\stockusb\Downloads\AlcoholRenewalPackets.pdf",
            await _renewalPacketGenerator.Generate(
                new RenewalRequest(
                    2021,
                    _licenseRenewalGenerators.Where(_ => _.LicenseTypeName.Equals("Mobile Home Park"))
                        //.Where(_ => 
                        //    //!_.LicenseTypeName.Equals("Alcohol") &&
                        //    _.LicenseTypeName.Equals("Beer Garden"))
                        //    //!_.LicenseTypeName.Equals("Cabaret") &&
                        //    //!_.LicenseTypeName.Equals("Cigarette") &&
                        //    //!_.LicenseTypeName.Equals("Theater"))
                        .Select(_ => _.DefaultFeesForLicense()),
                    RenewalRequest.RenewalPacketRunType,
                    false,
                    new CoverLetterDates
                    {
                        ApplicationDueDate = new DateTime(2020, 4, 15),
                        JADate = new DateTime(2020, 6, 2),
                        CouncilDate = new DateTime(2020, 6, 11),
                        PaymentDueDate = new DateTime(2020, 6, 15),
                        MiscellaneousDueDate = new DateTime(2020, 5, 27),
                        LetterDate = DateTime.Today
                    }),
                "Development",
                "Test",
                new AsyncProgress<ReportGeneratorProgress>(async progress =>
                    await Task.Run(() => Console.WriteLine($"[{progress.ProgressPercentage:F0}]: {progress.TextMessage}")))));

    }



}