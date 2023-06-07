using System.Text;

namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public abstract class EnerGovAddressEntity {

    protected EnerGovAddressEntity(
        BusinessEntityInformation enerGovAddressInformation) {

        MailingAddressId = enerGovAddressInformation.MailingAddressId ?? "";
        AddressType = enerGovAddressInformation.AddressType ?? "";
        AddressNumber = enerGovAddressInformation.AddressNumber ?? "";
        PreDirection = enerGovAddressInformation.PreDirection ?? "";
        StreetName = enerGovAddressInformation.StreetName ?? "";
        StreetType = enerGovAddressInformation.StreetType ?? "";
        PostDirection = enerGovAddressInformation.PostDirection ?? "";
        UnitOrSuite = enerGovAddressInformation.UnitOrSuite ?? "";
        AddressLine3 = enerGovAddressInformation.AddressLine3 ?? "";
        City = enerGovAddressInformation.City ?? "";
        State = enerGovAddressInformation.State ?? "";
        ZipCode = enerGovAddressInformation.ZipCode ?? "";
    }

    public string MailingAddressId { get; }
    public string AddressType { get; }
    public string AddressNumber { get; }
    public string PreDirection { get; }
    public string StreetName { get; }
    public string StreetType { get; }
    public string PostDirection { get; }
    public string UnitOrSuite { get; }
    public string AddressLine3 { get; }
    public string City { get; }
    public string State { get; }
    public string ZipCode { get; }

    public override string ToString() {
        var results = new StringBuilder();

        results.Append($"{AddressType} => ");

        results.Append(string.IsNullOrWhiteSpace(AddressNumber) ? "" : $"{AddressNumber} ");
        results.Append(string.IsNullOrWhiteSpace(PreDirection) ? "" : $"{PreDirection} ");
        results.Append(string.IsNullOrWhiteSpace(StreetName) ? "" : $"{StreetName} ");
        results.Append(string.IsNullOrWhiteSpace(StreetType) ? "" : $"{StreetType} ");
        results.Append(string.IsNullOrWhiteSpace(PostDirection) ? "" : $"{PostDirection} ");
        results.Append(string.IsNullOrWhiteSpace(UnitOrSuite) ? "" : $",{UnitOrSuite} ");
        results.Append(string.IsNullOrWhiteSpace(City) ? "" : $",{City} ");
        results.Append(string.IsNullOrWhiteSpace(State) ? "" : $"{State} ");
        results.Append(string.IsNullOrWhiteSpace(ZipCode) ? "" : $"{ZipCode} ");

        return results.ToString().Trim();
    }

}