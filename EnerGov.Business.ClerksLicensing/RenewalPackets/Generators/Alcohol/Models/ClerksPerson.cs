namespace EnerGov.Business.ClerksLicensing.RenewalPackets.Generators.Alcohol.Models;

public class ClerksPerson {

    public ClerksPerson(string lastName, string firstName, string middleName, string homeAddress) {
        LastName = lastName;
        FirstName = firstName;
        MiddleName = middleName;
        HomeAddress = homeAddress;
    }

    public string LastName { get; }
    public string FirstName { get; }
    public string MiddleName { get; }
    public string HomeAddress { get; }

}