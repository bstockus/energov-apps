using System.Collections.Generic;
using EnerGov.Business.ClerksLicensing.Validation.Models;

namespace EnerGov.Business.ClerksLicensing.Validation; 

public abstract class EnerGovEntityVerifier<TEnerGovEntity> where TEnerGovEntity : EnerGovEntity {

    public abstract IEnumerable<EnerGovEntityValidationMessage> Validate(TEnerGovEntity entity);

    protected IEnumerable<EnerGovEntityValidationMessage> NoValidationMessages() => System.Array.Empty<EnerGovEntityValidationMessage>();

    protected IEnumerable<EnerGovEntityValidationMessage> SingleValidationMessages(
        EnerGovEntityValidationMessage validationMessage) => new[] {validationMessage};

}