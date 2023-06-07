using EnerGov.Security.User;

namespace EnerGov.Security.Authorization.Requirements {

    public class MustBeActiveUserRequirement : UserBasedRequirement {

        public MustBeActiveUserRequirement() { }

        public class Handler : Handler<MustBeActiveUserRequirement> {

            public Handler(IUserService userService) : base(userService) { }

            protected override bool HandleRequirementForUser(UserInformation userInformation,
                MustBeActiveUserRequirement requirement) =>
                userInformation.IsActive;

        }

    }

}