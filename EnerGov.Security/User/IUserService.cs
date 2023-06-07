using System;
using System.Threading.Tasks;

namespace EnerGov.Security.User {

    public interface IUserService {

        Task<UserInformation> FetchUserInformationByWindowsSid(string windowsSid);

        Task<UserInformation> FetchUserInformationByUserId(Guid userId);

    }

}