using System;
using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Services.Email.Models {

    public class EmailAttachment {
        
        public Guid EmailId { get; set; }
        public string FileName { get; set; }
        public string MimeType { get; set; }
        public byte[] FileContents { get; set; }

        public virtual Email Email { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, EmailAttachment> {

            public override void Build(EntityTypeBuilder<EmailAttachment> builder) {

                builder.ToTable("EmailAttachments", EmailServiceSchemaConstants.SchemaName);

                builder.HasKey(_ => new {
                    _.EmailId,
                    _.FileName
                });

                builder.Property(_ => _.FileName).IsRequired().HasMaxLength(60);
                builder.Property(_ => _.MimeType).IsRequired().HasMaxLength(255);

                builder
                    .HasOne(_ => _.Email)
                    .WithMany(_ => _.Attachments)
                    .HasForeignKey(_ => _.EmailId)
                    .OnDelete(DeleteBehavior.Cascade);

            }

        }

    }

}