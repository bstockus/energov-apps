using System;
using System.Collections.Generic;

namespace EnerGov.Business.Abstractions.Identity {

    public class IdentityInfo {

        public class IdentityRoleInfo {

            public class IdentityRolePermissionInfo {

                public string PermissionName { get; set; }

            }

            public Guid RoleId { get; set; }

            public string RoleRoleName { get; set; }
            public string RoleDescription { get; set; }

            public bool RoleIsActive { get; set; }

            public IEnumerable<IdentityRolePermissionInfo> RoleRolePermissions { get; set; }

        }

        public Guid Id { get; set; }

        public string UserName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string EmailAddress { get; set; }

        public string WindowsSid { get; set; }

        public bool IsActive { get; set; }

        public IEnumerable<IdentityRoleInfo> UserRoles { get; set; }

    }

}
