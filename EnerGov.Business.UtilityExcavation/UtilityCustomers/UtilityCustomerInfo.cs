using System;
using AutoMapper;

namespace EnerGov.Business.UtilityExcavation.UtilityCustomers {

    public class UtilityCustomerInfo {

        public Guid EnerGovGlobalEntityId { get; set; }

        public string CustomerName { get; set; }
        public bool IsActive { get; set; }

        public class Mapping : Profile {

            public Mapping() {
                CreateMap<UtilityCustomer, UtilityCustomerInfo>();
            }

        }

    }

}