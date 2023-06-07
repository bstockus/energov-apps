using EnerGov.Business.ClerksLicensing.Helpers;
using Lax.Cli.Common;
using Lax.Helpers.AsyncProgress;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace EnerGov.Business.ClerksLicensing.LicensePackets;

public class LicensePacketGeneratorTestTask : CliTask
{

    private readonly LicensePacketGenerator _licensePacketGenerator;

    public override string Name => "license-packet-generator-test";

    public LicensePacketGeneratorTestTask(
        LicensePacketGenerator licensePacketGenerator)
    {

        _licensePacketGenerator = licensePacketGenerator;
    }

    public override async Task Run(ILookup<string, string> args, IEnumerable<string> flags)
    {

        await File.WriteAllBytesAsync(@"C:\Users\stockusb\Downloads\ClerksLicensePacket.pdf",
                await _licensePacketGenerator.Generate(
                    new LicensePacketGenerator.LicensePacketRequest(
                        2022,
                        new[] {
                            "7f4eb150-f664-4990-a1d2-2b5a3a5afa76",
                            "d59413cc-e339-4605-b35e-5f8538a90afc",
                            "0442003d-b7a4-4600-b559-89a0f5a9e515",
                            "b2d09619-c5cd-43bc-bf1a-1005eae96055",
                            "ac6c93dc-c565-4969-90af-83397e07759c",
                            "9708e580-6c6e-42b5-a9d5-5f13b7c2aff9"
                        },
                        new[] {
                            "6ed562c0-cb4b-4001-874b-b0fa05d7cb4d"
                        },
                        DateTime.Today),
                    reportGeneratorProgress: new AsyncProgress<ReportGeneratorProgress>(async progress =>
                        await Task.Run(() => Console.WriteLine($"[{progress.ProgressPercentage:F0}]: {progress.TextMessage}")))));

    }

}