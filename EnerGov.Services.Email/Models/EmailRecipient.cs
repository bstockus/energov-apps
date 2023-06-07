using System;
using System.Collections.Generic;
using EnerGov.Data.Configuration;
using Lax.Data.Entities.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace EnerGov.Services.Email.Models {

    public class EmailRecipient {

        public Guid EmailId { get; set; }
        public string ToAddress { get; set; }
        public DateTime? DateSent { get; set; }
        public DateTime? LastSendAttemptDate { get; set; }
        public int SendFailureCount { get; set; }
        public string FailureAddress { get; set; }
        
        public virtual Email Email { get; set; }

        public virtual ICollection<EmailRecipientEvent> EmailRecipientEvents { get; set; } =
            new HashSet<EmailRecipientEvent>();

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, EmailRecipient> {

            public override void Build(EntityTypeBuilder<EmailRecipient> builder) {

                builder.ToTable("EmailRecipients", EmailServiceSchemaConstants.SchemaName);

                builder.HasKey(_ => new {
                    _.EmailId,
                    _.ToAddress
                });

                builder.Property(_ => _.ToAddress).IsRequired().HasMaxLength(255);
                builder.Property(_ => _.FailureAddress).IsRequired(false).HasMaxLength(255);

                builder
                    .HasOne(_ => _.Email)
                    .WithMany(_ => _.Recipients)
                    .HasForeignKey(_ => _.EmailId)
                    .OnDelete(DeleteBehavior.Cascade);

            }

        }

    }

    public class EmailRecipientEvent {

        public Guid EmailId { get; set; }
        public string ToAddress { get; set; }
        public string EventId { get; set; }
        public DateTime TimeStamp { get; set; }
        public string EventType { get; set; }
        public string EventContents { get; set; }

        public virtual EmailRecipient EmailRecipient { get; set; }

        public class EntityModelBuilder : EntityFrameworkModelBuilder<ConfigurationDbContext, EmailRecipientEvent> {

            public override void Build(EntityTypeBuilder<EmailRecipientEvent> builder) {

                builder.ToTable("EmailRecipientEvents", EmailServiceSchemaConstants.SchemaName);

                builder.HasKey(_ => new {
                    _.EmailId,
                    _.ToAddress,
                    _.EventId
                });

                builder.Property(_ => _.ToAddress).IsRequired().HasMaxLength(255);
                builder.Property(_ => _.EventId).IsRequired().HasMaxLength(255);
                builder.Property(_ => _.EventType).IsRequired().HasMaxLength(50);

                builder
                    .HasOne(_ => _.EmailRecipient)
                    .WithMany(_ => _.EmailRecipientEvents)
                    .HasForeignKey(_ => new {
                        _.EmailId,
                        _.ToAddress
                    })
                    .OnDelete(DeleteBehavior.Cascade);

            }

        }

    }

}