using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using AutoMapper;
using AutoMapper.QueryableExtensions;
using Lax.Business.Bus.Logging;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace EnerGov.Business.UtilityExcavation.UtilityCustomers {

    [LogRequest]
    public class FetchAllActiveUtilityCustomersQuery : IRequest<IEnumerable<UtilityCustomerInfo>> {

        public class Handler : IRequestHandler<FetchAllActiveUtilityCustomersQuery, IEnumerable<UtilityCustomerInfo>> {

            private readonly DbSet<UtilityCustomer> _utilityCustomers;
            private readonly IMapper _mapper;

            public Handler(
                DbSet<UtilityCustomer> utilityCustomers,
                IMapper mapper) {

                _utilityCustomers = utilityCustomers;
                _mapper = mapper;
            }

            public async Task<IEnumerable<UtilityCustomerInfo>> Handle(FetchAllActiveUtilityCustomersQuery request,
                CancellationToken cancellationToken) =>
                await _utilityCustomers.AsNoTracking().ProjectTo<UtilityCustomerInfo>(_mapper.ConfigurationProvider)
                    .Where(_ => _.IsActive).ToListAsync(cancellationToken);

        }

    }

}