using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using MediatR;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Primitives;
using EnerGov.Business.Abstractions.Identity;

namespace EnerGov.Security.User {

    public class UserService : IUserService, IUserCacheService {

        private readonly IMediator _mediator;
        private readonly IMemoryCache _memoryCache;
        private readonly ILogger<UserService> _logger;

        private static CancellationTokenSource _resetCancellationTokenSource = new();

        public UserService(
            IMediator mediator,
            IMemoryCache memoryCache,
            ILogger<UserService> logger) {
            _mediator = mediator;
            _memoryCache = memoryCache;
            _logger = logger;
        }

        public async Task<UserInformation> FetchUserInformationByWindowsSid(string windowsSid) {

            if (!_memoryCache.TryGetValue(windowsSid,
                out UserInformation userInformation)) {
                var userInfo = await _mediator.Send(new FetchIdentityByWindowsSidQuery(windowsSid));

                if (userInfo == null) {
                    _logger.LogInformation("Cache Miss for {WindowsSid}, no Active User Found.", windowsSid);
                    return null;
                }

                _logger.LogInformation("Cache Miss for {WindowsSid}, User {UserId} found.", windowsSid, userInfo.Id);

                userInformation = AddUserToCache(userInfo);
            } else {
                _logger.LogInformation("Cache Hit for {WindowsSid}, User {UserId} found.", windowsSid,
                    userInformation.UserId);
            }

            return await Task.FromResult(userInformation);
        }

        public async Task<UserInformation> FetchUserInformationByUserId(Guid userId) {

            if (!_memoryCache.TryGetValue(userId, out UserInformation userInformation)) {

                var userInfo = await _mediator.Send(new FetchIdentityByUserIdQuery(userId));

                if (userInfo == null) {
                    _logger.LogInformation("Cache Miss for {UserId}, no Active User Found.", userId);
                    return null;
                }

                _logger.LogInformation("Cache Miss for  User {UserId} found.", userInfo.Id);

                userInformation = AddUserToCache(userInfo);
            } else {
                _logger.LogInformation("Cache Hit for  User {UserId} found.",
                    userInformation.UserId);
            }

            return await Task.FromResult(userInformation);

        }

        private UserInformation AddUserToCache(IdentityInfo userInfo) {

            UserInformation userInformation;

            userInformation = new UserInformation {
                UserId = userInfo.Id,
                UserName = userInfo.UserName,
                EmailAddress = userInfo.EmailAddress,
                WindowsSid = userInfo.WindowsSid,
                FirstName = userInfo.FirstName,
                LastName = userInfo.LastName,
                IsActive = userInfo.IsActive,
                EffectivePermissions = userInfo.UserRoles.Where(_ => _.RoleIsActive)
                    .SelectMany(_ => _.RoleRolePermissions).Select(_ => _.PermissionName),
                EffectiveRoles = userInfo.UserRoles.Where(_ => _.RoleIsActive).Select(_ =>
                    new UserInformation.UserRoleInformation {
                        RoleName = _.RoleRoleName,
                        Description = _.RoleDescription
                    })
            };

            _memoryCache.Set(userInformation.WindowsSid, userInformation,
                new MemoryCacheEntryOptions()
                    .AddExpirationToken(new CancellationChangeToken(_resetCancellationTokenSource.Token))
                    .SetAbsoluteExpiration(TimeSpan.FromMinutes(15)));

            _memoryCache.Set(userInformation.UserId, userInformation,
                new MemoryCacheEntryOptions()
                    .AddExpirationToken(new CancellationChangeToken(_resetCancellationTokenSource.Token))
                    .SetAbsoluteExpiration(TimeSpan.FromMinutes(15)));
            return userInformation;
        }

        public void FlushCacheForWindowsSid(string windowsSid) {
            _logger.LogInformation("Cache Flush for {WindowsSid}", windowsSid);

            if (_memoryCache.TryGetValue(windowsSid, out _)) {
                _memoryCache.Remove(windowsSid);
            }
        }

        public void FlushEntireCache() {
            _logger.LogInformation("Cache Flush for all entries.");

            if (_resetCancellationTokenSource != null &&
                !_resetCancellationTokenSource.IsCancellationRequested &&
                _resetCancellationTokenSource.Token.CanBeCanceled) {
                _resetCancellationTokenSource.Cancel();
                _resetCancellationTokenSource.Dispose();
            }

            _resetCancellationTokenSource = new CancellationTokenSource();
        }

    }

}