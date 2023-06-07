using System.Threading;
using System.Threading.Tasks;
using AutoMapper;
using AutoMapper.QueryableExtensions;
using MediatR;
using Microsoft.EntityFrameworkCore;
using EnerGov.Business.Abstractions.Identity;

namespace EnerGov.Business.Identity.Users {

    public class FetchIdentityByUserIdQueryHandler : IRequestHandler<FetchIdentityByUserIdQuery, IdentityInfo> {

        private readonly DbSet<User> _users;
        private readonly IMapper _mapper;

        public FetchIdentityByUserIdQueryHandler(
            DbSet<User> users,
            IMapper mapper) {
            _users = users;
            _mapper = mapper;
        }


        public async Task<IdentityInfo> Handle(FetchIdentityByUserIdQuery request,
            CancellationToken cancellationToken) =>

            await _users.AsNoTracking()
                .Include(_ => _.UserRoles).ThenInclude(_ => _.Role).ThenInclude(_ => _.RolePermissions)
                .ProjectTo<IdentityInfo>(_mapper.ConfigurationProvider)
                .FirstOrDefaultAsync(_ => _.Id.Equals(request.UserId), cancellationToken);

    }

}