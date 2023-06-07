using System;

namespace EnerGov.Business.FireOccupancy.Constants {

    public static class InspectionStatus {

        public static readonly Guid Cancelled = Guid.Parse("cf6745d4-02bd-4c22-a520-ceae4e1e0571");
        public static readonly Guid NoViolationsFound = Guid.Parse("21dc38b2-be0d-4cd1-a6ac-054e7b2208f6");
        public static readonly Guid Requested = Guid.Parse("a1e824cd-4837-40fa-ba03-b8ce348193e9");
        public static readonly Guid RequestedAutoCreated = Guid.Parse("4b12378a-01db-4279-af9a-d4b5ec1aef61");
        public static readonly Guid Scheduled = Guid.Parse("9daf0666-1420-4a9c-af19-8b9ebce45769");
        public static readonly Guid ViolationFoundNotResolved = Guid.Parse("b8ef4524-1b1e-46a7-8407-42059eee70d8");
        public static readonly Guid ViolationFoundResolved = Guid.Parse("9e9f0d60-47ac-4fca-ab53-0bfd9ff9a21f");

    }

}
