using System.Collections.Generic;
using System.Linq;
using EnerGov.Business.ClerksLicensing.Validation.Models;

namespace EnerGov.Business.ClerksLicensing.Validation; 

public class EnerGovEntityVerificationRunner<TEnerGovEntity> where TEnerGovEntity : EnerGovEntity {

    private readonly IEnumerable<EnerGovEntityVerifier<TEnerGovEntity>> _entityVerifiers;

    public EnerGovEntityVerificationRunner(
        IEnumerable<EnerGovEntityVerifier<TEnerGovEntity>> entityVerifiers) {

        _entityVerifiers = entityVerifiers;
    }

    public IEnumerable<EnerGovEntityValidationMessage> ValidateEntities(IEnumerable<TEnerGovEntity> entities) =>
        _entityVerifiers.SelectMany(_ => entities.SelectMany(_.Validate)).ToList();

}