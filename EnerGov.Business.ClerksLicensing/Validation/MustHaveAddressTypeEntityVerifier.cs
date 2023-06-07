using System.Collections.Generic;
using System.Linq;
using EnerGov.Business.ClerksLicensing.Validation.Models;

namespace EnerGov.Business.ClerksLicensing.Validation; 

public class MustHaveAddressTypeEntityVerifier<TEnerGovEntity> : EnerGovEntityVerifier<TEnerGovEntity> where TEnerGovEntity : EnerGovEntity {

    public string AddressType { get; }

    public MustHaveAddressTypeEntityVerifier(string addressType) {
        AddressType = addressType;
    }

    public override IEnumerable<EnerGovEntityValidationMessage> Validate(TEnerGovEntity entity) {
        if (!entity.EntityAddresses.Any(_ => _.AddressType.Equals(AddressType))) {
            return SingleValidationMessages(new MissingAddressTypeEntityValidationMessage(
                nameof(MustHaveAddressTypeEntityVerifier<TEnerGovEntity>), entity, AddressType));
        }

        return NoValidationMessages();
    }

}