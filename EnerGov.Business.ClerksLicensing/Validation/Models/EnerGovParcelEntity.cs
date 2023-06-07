namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public abstract class EnerGovParcelEntity {

    protected EnerGovParcelEntity(
        BusinessEntityInformation enerGovParcelInformation) {

        ParcelId = enerGovParcelInformation.ParcelId ?? "";
        ParcelNumber = enerGovParcelInformation.ParcelNumber ?? "";
    }
    public string ParcelId { get;  }
    public string ParcelNumber { get;  }

    public override string ToString() => $"{ParcelNumber}";

}