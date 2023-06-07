using System;
using System.Collections.Generic;

namespace EnerGov.Security.User {

    public class UserInformation {

        public class UserRoleInformation {

            public string RoleName { get; set; }
            public string Description { get; set; }

        }

        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public string EmailAddress { get; set; }
        public string WindowsSid { get; set; }
        
        public string FirstName { get; set; }
        public string LastName { get; set; }

        public bool IsActive { get; set; }

        public IEnumerable<string> EffectivePermissions { get; set; }

        public IEnumerable<UserRoleInformation> EffectiveRoles { get; set; }

    }

}