using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using EnerGov.Business.ClerksLicensing.Helpers;
using EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Models;
using iText.Forms;
using iText.Kernel.Pdf;
using Lax.Helpers.AssemblyResources;

namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.PersonalDataSheet;

public class PersonalDataSheetGenerator {

    public static async Task<byte[]> GeneratePersonalDataSheet(
        IEnumerable<EnerGovLicenseInformation> enerGovLicenseInformations,
        bool includeDateOfBirths) {
        await using var memoryStream = new MemoryStream();

        await using var writer = new PdfWriter(memoryStream);
        writer.SetSmartMode(true);
        using var pdfDoc = new PdfDocument(writer);

        var contacts = enerGovLicenseInformations.GroupBy(_ => _.PersonId)
            .Select(_ => new ClerkPersonalDataSheetPerson(_.First()));

        if (!contacts.Any()) {
            return null;
        }

        var licenseInformation = enerGovLicenseInformations.First();

        var pageNumber = await AppendPersonalDataSheetForm(
            pdfDoc,
            contacts,
            1,
            licenseInformation.FullLegalName,
            licenseInformation.TradeName,
            licenseInformation.BusinessNumber,
            licenseInformation.LocationAddress_StreetAddress ?? "",
            includeDateOfBirths);

        if (pageNumber == 0) {
            return null;
        }

        pdfDoc.Close();

        return memoryStream.ToArray();
    }

    private static async Task<int> AppendPersonalDataSheetForm(
        PdfDocument previousDocument,
        IEnumerable<ClerkPersonalDataSheetPerson> people,
        int pageNumber,
        string legalName,
        string tradeName,
        string registrationNumber,
        string premiseAddress,
        bool includeDateOfBirths) {
        if (!people.Any()) {
            return 0;
        }

        var personalDataSheetFormPdfData =
            await typeof(ClerksLicensingBusinessModule).Assembly.GetAssemblyResourceAsBytes(
                "PersonalDataSheet.pdf");

        await using var personalDataSheetFormPdfMemoryStream = new MemoryStream();
        using var personalDataSheetFormPdfDocument = new PdfDocument(
            new PdfReader(new MemoryStream(personalDataSheetFormPdfData)),
            new PdfWriter(personalDataSheetFormPdfMemoryStream));

        var personalDataSheetForm = PdfAcroForm.GetAcroForm(personalDataSheetFormPdfDocument, true);

        personalDataSheetForm.GetField("LegalName").SetValue(legalName ?? "");
        personalDataSheetForm.GetField("TradeName").SetValue(tradeName ?? "");
        personalDataSheetForm.GetField("RegistrationNumber").SetValue(registrationNumber);
        personalDataSheetForm.GetField("PremiseAddress").SetValue(premiseAddress);
        personalDataSheetForm.GetField("PageNumber").SetValue(pageNumber.ToString());

        var index = 1;
        foreach (var person in people.Take(6)) {
            FillInPersonalInformation(
                personalDataSheetForm,
                person,
                index - 1,
                includeDateOfBirths);

            index++;
        }

        personalDataSheetForm.FlattenFields();
        personalDataSheetFormPdfDocument.Close();

        PdfHelper.AppendPagesFromPdf(personalDataSheetFormPdfMemoryStream.ToArray(), previousDocument);

        if (people.Skip(6).Any()) {
            await AppendPersonalDataSheetForm(previousDocument, people.Skip(6), pageNumber + 1, legalName,
                tradeName, registrationNumber, premiseAddress, includeDateOfBirths);
        }

        return pageNumber;
    }

    private static void FillInPersonalInformation(
        PdfAcroForm form,
        ClerkPersonalDataSheetPerson person,
        int index,
        bool includeDateOfBirth) {
        form.GetField($"FirstName_{index}").SetValue(person.FirstName ?? "");
        form.GetField($"MiddleName_{index}").SetValue(person.MiddleName ?? "");
        form.GetField($"LastName_{index}").SetValue(person.LastName ?? "");

        form.GetField($"StreetAddress_{index}").SetValue(person.AddressStreet ?? "");
        form.GetField($"City_{index}").SetValue(person.AddressCity?.FormatAsCityName() ?? "");
        form.GetField($"State_{index}").SetValue(person.AddressState ?? "");
        form.GetField($"ZipCode_{index}").SetValue(person.AddressZipCode?.FormatAsZipCode() ?? "");

        form.GetField($"PhoneNumber_{index}").SetValue(person.PhoneNumber?.FormatAsTelephoneNumber() ?? "");
        form.GetField($"Email_{index}").SetValue(person.Email ?? "");

        if (includeDateOfBirth) {
            form.GetField($"DateOfBirth_{index}").SetValue(person?.DateOfBirth?.ToShortDateString() ?? "");
        }
    }

}