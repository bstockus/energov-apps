using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;
using AutoMapper;
using AutoMapper.QueryableExtensions;
using Lax.Business.Bus.Logging;
using MediatR;
using Microsoft.EntityFrameworkCore;

namespace EnerGov.Business.UtilityExcavation.UtilityFeeGLAccounts {

    [LogRequest]
    public class FetchAllUtilityFeeGLAccountsQuery : IRequest<IEnumerable<UtilityFeeGLAccountInformation>> {

        public class Handler : IRequestHandler<FetchAllUtilityFeeGLAccountsQuery,
            IEnumerable<UtilityFeeGLAccountInformation>> {

            private readonly DbSet<UtilityFeeGLAccount> _utilityFeeGLAccounts;
            private readonly IMapper _mapper;

            public Handler(
                DbSet<UtilityFeeGLAccount> utilityFeeGLAccounts,
                IMapper mapper) {

                _utilityFeeGLAccounts = utilityFeeGLAccounts;
                _mapper = mapper;
            }

            public async Task<IEnumerable<UtilityFeeGLAccountInformation>> Handle(
                FetchAllUtilityFeeGLAccountsQuery request, CancellationToken cancellationToken) =>
                await _utilityFeeGLAccounts.AsNoTracking()
                    .ProjectTo<UtilityFeeGLAccountInformation>(_mapper.ConfigurationProvider)
                    .ToListAsync(cancellationToken);

        }

    }

}