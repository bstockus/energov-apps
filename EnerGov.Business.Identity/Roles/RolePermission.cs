using System;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using EnerGov.Data.Configuration;

namespace EnerGov.Business.Identity.Roles {

    public class RolePermission {

        public Guid RoleId { get; set; }
        public virtual Role Role { get; set; }

        public string PermissionName { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, RolePermission> {

            public override void Build(EntityTypeBuilder<RolePermission> builder) {

                builder.ToTable("RolePermissions", "Identity");

                builder.HasKey(_ => new {
                    _.RoleId,
                    _.PermissionName
                });

                builder.FromValidator(rule => {
                    rule.RuleFor(_ => _.PermissionName).AsRolePermissionPermissionName();
                });

                builder.HasOne(_ => _.Role).WithMany(_ => _.RolePermissions).HasForeignKey(_ => _.RoleId)
                    .OnDelete(DeleteBehavior.Cascade);

            }

        }

    }

}