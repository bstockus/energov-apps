using System.Linq;
using EnerGov.Security.User;

namespace EnerGov.Security.Authorization.Requirements {

    public class MustHavePermission : UserBasedRequirement {

        public string PermissionName { get; }

        public MustHavePermission(string permissionName) {
            PermissionName = permissionName;
        }

        public class Handler : Handler<MustHavePermission> {

            public Handler(IUserService userService) : base(userService) { }

            protected override bool HandleRequirementForUser(UserInformation userInformation,
                MustHavePermission requirement) =>
                userInformation.EffectivePermissions.Contains(requirement.PermissionName);

        }

    }

}