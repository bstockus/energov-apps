using System.Collections.Generic;

namespace EnerGov.Business.ClerksLicensing.Validation.Models; 

public abstract class EnerGovEntity {

    public abstract EnerGovEntityIdentifier EntityIdentifier { get; }

    public abstract IEnumerable<EnerGovAddressEntity> EntityAddresses { get; }

}