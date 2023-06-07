using EnerGov.Business.ClerksLicensing.Validation.Models;

namespace EnerGov.Business.ClerksLicensing.Validation; 

public class MissingAddressTypeEntityValidationMessage : EnerGovEntityValidationMessage {


    public MissingAddressTypeEntityValidationMessage(string source, EnerGovEntity enerGovEntity,
        string missingAddressType) : base(enerGovEntity, EnerGovEntityValidationMessageSeverity.Error, source) {
        MissingAddressType = missingAddressType;
    }
    public string MissingAddressType { get; }
    public override string ToMessage() => $"is missing an address with Address Type '{MissingAddressType}'";

}