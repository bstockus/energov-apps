namespace EnerGov.Security.User {

    public interface IUserCacheService {

        void FlushCacheForWindowsSid(string windowsSid);
        void FlushEntireCache();

    }

}