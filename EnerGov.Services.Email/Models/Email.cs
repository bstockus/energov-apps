using System;
using System.Collections.Generic;
using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Services.Email.Models {

    public class Email {

        public Guid Id { get; set; }
        public string EmailName { get; set; }
        public EmailType EmailType { get; set; }
        public string FromAddress { get; set; }
        public string Subject { get; set; }
        public string BodyText { get; set; }
        public string BodyHtml { get; set; }

        public virtual ICollection<EmailAttachment> Attachments { get; set; } = new HashSet<EmailAttachment>();
        public virtual ICollection<EmailRecipient> Recipients { get; set; } = new HashSet<EmailRecipient>();

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, Email> {

            public override void Build(EntityTypeBuilder<Email> builder) {

                builder.ToTable("Emails", EmailServiceSchemaConstants.SchemaName);

                builder.HasKey(_ => _.Id);

                builder.Property(_ => _.EmailName).IsRequired().HasMaxLength(100);
                builder.Property(_ => _.FromAddress).IsRequired().HasMaxLength(255);
                builder.Property(_ => _.Subject).IsRequired().HasMaxLength(500);

            }

        }

    }

}
