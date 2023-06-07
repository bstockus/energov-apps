using EnerGov.Business.ClerksLicensing.Validation.Models;

namespace EnerGov.Business.ClerksLicensing.Validation; 

public abstract class EnerGovEntityValidationMessage {

    protected EnerGovEntityValidationMessage(EnerGovEntity enerGovEntity, EnerGovEntityValidationMessageSeverity severity, string source) {
        EnerGovEntity = enerGovEntity;
        Severity = severity;
        Source = source;
    }

    public EnerGovEntity EnerGovEntity { get; }
    public EnerGovEntityValidationMessageSeverity Severity { get; }
    public string Source { get; }

    public abstract string ToMessage();

    public string ToDisplayMessage() =>
        $"[{Severity.ToString()}] {ToMessage()} (From {Source})";

}