using AutoMapper;
using EnerGov.Business.Abstractions.Identity;
using EnerGov.Business.Identity.Roles;

namespace EnerGov.Business.Identity.Users {

    public class UserIdentityInfoMapping : Profile {

        public UserIdentityInfoMapping() {
            CreateMap<User, IdentityInfo>();
            CreateMap<UserRole, IdentityInfo.IdentityRoleInfo>();
            CreateMap<RolePermission, IdentityInfo.IdentityRoleInfo.IdentityRolePermissionInfo>();
        }

    }

}