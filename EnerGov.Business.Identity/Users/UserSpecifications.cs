using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace EnerGov.Business.Identity.Users {

    public static class UserSpecifications {

        public static async Task ThrowIfUserDoesNotExist(this DbSet<User> users, Guid userId,
            CancellationToken cancellationToken) {

            if (!await users.AsNoTracking().AnyAsync(_ => _.Id.Equals(userId), cancellationToken)) {
                throw new Exception($"No User with Id '{userId}' exists.");
            }

        }

    }

}